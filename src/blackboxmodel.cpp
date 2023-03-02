#include "blackboxmodel.h"
#include <Parser/caninitparser.h>
#include <QDebug>
#include <QFile>
#include <Visitor/caninitvisitor.h>
#include <cassert>

BBVIEWER_BEGIN_NS

BlackBoxModel::BlackBoxModel() : context(getCanInitData())
{
}

void BlackBoxModel::updateContext()
{
    sourceFileObj.close();
    sourceFileObj.setFileName(sourceFile.toLocalFile());

    if (!sourceFileObj.open(QFile::ReadOnly)) {
        assert(false);
    }

    auto data = (ciparser::BBFrame*)sourceFileObj.map(0, sourceFileObj.size());

    context.setData(data, sourceFileObj.size() / sizeof(*data));

    collectData();
}

ciparser::Context BlackBoxModel::getCanInitData()
{
    QFile file(QStringLiteral(CANINIT_TEST_PATH));

    if (!file.open(QFile::ReadOnly | QFile::Text)) {
        assert(false);
    }
    auto data = (char*)file.map(0, file.size());

    ciparser::CanInitParser parser(
            std::make_unique<ciparser::CanInitLexer>(data, file.size()));

    ciparser::CanInitVisitor visitor;

    visitor.visit(parser.parse());

    return ciparser::Context(nullptr, 0, visitor.get_ids());
}

void BlackBoxModel::updatePosition(size_t newPos)
{
    qDebug() << "Update postion:" << context.position() << newPos;

    if (context.position() > newPos) {
        while (context.position() > newPos && context.position() != 0) {
            context.decTick();
        }
    } else {
        while (context.position() < newPos) {
            context.incTick();
        }
    }

    beginResetModel();
    collectData();
    endResetModel();

    emit positionChanged();
}

void BlackBoxModel::collectData()
{
    auto value = context.handle("I52_frn");
    for (int i = 0; i < 100; i++) {
        values[i] = *value;
        context.incTick();
    }
}

int BlackBoxModel::rowCount(const QModelIndex& parent) const
{
    return std::size(values);
}

QVariant BlackBoxModel::data(const QModelIndex& index, int role) const
{
    int idx = index.row();

    switch (role) {
    case Qt::DisplayRole:
        return values[idx];
    }
    return QVariant();
}

BBVIEWER_END_NS
