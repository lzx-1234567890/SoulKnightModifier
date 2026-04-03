import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SoulKnightModifier

import "../../Component"

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
            id: gemLayout
            Layout.preferredWidth: 330
            Layout.maximumWidth: 330
            Layout.preferredHeight: 100
            spacing: 20

            readonly property int originalGems: Util.getJsonValue(original, "player.gems")
            readonly property int modifiedGems: Util.getJsonValue(modified, "player.gems")
            property int lastGems: modifiedGems
            //readonly property bool isGemsDirty: originalGems !== modifiedGems

            readonly property string dirtyKey: "gems"
            readonly property bool isDirty: dirty.hasOwnProperty(dirtyKey)

            //onIsGemsDirtyChanged: {
                //if(isGemsDirty) modifiedCnt++
               // else modifiedCnt--
            //}

            ColumnLayout {
                Layout.preferredWidth: 100
                Layout.fillHeight: true

                Image {
                    Layout.preferredWidth: 80
                    Layout.preferredHeight: 80
                    sourceSize.width: 80
                    sourceSize.height: 80
                    source: Style.commonBase + "gem.png"
                    fillMode: Image.PreserveAspectFit
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                }
                Text {
                    text: "宝石"
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 15
                    font.bold: true
                    color: Style.textNormal2
                    style: Text.Outline
                    styleColor: gemLayout.isDirty ? Style.textModified : "transparent"
                }
            }
            TextField {
                id: quantityInput
                Layout.preferredWidth: 150
                Layout.preferredHeight: 40
                Layout.alignment: Qt.AlignVCenter
                text: gemLayout.modifiedGems
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
                    if(activeFocus) gemLayout.lastGems = parseInt(text, 10)
                    else text = gemLayout.lastGems
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
                    gemLayout.lastGems = quantity
                    if(gemLayout.isDirty && dirty[gemLayout.dirtyKey] === quantity) SaveGameManager.removeDirty(fileIndex, gemLayout.dirtyKey)
                    else if(!gemLayout.isDirty && quantity !== gemLayout.originalGems) SaveGameManager.insertDirty(fileIndex, gemLayout.dirtyKey, gemLayout.originalGems)
                    SaveGameManager.setValue(fileIndex, "player.gems", quantity)
                    SaveGameManager.setValue(fileIndex, "player.last_gems", quantity)
                    SaveGameManager.setValue(fileIndex, "player.var_gems", 0)
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
                    quantityInput.text = gemLayout.lastGems
                }
            }
        }
        Item {
            Layout.preferredHeight: 30
            Layout.fillWidth: true
        }
        RowLayout {
            Layout.preferredWidth: 150
            Layout.maximumWidth: 150
            Layout.preferredHeight: 100
            spacing: 20

            Image {
                Layout.preferredWidth: 80
                Layout.preferredHeight: 80
                sourceSize.width: 80
                sourceSize.height: 80
                source: Style.commonBase + "reborn_card.png"
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
            }

            ModifySwitch2{
                text: "超级复活卡"
                targetPath: "player.reborn_card"
            }
        }

    }
}