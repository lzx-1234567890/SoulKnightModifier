import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SoulKnightModifier

//迷迭2  神器2 大大指挥官

import "../../Component"

ColumnLayout {
    Layout.fillWidth: true
    spacing: 20

    required property string seasonName
    required property string seasonID
    required property var seasonData

    property var seasonNormalTaskData
    property var seasonWeeklyTaskData

    Component.onCompleted: {
        seasonNormalTaskData = Util.getJsonValue(modified, seasonID + "ChampionNormalTasks")
        seasonWeeklyTaskData = Util.getJsonValue(modified, seasonID + "ChampionWeeklyTasks")
    }

    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "通用"

        RowLayout {
            Layout.fillWidth: true
            Layout.margins: 10
            spacing: 20
            NormalEdit {
                Layout.fillWidth: true
                text: "经验:"
                holderText: "经验"
                targetPath: seasonID + "TaskExp"
            }
        }
        RowLayout {
            Layout.fillWidth: true
            Layout.margins: 10
            spacing: 20
            NormalEdit {
                Layout.fillWidth: true
                text: "等级:"
                holderText: "等级"
                targetPath: seasonID + "TrophyLevel"
            }
            NormalEdit {
                Layout.fillWidth: true
                text: "已获取奖励等级:"
                holderText: "已获取奖励等级"
                targetPath: seasonID + "ClaimedTrophyLevel"
            }
        }
    }
    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "任务详情"

        Repeater {
            model: [seasonWeeklyTaskData, seasonNormalTaskData]
            delegate: Repeater {
                model: modelData
                delegate: RowLayout {
                    Layout.fillWidth: true
                    spacing: 20

                    required property var model
                    required property int index

                    Text {
                        Layout.preferredWidth: 250
                        text: (model.GetTaskTimeStamp === 0 ? seasonData["NormalTasks"][model.Id].description : seasonData["WeeklyTasks"][model.Id].description)
                        wrapMode: Text.Wrap
                        font.pixelSize: 15
                        font.bold: true
                        color: Style.textNormal2
                    }

                    NormalEdit2 {
                        text: "当前进度: " + model.CurrentScore + " / " + (model.GetTaskTimeStamp === 0 ? seasonData["NormalTasks"][model.Id].target : seasonData["WeeklyTasks"][model.Id].target)
                        holderText: "当前进度"
                        targetPath: seasonID + (model.GetTaskTimeStamp === 0 ? "ChampionNormalTasks" : "ChampionWeeklyTasks")
                        targetKey: "CurrentScore"
                        targetIndex: index
                        textItem.Layout.preferredWidth: 150
                        textItem.horizontalAlignment: Qt.AlignLeft
                        inputItem.validator: IntValidator {
                            bottom: 0
                            top: (model.GetTaskTimeStamp === 0 ? seasonData["NormalTasks"][model.Id].target : seasonData["WeeklyTasks"][model.Id].target)
                        }
                        onQuantityChanged: (quantity) => {
                            model.CurrentScore = quantity
                        }
                    }

                    ModifySwitch5 {
                        text: "已经领取奖励"
                        targetPath: seasonID + (model.GetTaskTimeStamp === 0 ? "ChampionNormalTasks" : "ChampionWeeklyTasks")
                        targetKey: "HasGetReward"
                        targetIndex: index
                        targetCheckedVal: true
                        targetNotCheckedVal: false
                    }
                    ModifySwitch5 {
                        text: "已完成"
                        targetPath: seasonID + (model.GetTaskTimeStamp === 0 ? "ChampionNormalTasks" : "ChampionWeeklyTasks")
                        targetKey: "IsComplete"
                        targetIndex: index
                        targetCheckedVal: true
                        targetNotCheckedVal: false
                    }
                }
            }
        }
    }
}

