import QtQuick 2.15

Rectangle {
    id: root
    property string text: ""
    property color backgroundColor: "#0889A6"
    property color textColor: "#FFFFFF"
    property color pressedColor: "#77E425"
    property int longPressDuration: 4000
    property string fontFamily: "Arial"
    property real fontSize: 24
    property real fontLetterSpacing: 0

    signal clicked()
    signal longPressed()

    radius: width / 2
    color: ma.pressed ? pressedColor : backgroundColor

    Text {
        text: root.text
        anchors.centerIn: parent
        color: textColor
        font.family: root.fontFamily
        font.pixelSize: root.fontSize
    }

    MouseArea {
        id: ma
        anchors.fill: parent
        onClicked: {
            root.clicked()
        }

        onPressAndHold: {
            root.longPressed()
        }
    }
}
