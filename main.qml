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

        // Статус бар


        // Фон дисплея
        Rectangle {
            id: displayBackground
            width: parent.width
            height: 156
            color: "#04BFAD"
            radius: 28
        }

        // Область отображения
        Item {
            id: displayArea
            x: 39
            y: 68
            width: 281
            height: 98

            Text {
                id: secondaryDisplay
                width: 280
                height: 30
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: calculator.displayValue
                color: theme_1_6
                font.pixelSize: 20
                opacity: 0.7
            }

            Text {
                id: mainDisplay
                width: 281
                height: 60
                anchors.top: secondaryDisplay.bottom
                anchors.topMargin: 8
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                text: calculator.resultValue
                color: theme_1_6
                font.pixelSize: 36
                font.bold: true
            }
        }

        // Сетка кнопок
        Grid {
            id: buttonGrid
            x: 24
            y: 204
            width: 312
            height: 396
            columns: 4
            rows: 5
            spacing: 24

            Repeater {
                model: 20

                CalcButton {
                    width: 60
                    height: 60
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

    Connections {
        target: calculator
        onShowSecretMenu: {
            secretMenu.visible = true
        }
    }

    Image {
        id: pastedImage
        width: 360
        source: "Pasted image.png"
        fillMode: Image.PreserveAspectFit
    }
}
