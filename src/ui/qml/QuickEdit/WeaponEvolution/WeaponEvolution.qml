import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SoulKnightModifier

import "../../Component"
import "../../../js/WeaponEvolutionData.js" as WeaponEvolutionData

ColumnLayout {
    Layout.fillWidth: true
    Layout.fillHeight: true

    required property int fileIndex
    required property var original
    required property var modified
    required property var dirty

    ScrollView {
        id: dataContainer
        Layout.fillWidth: true
        Layout.fillHeight: true
        topPadding: 10
        bottomPadding: 20
        leftPadding: 20
        rightPadding: 20
        contentHeight: cardLayout.height
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            id: cardLayout
            width: dataContainer.availableWidth
            height: weaponLoader.implicitHeight
            spacing: 20

            property string weaponName: WeaponEvolutionData.Weapon[0].name
            property string weaponID: WeaponEvolutionData.Weapon[0].id
            property int weaponLevel: WeaponEvolutionData.Weapon[0].level
            property var weaponSkin: WeaponEvolutionData.Weapon[0].skin
            property int currentWeaponIndex: 0

            property int currentSkinNum: 0
            property int totalSkinNum: WeaponEvolutionData.Weapon[0].skin.length

            function chooseWeapon(idx) {
                currentSkinNum = 0
                currentWeaponIndex = idx
                weaponName = WeaponEvolutionData.Weapon[idx].name
                weaponID = WeaponEvolutionData.Weapon[idx].id
                weaponLevel = WeaponEvolutionData.Weapon[idx].level
                weaponSkin = WeaponEvolutionData.Weapon[idx].skin
                totalSkinNum = WeaponEvolutionData.Weapon[idx].skin.length
            }

            Loader {
                id: weaponLoader
                Layout.fillWidth: true
                sourceComponent: weaponComponent
            }

            WeaponChooseDialog {
                id: weaponChooseDialog
                weaponData: WeaponEvolutionData.Weapon
            }

            Component {
                id: weaponComponent
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 20

                    CardView {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        text: "武器详情"
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
                                    border.color: weaponMouseArea.containsMouse ? Style.smallCardBorderActive : Style.smallCardBorderNormal
                                    border.width: 1
                                    radius: 8

                                    Behavior on border.color {ColorAnimation { duration: 150 }}

                                    MouseArea {
                                        id: weaponMouseArea
                                        anchors.fill: parent
                                        hoverEnabled: true

                                        onClicked: {
                                            weaponChooseDialog.open()
                                        }
                                    }

                                    Rectangle {
                                        anchors.fill: parent
                                        radius: 8
                                        color: weaponMouseArea.pressed ? Style.pressed : (weaponMouseArea.containsMouse ? Style.hovered : "transparent")
                                        Behavior on color {ColorAnimation { duration: 150 }}
                                    }

                                    Image {
                                        anchors.fill: parent
                                        anchors.margins: 20
                                        sourceSize.width: 160
                                        sourceSize.height: 160
                                        source: Style.weaponBase + cardLayout.weaponID + ".png"
                                        fillMode: Image.PreserveAspectFit
                                        horizontalAlignment: Image.AlignHCenter
                                        verticalAlignment: Image.AlignVCenter
                                    }
                                }

                                ToolButton {
                                    text: "切换武器"
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
                                        weaponChooseDialog.open()
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
                                        text: "武器名称: " + cardLayout.weaponName
                                        Layout.preferredWidth: 150
                                        Layout.preferredHeight: 50
                                        verticalAlignment: Text.AlignVCenter
                                        font.pixelSize: 15
                                        font.bold: true
                                        color: Style.textNormal2
                                    }

                                    Text {
                                        text: "武器ID: " + cardLayout.weaponID
                                        Layout.preferredWidth: 150
                                        Layout.preferredHeight: 50
                                        verticalAlignment: Text.AlignVCenter
                                        font.pixelSize: 15
                                        font.bold: true
                                        color: Style.textNormal2
                                    }
                                }
                                RowLayout {
                                    id: levelLayout
                                    Layout.fillWidth: true
                                    spacing: 20

                                    readonly property int originalLevel: Util.hasKey(original, "weapons." + cardLayout.weaponID + ".Level") ? Util.getJsonValue(original, "weapons." + cardLayout.weaponID + ".Level") : 0
                                    readonly property int modifiedLevel: Util.hasKey(modified, "weapons." + cardLayout.weaponID + ".Level") ? Util.getJsonValue(modified, "weapons." + cardLayout.weaponID + ".Level") : 0

                                    readonly property string dirtyKey: "weapons." + cardLayout.weaponID + ".Level"
                                    readonly property bool isDirty: dirty.hasOwnProperty(dirtyKey)

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
                                        model: cardLayout.weaponLevel === 1 ? ["0", "1"] : ["0"]
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
                                                    SaveGameManager.setValue(fileIndex, "weapons." + cardLayout.weaponID + ".Level", index)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    CardView {
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignHCenter
                        text: "皮肤详情  " + cardLayout.currentSkinNum + "/" + cardLayout.totalSkinNum
                        visible: cardLayout.weaponSkin.length >= 1

                        GridLayout {
                            Layout.fillWidth: true
                            columns: 4
                            rowSpacing: 10
                            columnSpacing: 10
                            Repeater {
                                model: cardLayout.weaponSkin
                                delegate: Item {
                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 50

                                    required property string modelData
                                    required property int index

                                    ModifySwitch {
                                        text: modelData
                                        listPath: "weapons." + cardLayout.weaponID + ".UnlockedSkins"
                                        target: cardLayout.weaponID + "_s_" + (index + 1)

                                        onToggled: {
                                            if(checked) cardLayout.currentSkinNum++
                                            else cardLayout.currentSkinNum--
                                        }

                                        Component.onCompleted: {
                                            if(checked) cardLayout.currentSkinNum++
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}

