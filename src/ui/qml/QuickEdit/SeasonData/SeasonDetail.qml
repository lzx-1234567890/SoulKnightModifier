import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SoulKnightModifier

//枪斗三国

import "../../Component"
import "../../../js/SeasonData.js" as SeasonData

ColumnLayout {
    Layout.fillWidth: true
    spacing: 20

    property var taskData

    readonly property int originalCup: Util.getJsonValue(original, "comboGunData.cupData0.currentCupIndex")
    readonly property int modifiedCup: Util.getJsonValue(modified, "comboGunData.cupData0.currentCupIndex")

    readonly property string dirtyKey: "comboGunData.cupData0.currentCupIndex"
    readonly property bool isDirty: dirty.hasOwnProperty(dirtyKey)

    Component.onCompleted: {
        taskData = Util.getJsonValue(modified, "comboGunData.cupData0.taskSaveDatas")
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
                targetPath: "comboGunData.cupData0.currentTaskExp"
            }
            NormalEdit {
                Layout.fillWidth: true
                text: "获取最终奖励次数:"
                holderText: "获取最终奖励次数"
                targetPath: "comboGunData.cupData0.getUnlimitRewardCount1"
            }
        }
        RowLayout {
            Layout.fillWidth: true
            Layout.margins: 10
            spacing: 20
            NormalEdit {
                Layout.fillWidth: true
                text: "召唤奖券:"
                holderText: "召唤奖券"
                targetPath: "comboGunData.storeData.ticketCount"
            }
        }
        RowLayout {
            Layout.fillWidth: true
            Layout.margins: 10
            spacing: 20
            Text{
                text: "奖杯:"
                Layout.preferredWidth: 50
                Layout.preferredHeight: 50
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 15
                font.bold: true
                color: Style.textNormal2
                style: Text.Outline
                styleColor: isDirty ? Style.textModified : "transparent"
            }
            ButtonGroup { id: cupRadioGroup }
            Repeater {
                model: ["铜杯", "银杯", "金杯", "圣檀杯"]
                delegate: RadioButton {
                    id: cupControl
                    text: modelData
                    ButtonGroup.group: cupRadioGroup
                    Layout.alignment: Qt.AlignVCenter
                    checked: index === modifiedCup

                    indicator: Rectangle {
                        implicitWidth: 26
                        implicitHeight: 26
                        x: (cupControl.width - width) / 2
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
                            opacity: cupControl.checked ? 1 : (cupControl.pressed ? 0.8 : (cupControl.hovered ? 0.5 : 0))
                            Behavior on opacity { OpacityAnimator { duration: 150 } }
                        }
                    }
                    contentItem: Text {
                        text: cupControl.text
                        color: parent.checked ? Style.textNormal3 : Style.textNormal
                        font.pixelSize: 15
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignBottom

                        anchors.top: cupControl.indicator.bottom
                        anchors.topMargin: 8

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }
                    onToggled: {
                        if(checked) {
                            if(isDirty && dirty[dirtyKey] === index) SaveGameManager.removeDirty(fileIndex, dirtyKey)
                            else if(!isDirty && index !== originalCup) SaveGameManager.insertDirty(fileIndex, dirtyKey, originalCup)
                            SaveGameManager.setValue(fileIndex, "comboGunData.cupData0.currentCupIndex", index)
                        }
                    }
                }
            }
        }
        Item {Layout.fillWidth: true;Layout.preferredHeight: 10}
    }
    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "亲卫"

        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 10
            columnSpacing: 10
            Repeater {
                model: SeasonData.ComboGun["Follower"]
                delegate: Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 150

                    required property var model
                    required property int index

                    LevelEdit {
                        text: model.name
                        targetID: model.id
                        targetIDName: "followerConfigId"
                        targetPath: "comboGunData.followerData.followerList"
                        chooseData: ["0", "1", "2", "3", "4"]
                        type: 1
                    }
                }
            }
        }

    }
    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "坐骑"

        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 10
            columnSpacing: 10
            Repeater {
                model: SeasonData.ComboGun["Mount"]
                delegate: Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 150

                    required property var model
                    required property int index

                    LevelEdit {
                        text: model.name
                        targetID: model.id
                        targetIDName: "id"
                        targetPath: "comboGunData.mountData.mountList"
                        chooseData: ["0", "1", "2", "3", "4"]
                        type: 2
                    }
                }
            }
        }
    }
    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "任务详情"

        Repeater {
            model: taskData
            delegate: RowLayout {
                Layout.fillWidth: true
                spacing: 20

                required property var model
                required property int index

                Text {
                    Layout.preferredWidth: 250
                    text: model.GetTaskTimeStamp === -1 ? SeasonData.ComboGun["NormalTasks"][model.Id].description : SeasonData.ComboGun["WeeklyTasks"][model.Id].description
                    wrapMode: Text.Wrap
                    font.pixelSize: 15
                    font.bold: true
                    color: Style.textNormal2
                }

                NormalEdit2 {
                    text: "当前进度: " + model.CurrentScore + " / " + (model.GetTaskTimeStamp === -1 ? SeasonData.ComboGun["NormalTasks"][model.Id].target : SeasonData.ComboGun["WeeklyTasks"][model.Id].target)
                    holderText: "当前进度"
                    targetPath: "comboGunData.cupData0.taskSaveDatas"
                    targetKey: "CurrentScore"
                    targetIndex: index
                    textItem.Layout.preferredWidth: 150
                    textItem.horizontalAlignment: Qt.AlignLeft
                    inputItem.validator: IntValidator {
                        bottom: 0
                        top: (model.GetTaskTimeStamp === -1 ? SeasonData.ComboGun["NormalTasks"][model.Id].target : SeasonData.ComboGun["WeeklyTasks"][model.Id].target)
                    }
                    onQuantityChanged: (quantity) => {
                        model.CurrentScore = quantity
                    }
                }

                ModifySwitch5 {
                    text: "已经领取奖励"
                    targetPath: "comboGunData.cupData0.taskSaveDatas"
                    targetKey: "HasGetReward"
                    targetIndex: index
                    targetCheckedVal: true
                    targetNotCheckedVal: false
                }
                ModifySwitch5 {
                    text: "已完成"
                    targetPath: "comboGunData.cupData0.taskSaveDatas"
                    targetKey: "IsComplete"
                    targetIndex: index
                    targetCheckedVal: true
                    targetNotCheckedVal: false
                }
            }
        }
    }
}

