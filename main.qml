import QtQuick 2.15
import QtQuick.Window 2.15

Window {
    id: window
    width: 360
    height: 640
    visible: true
    title: "Calculator"
    minimumWidth: 360
    minimumHeight: 640
    maximumWidth: 360
    maximumHeight: 640

    property color theme_1_1: "#024873"
    property color theme_1_2: "#0889A6"
    property color theme_1_3: "#048FAD"
    property color theme_1_4: "#800108"
    property color theme_1_5: "#72555E"
    property color theme_1_6: "#FFFFFF"
    property color theme_1_add_1: "#00F79C"
    property color theme_1_add_2: "#77E425"
    property color theme_1_1_30: "#024873"
    property color theme_1_3_30: "#04BFAD"
    property color theme_1_4_50: "#B0D1D8"

    property var buttonLabels: [
        "()", "±", "%", "/",
        "7", "8", "9", "*",
        "4", "5", "6", "-",
        "1", "2", "3", "+",
        "C", "0", ".", "="
    ]

    property var buttonColors: [
        theme_1_2, theme_1_2, theme_1_2, theme_1_2,
        theme_1_4_50, theme_1_4_50, theme_1_4_50, theme_1_2,
        theme_1_4_50, theme_1_4_50, theme_1_4_50, theme_1_2,
        theme_1_4_50, theme_1_4_50, theme_1_4_50, theme_1_2,
        theme_1_4, theme_1_4_50, theme_1_4_50, theme_1_2
    ]

    property var pressedColors: [
        theme_1_3_30, theme_1_3_30, theme_1_3_30, theme_1_3_30,
        theme_1_3_30, theme_1_3_30, theme_1_3_30, theme_1_3_30,
        theme_1_3_30, theme_1_3_30, theme_1_3_30, theme_1_3_30,
        theme_1_3_30, theme_1_3_30, theme_1_3_30, theme_1_3_30,
        theme_1_3_30, theme_1_3_30, theme_1_3_30, theme_1_3_30
    ]

    property var textColors: [
        theme_1_6, theme_1_6, theme_1_6, theme_1_6,
        theme_1_1, theme_1_1, theme_1_1, theme_1_6,
        theme_1_1, theme_1_1, theme_1_1, theme_1_6,
        theme_1_1, theme_1_1, theme_1_1, theme_1_6,
        theme_1_6, theme_1_1, theme_1_1, theme_1_6
    ]

    Rectangle {
        id: secretMenu
        anchors.fill: parent
        color: theme_1_1
        visible: false
        z: 10

        Text {
            text: "Секретное меню"
            anchors.centerIn: parent
            color: theme_1_6
            font.pixelSize: 24
        }

        CalcButton {
            text: "Назад"
            width: 100
            height: 50
            anchors {
                bottom: parent.bottom
                horizontalCenter: parent.horizontalCenter
                bottomMargin: 20
            }
            onClicked: {
                secretMenu.visible = false
            }
        }
    }

    Rectangle {
        id: mainCalculator
        anchors.fill: parent
        color: theme_1_1
        visible: !secretMenu.visible

        Item {
            anchors.fill: parent
            anchors.margins: 20

            Column {
                id: displayArea
                width: parent.width
                anchors.top: parent.top
                spacing: 5

                Text {
                    id: secondaryDisplay
                    width: parent.width
                    horizontalAlignment: Text.AlignRight
                    text: calculator.displayValue
                    color: theme_1_6
                    font.pixelSize: 20
                    opacity: 0.7
                }

                Text {
                    id: mainDisplay
                    width: parent.width
                    horizontalAlignment: Text.AlignRight
                    text: calculator.resultValue
                    color: theme_1_6
                    font.pixelSize: 36
                    font.bold: true
                }
            }

            Grid {
                id: buttonGrid
                width: parent.width
                anchors.top: displayArea.bottom
                anchors.topMargin: 20
                anchors.bottom: parent.bottom
                columns: 4
                rows: 5
                spacing: 10

                Repeater {
                    model: 20

                    Item {
                        width: (buttonGrid.width - 30) / 4
                        height: (buttonGrid.height - 40) / 5

                        CalcButton {
                            width: Math.min(parent.width, parent.height)
                            height: width
                            anchors.centerIn: parent
                            text: buttonLabels[index]
                            backgroundColor: buttonColors[index]
                            textColor: textColors[index]
                            pressedColor: pressedColors[index]

                            onClicked: {
                                if (text === "=") {
                                    calculator.calculate();
                                } else if (text === "C") {
                                    calculator.clear();
                                }
                                else {
                                    calculator.buttonPressed(text);
                                }
                            }

                            onLongPressed: {
                                if (text === "=") {
                                    calculator.handleLongEqualPress();
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: calculator
        onShowSecretMenu: {
            secretMenu.visible = true
        }
    }
}
