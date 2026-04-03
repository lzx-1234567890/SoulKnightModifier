import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SoulKnightModifier

//机械狂潮

import "../../Component"
import "../../../js/XmlData.js" as XmlData
import "../../../js/SeasonData.js" as SeasonData

ColumnLayout {
    Layout.fillWidth: true
    spacing: 20

    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "角色通关详情"

        Repeater {
            model: XmlData.Character
            delegate: RowLayout {
                Layout.fillWidth: true
                spacing: 20

                required property var model
                required property int index

                Text {
                    Layout.preferredWidth: 150
                    text: model.name + "通关次数:"
                    font.pixelSize: 15
                    font.bold: true
                    color: Style.textNormal2
                }

                NormalEdit {
                    text: "普通:"
                    holderText: "当前进度"
                    targetPath: "Events." + "iron_tide_clear_normal_" + model.ename
                    textItem.Layout.preferredWidth: 40
                    textItem.horizontalAlignment: Qt.AlignLeft
                }

                Item {Layout.preferredWidth: 100;Layout.preferredHeight: 1}

                NormalEdit {
                    text: "炸天:"
                    holderText: "当前进度"
                    targetPath: "Events." + "iron_tide_clear_badass_" + model.ename
                    textItem.Layout.preferredWidth: 40
                    textItem.horizontalAlignment: Qt.AlignLeft
                }
            }
        }
    }

    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "角色通关奖励领取详情"

        Repeater {
            model: XmlData.Character
            delegate: RowLayout {
                Layout.fillWidth: true
                spacing: 20

                required property var model
                required property int index

                Text {
                    Layout.preferredWidth: 200
                    text: model.name + "通关奖励领取:"
                    font.pixelSize: 15
                    font.bold: true
                    color: Style.textNormal2
                }

                ModifySwitch2 {
                    text: "普通"
                    targetPath: "Events." + "iron_tide_reward_normal_" + model.ename
                }

                ModifySwitch2 {
                    text: "炸天"
                    targetPath: "Events." + "iron_tide_reward_badass_" + model.ename
                }
            }
        }
    }

    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "芯片"

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 50
            Repeater {
                model: SeasonData.IronTide["chip"]
                delegate: LevelEdit2 {
                    required property var model
                    required property int index

                    Layout.preferredWidth: 200
                    text: model.name
                    levelText: "等级:"
                    levelText2: "精炼等级:"
                    targetID: model.id
                    targetPath: "chips"
                    targetIDName: "chipName"
                    targetLevelName: "level"
                    targetLevelName2: "refineLevel"
                    chooseData: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
                    chooseData2: ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
                    type: 0
                }
            }

            Item {Layout.fillWidth: true;Layout.preferredHeight: 30}
        }
    }
}

