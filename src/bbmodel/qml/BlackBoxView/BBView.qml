import BBViewer 1.0
import QtQuick 2.0
import QtQuick.Controls 2.15

Item {
    property alias bbSource: model.source
    property alias value: model.value
    property real topPadding: 50
    property real labelHeight: 50

    TextInput {
        z: 10
        text: value
        x: 5
        width: parent.width / 2
        height: topPadding
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        font.preferShaping: false
        font.pixelSize: 25
//      fontSizeMode: Text.Fit
        color: "white"
        onAccepted: {
            if (model.contains(text)) {
                value = text
            } else {
                text = value
            }
        }
    }

    Text {
        text: "padding: " + 1
        x: parent.width / 2 + 5
        width: parent.width - x
        height: topPadding
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        font.preferShaping: false
        font.pixelSize: 25
        fontSizeMode: Text.Fit
        color: "white"
    }

    ListView {
        id: view
        y: topPadding
        width: parent.width
        height: parent.height - labelHeight - y
        orientation: ListView.Horizontal
        interactive: false
        property real valueHeight: height / 255

        model: BBModel {
            id: model
        }

        delegate: Rectangle {
            color: "green"
            y: view.height / 2 - display * view.valueHeight - height / 4
            width: view.width / 100
            height: 3
        }

        MouseArea {
            anchors.fill: parent
            property real xBegin
            onPressed: xBegin = mouse.x
            onPositionChanged: {
                let positionStep = Math.round((mouse.x - xBegin) / 2)
                if (Math.abs(positionStep) > 0) {
                    xBegin = mouse.x
                }

                if (model.position + positionStep <= 0) {
                    model.position = 0
                } else {
                    model.position += positionStep
                }
            }
        }

        Rectangle {
            y: parent.height / 2
            color: "#555555"
            width: parent.width
            height: 1
        }
        Rectangle {
            y: parent.height / 4
            color: "#555555"
            width: parent.width
            height: 1
        }
        Rectangle {
            y: parent.height / 2 + parent.height / 4
            color: "#555555"
            width: parent.width
            height: 1
        }
    }

    Text {
        text: model.position
        y: view.height + topPadding
        height: parent.labelHeight
        width: height * 2
        font.preferShaping: false
        font.pixelSize: 25
        fontSizeMode: Text.Fit
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        color: "white"
    }

    Text {
        text: model.position + 100
        y: view.height + topPadding
        x: parent.width - width
        height: parent.labelHeight
        width: height * 2
        font.preferShaping: false
        font.pixelSize: 25
        fontSizeMode: Text.Fit
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        color: "white"
    }

    Rectangle {
        z: -1
        y: topPadding
        color: "black"
        width: parent.width
        height: view.height + 1
        border.color: "white"
        border.width: 1
    }

}
