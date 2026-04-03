import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SoulKnightModifier

import "../../Component"
import "../../../js/SeasonData.js" as SeasonData

ColumnLayout {
    id: cardLayout
    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 20
    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "基本"
        RowLayout {
            id: coinLayout
            Layout.preferredWidth: 330
            Layout.maximumWidth: 330
            spacing: 20

            readonly property int originalCoin: Util.getJsonValue(original, "coin")
            readonly property int modifiedCoin: Util.getJsonValue(modified, "coin")
            property int lastCoin: modifiedCoin

            readonly property string dirtyKey: "coin"
            readonly property bool isDirty: dirty.hasOwnProperty(dirtyKey)

            ColumnLayout {
                Layout.preferredWidth: 100

                Item {
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 100
                    Image {
                        anchors.fill: parent
                        anchors.margins: 10
                        sourceSize.width: 80
                        sourceSize.height: 80
                        source: Style.commonBase + "season_coin.png"
                        fillMode: Image.PreserveAspectFit
                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                    }
                }

                Text {
                    text: "赛季币"
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 15
                    font.bold: true
                    color: Style.textNormal2
                    style: Text.Outline
                    styleColor: coinLayout.isDirty ? Style.textModified : "transparent"
                }
            }
            TextField {
                id: quantityInput
                Layout.preferredWidth: 150
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignVCenter
                text: coinLayout.modifiedCoin
                placeholderText: "数量"
                placeholderTextColor: Style.textPlaceholder
                font.pixelSize: 15
                font.bold: true
                color: Style.textNormal

                horizontalAlignment: TextField.AlignHCenter
                verticalAlignment: TextField.AlignVCenter

                validator: IntValidator {
                    bottom: 0
                    top: 2147483647
                }

                inputMethodHints: Qt.ImhDigitsOnly
                selectByMouse: true

                background: Rectangle {
                    anchors.bottom: parent.bottom
                    color: parent.activeFocus ? Style.indicator : Style.indicator2
                    height: parent.activeFocus ? 2 : 1
                    Behavior on color { ColorAnimation { duration: 150 } }
                    Behavior on height { NumberAnimation { duration: 150 } }
                }

                onActiveFocusChanged: {
                    if(activeFocus) coinLayout.lastCoin = parseInt(text, 10)
                    else text = coinLayout.lastCoin
                }
            }
            ToolButton {
                id: checkButton
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40
                padding: 0
                Layout.alignment: Qt.AlignVCenter
                focusPolicy: Qt.NoFocus
                icon.source: Style.iconBase + "check-line.svg"
                icon.color: Style.iconNormal2
                icon.width: 30
                icon.height: 30

                background: Rectangle {
                    Rectangle {
                        anchors.fill: parent
                        radius: 5
                        color: checkButton.pressed ? Style.pressed : (checkButton.hovered ? Style.hovered : "transparent")
                        Behavior on color {ColorAnimation { duration: 150 }}
                    }
                    border.width: 1
                    border.color: Style.normal
                    color: "transparent"
                    radius: 5
                }

                scale: quantityInput.activeFocus ? 1 : 0
                Behavior on scale {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.OutBack
                    }
                }

                onClicked: {
                    let quantity = parseInt(quantityInput.text, 10)
                    if(quantity > quantityInput.validator.top) quantity = quantityInput.validator.top
                    coinLayout.lastCoin = quantity
                    if(coinLayout.isDirty && dirty[coinLayout.dirtyKey] === quantity) SaveGameManager.removeDirty(fileIndex, coinLayout.dirtyKey)
                    else if(!coinLayout.isDirty && quantity !== coinLayout.originalCoin) SaveGameManager.insertDirty(fileIndex, coinLayout.dirtyKey, coinLayout.originalCoin)
                    SaveGameManager.setValue(fileIndex, "coin", quantity)
                    quantityInput.focus = false
                }
            }
            ToolButton {
                id: closeButton
                Layout.preferredWidth: 40
                Layout.preferredHeight: 40
                padding: 0
                Layout.alignment: Qt.AlignVCenter
                focusPolicy: Qt.NoFocus
                icon.source: Style.iconBase + "close-line.svg"
                icon.color: Style.iconNormal2
                icon.width: 30
                icon.height: 30

                background: Rectangle {
                    Rectangle {
                        anchors.fill: parent
                        radius: 5
                        color: closeButton.pressed ? Style.pressed : (closeButton.hovered ? Style.hovered : "transparent")
                        Behavior on color {ColorAnimation { duration: 150 }}
                    }
                    border.width: 1
                    border.color: Style.normal
                    color: "transparent"
                    radius: 5
                }

                scale: quantityInput.activeFocus ? 1 : 0
                Behavior on scale {
                    NumberAnimation {
                        duration: 150
                        easing.type: Easing.OutBack
                    }
                }

                onClicked: {
                    quantityInput.focus = false
                    quantityInput.text = coinLayout.lastCoin
                }
            }
        }
    }
}