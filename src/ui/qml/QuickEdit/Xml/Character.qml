import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SoulKnightModifier

import "../../Component"
import "../../../js/XmlData.js" as XmlData

ColumnLayout {
    id: cardLayout
    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 20

    property string characterName: XmlData.Character[0].name
    property string characterEName: XmlData.Character[0].ename
    property int characterID: XmlData.Character[0].id
    property int characterSkillNum: XmlData.Character[0].skillNum
    property int characterSkinNum: XmlData.Character[0].skinNum

    property int currentSkinNum: 0
    property int totalSkinNum: XmlData.Skin[characterID].length

    function chooseCharacter(id) {
        currentSkinNum = 0
        characterName = XmlData.Character[id].name
        characterEName = XmlData.Character[id].ename
        characterID = XmlData.Character[id].id
        characterSkillNum = XmlData.Character[id].skillNum
        characterSkinNum = XmlData.Character[id].skinNum
    }

    Loader {
        Layout.fillWidth: true
        sourceComponent: characterComponent
    }

    CharacterChooseDialog {
        id: characterChooseDialog
        characterData: XmlData.Character
    }

    Component {
        id: characterComponent
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 20

            CardView {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                text: "角色详情"
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 20

                    ColumnLayout {
                        Layout.preferredWidth: 200
                        Layout.preferredHeight: 300
                        spacing: 10

                        Rectangle {
                            Layout.preferredWidth: 200
                            Layout.preferredHeight: 200
                            color: "transparent"
                            border.color: characterMouseArea.containsMouse ? Style.smallCardBorderActive : Style.smallCardBorderNormal
                            border.width: 1
                            radius: 8

                            Behavior on border.color {ColorAnimation { duration: 150 }}

                            MouseArea {
                                id: characterMouseArea
                                anchors.fill: parent
                                hoverEnabled: true

                                onClicked: {
                                    characterChooseDialog.open()
                                }
                            }

                            Rectangle {
                                anchors.fill: parent
                                radius: 8
                                color: characterMouseArea.pressed ? Style.pressed : (characterMouseArea.containsMouse ? Style.hovered : "transparent")
                                Behavior on color {ColorAnimation { duration: 150 }}
                            }

                            Image {
                                anchors.fill: parent
                                anchors.margins: 20
                                sourceSize.width: 160
                                sourceSize.height: 160
                                source: Style.characterBase + characterEName + ".png"
                                fillMode: Image.PreserveAspectFit
                                horizontalAlignment: Image.AlignHCenter
                                verticalAlignment: Image.AlignVCenter
                            }
                        }

                        ToolButton {
                            text: "切换角色"
                            Layout.preferredWidth: 200
                            Layout.preferredHeight: 50

                            background: Rectangle {
                                anchors.fill: parent
                                radius: 5
                                color: parent.pressed ? Style.buttonPressed : (parent.hovered ? Style.buttonHovered : Style.buttonNormal)
                                Behavior on color {ColorAnimation { duration: 150 }}
                            }

                            contentItem: Text {
                                text: parent.text
                                anchors.fill: parent
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 15
                                font.bold: true
                                color: Style.buttonText
                            }

                            onClicked: {
                                characterChooseDialog.open()
                            }
                        }
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTop
                        RowLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignTop
                            spacing: 20

                            Text {
                                text: "角色名称: " + characterName
                                Layout.preferredWidth: 150
                                Layout.preferredHeight: 50
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 15
                                font.bold: true
                                color: Style.textNormal2
                            }

                            Text {
                                text: "角色ID: " + characterID
                                Layout.preferredWidth: 150
                                Layout.preferredHeight: 50
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 15
                                font.bold: true
                                color: Style.textNormal2
                            }

                            ModifySwitch4 {
                                text: "解锁角色"
                                targetPath: "player.c" + characterID + "_unlock"
                                targetCheckedVal: "True"
                                targetNotCheckedVal: "False"
                            }

                        }
                        RowLayout {
                            id: levelLayout
                            Layout.fillWidth: true
                            spacing: 20

                            readonly property int originalLevel: Util.getJsonValue(original, "player.c" + characterID + "_level")
                            readonly property int modifiedLevel: Util.getJsonValue(modified, "player.c" + characterID + "_level")

                            readonly property string dirtyKey: "player.c" + characterID + "_level"
                            readonly property bool isDirty: dirty.hasOwnProperty(dirtyKey)


                            //property bool isLevelDirty: originalLevel !== modifiedLevel

                            //onIsLevelDirtyChanged: {
                                //if(isLevelDirty) modifiedCnt++
                               // else modifiedCnt--
                           // }

                            Text{
                                id: levelText
                                text: "等级:"
                                Layout.preferredWidth: 50
                                Layout.preferredHeight: 50
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 15
                                font.bold: true
                                color: Style.textNormal2
                                style: Text.Outline
                                styleColor: levelLayout.isDirty ? Style.textModified : "transparent"
                            }

                            ButtonGroup { id: radioGroup }
                            Repeater {
                                model: ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
                                delegate: RadioButton {
                                    id: control
                                    text: modelData
                                    ButtonGroup.group: radioGroup
                                    Layout.alignment: Qt.AlignVCenter
                                    checked: index === levelLayout.modifiedLevel

                                    indicator: Rectangle {
                                        implicitWidth: 26
                                        implicitHeight: 26
                                        x: (control.width - width) / 2
                                        y: 0
                                        radius: 13
                                        color: "transparent"
                                        border.color: (parent.hovered || parent.checked) ? Style.radioButtonBorderActive : Style.radioButtonBorderNormal
                                        Behavior on border.color {
                                            ColorAnimation { duration: 150 }
                                        }

                                        Rectangle {
                                            width: 18
                                            height: 18
                                            x: 4
                                            y: 4
                                            radius: 9
                                            color: Style.radioButtonIndicator
                                            opacity: control.checked ? 1 : (control.pressed ? 0.8 : (control.hovered ? 0.5 : 0))
                                            Behavior on opacity { OpacityAnimator { duration: 150 } }
                                        }
                                    }
                                    contentItem: Text {
                                        text: control.text
                                        color: parent.checked ? Style.textNormal3 : Style.textNormal
                                        font.pixelSize: 15
                                        font.bold: true
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignBottom

                                        anchors.top: control.indicator.bottom
                                        anchors.topMargin: 8

                                        Behavior on color {
                                            ColorAnimation { duration: 150 }
                                        }
                                    }
                                    onToggled: {
                                        if(checked) {
                                            if(levelLayout.isDirty && dirty[levelLayout.dirtyKey] === index) SaveGameManager.removeDirty(fileIndex, levelLayout.dirtyKey)
                                            else if(!levelLayout.isDirty && index !== levelLayout.originalLevel) SaveGameManager.insertDirty(fileIndex, levelLayout.dirtyKey, levelLayout.originalLevel)
                                            SaveGameManager.setValue(fileIndex, "player.c" + characterID + "_level", index)
                                        }
                                    }
                                }
                            }
                        }
                        Item { Layout.fillWidth: true; height: 20 }
                        RowLayout {
                            id: skillLayout
                            Layout.fillWidth: true
                            spacing: 20
                            Text{
                                text: "技能:"
                                Layout.preferredWidth: 50
                                Layout.preferredHeight: 50
                                verticalAlignment: Text.AlignVCenter
                                font.pixelSize: 15
                                font.bold: true
                                color: Style.textNormal2
                                visible: XmlData.Skill[characterID].length >= 1
                            }
                            Repeater {
                                model: XmlData.Skill[characterID]
                                delegate: ModifySwitch4 {
                                    required property string modelData
                                    required property int index

                                    text: modelData
                                    targetPath: "player.c_" + characterEName + "_skill_" + (index + 1) + "_unlock"
                                    targetCheckedVal: 1
                                    targetNotCheckedVal: 0
                                }
                            }
                        }
                    }
                }
            }
            CardView {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                text: "皮肤详情  " + currentSkinNum + "/" + totalSkinNum
                visible: XmlData.Skin[characterID].length >= 1

                GridLayout {
                    Layout.fillWidth: true
                    columns: 4
                    rowSpacing: 10
                    columnSpacing: 10
                    Repeater {
                        model: XmlData.Skin[characterID]
                        delegate: Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50

                            required property var model
                            required property int index

                            ModifySwitch4 {
                                text: model.name
                                targetPath: "player.c" + characterID + "_skin" + (index + 1)
                                targetCheckedVal: 1
                                targetNotCheckedVal: model.init

                                onToggled: {
                                    if(checked) currentSkinNum++
                                    else currentSkinNum--
                                }

                                Component.onCompleted: {
                                    if(checked) currentSkinNum++
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}