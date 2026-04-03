import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SoulKnightModifier

//迷迭

import "../../Component"
import "../../../js/XmlData.js" as XmlData
import "../../../js/SeasonData.js" as SeasonData

ColumnLayout {
    Layout.fillWidth: true
    spacing: 20

    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "角色通关详情(若内容溢出，向右拉宽窗口)"

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
                    text: "难度1:"
                    holderText: "当前进度"
                    targetPath: "Events." + "aram_pass_difficulty_" + model.id + "_0"
                    textItem.Layout.preferredWidth: 40
                    textItem.horizontalAlignment: Qt.AlignLeft
                }

                NormalEdit {
                    text: "难度2:"
                    holderText: "当前进度"
                    targetPath: "Events." + "aram_pass_difficulty_" + model.id + "_1"
                    textItem.Layout.preferredWidth: 40
                    textItem.horizontalAlignment: Qt.AlignLeft
                }

                NormalEdit {
                    text: "难度3:"
                    holderText: "当前进度"
                    targetPath: "Events." + "aram_pass_difficulty_" + model.id + "_2"
                    textItem.Layout.preferredWidth: 40
                    textItem.horizontalAlignment: Qt.AlignLeft
                }
            }
        }
    }

    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "赛季任务详情"

        Repeater {
            model: SeasonData.Aram["Events"]
            delegate: RowLayout {
                Layout.fillWidth: true
                spacing: 20

                required property var model
                required property int index

                Text {
                    Layout.preferredWidth: 250
                    text: model.description
                    wrapMode: Text.Wrap
                    font.pixelSize: 15
                    font.bold: true
                    color: Style.textNormal2
                }

                NormalEdit {
                    text: "当前进度: " + (Util.hasKey(modified, "Events." + model.id) ? Util.getJsonValue(modified, "Events." + model.id) : 0) + " / " + model.target
                    holderText: "当前进度"
                    targetPath: "Events." + model.id
                    textItem.Layout.preferredWidth: 150
                    textItem.horizontalAlignment: Qt.AlignLeft
                    inputItem.validator: IntValidator {
                        bottom: 0
                        top: model.target
                    }
                }
            }
        }
    }
}

