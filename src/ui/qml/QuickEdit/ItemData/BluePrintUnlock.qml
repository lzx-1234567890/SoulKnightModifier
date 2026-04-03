import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SoulKnightModifier

import "../../Component"
import "../../../js/ItemData.js" as ItemData



ColumnLayout {
    id: cardLayout
    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 20

    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "物品解锁"
        GridLayout {
            Layout.fillWidth: true
            columns: 6
            rowSpacing: 10
            columnSpacing: 10
            Repeater {
                model: ItemData.ItemUnlock
                delegate: Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    ModifySwitch{
                        text: modelData.name
                        listPath: "itemUnlock"
                        target: modelData.target
                    }
                }
            }
        }
    }
    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "特殊票"
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 10
            columnSpacing: 10
            Repeater {
                model: ItemData.SpecialTickets
                delegate: Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    ModifySwitch2{
                        text: modelData.name
                        targetPath: modelData.target
                    }
                }
            }
        }
    }
    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "室内装饰 解锁"
        GridLayout {
            Layout.fillWidth: true
            columns: 4
            rowSpacing: 10
            columnSpacing: 10
            Repeater {
                model: ItemData.BluePrintsRoomDecorate
                delegate: Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    ModifySwitch3{
                        text: modelData.name
                        targetPath: "blueprints"
                        targetKey: modelData.key
                        targetVal: "Researched"
                    }
                }
            }
        }
    }
    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "装饰皮肤 解锁"
        GridLayout {
            Layout.fillWidth: true
            columns: 4
            rowSpacing: 10
            columnSpacing: 10
            Repeater {
                model: ItemData.BluePrintsRoomSkin
                delegate: Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    ModifySwitch3{
                        text: modelData.name
                        targetPath: "blueprints"
                        targetKey: modelData.key
                        targetVal: "Got"
                    }
                }
            }
        }
    }
    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "机甲(设计台) 解锁"
        GridLayout {
            Layout.fillWidth: true
            columns: 6
            rowSpacing: 10
            columnSpacing: 10
            Repeater {
                model: ItemData.BluePrintsMecha
                delegate: Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    ModifySwitch3{
                        text: modelData.name
                        targetPath: "blueprints"
                        targetKey: modelData.key
                        targetVal: "Researched"
                    }
                }
            }
        }
    }
    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "英雄角色 解锁"
        GridLayout {
            Layout.fillWidth: true
            columns: 5
            rowSpacing: 10
            columnSpacing: 10
            Repeater {
                model: ItemData.BluePrintsHero
                delegate: Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    ModifySwitch3{
                        text: modelData.name
                        targetPath: "blueprints"
                        targetKey: modelData.key
                        targetVal: "Researched"
                    }
                }
            }
        }
    }
    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "角色皮肤(设计台) 解锁"
        GridLayout {
            Layout.fillWidth: true
            columns: 4
            rowSpacing: 10
            columnSpacing: 10
            Repeater {
                model: ItemData.BluePrintsSkin
                delegate: Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    ModifySwitch3{
                        text: modelData.name
                        targetPath: "blueprints"
                        targetKey: modelData.key
                        targetVal: "Researched"
                    }
                }
            }
        }
    }
    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "角色技能(设计台) 解锁"
        GridLayout {
            Layout.fillWidth: true
            columns: 3
            rowSpacing: 10
            columnSpacing: 10
            Repeater {
                model: ItemData.BluePrintsSkill
                delegate: Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    ModifySwitch3{
                        text: modelData.name
                        targetPath: "blueprints"
                        targetKey: modelData.key
                        targetVal: "Researched"
                    }
                }
            }
        }
    }
    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "武器(设计台) 解锁"
        GridLayout {
            Layout.fillWidth: true
            columns: 5
            rowSpacing: 10
            columnSpacing: 10
            Repeater {
                model: ItemData.BluePrintsWeapon
                delegate: Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    ModifySwitch3{
                        text: modelData.name
                        targetPath: "blueprints"
                        targetKey: modelData.key
                        targetVal: "Researched"
                    }
                }
            }
        }
    }
    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "武器进化碎片(锻造台) 解锁"
        GridLayout {
            Layout.fillWidth: true
            columns: 5
            rowSpacing: 10
            columnSpacing: 10
            Repeater {
                model: ItemData.BluePrintsWeaponEvolution
                delegate: Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 50
                    ModifySwitch3{
                        text: modelData.name
                        targetPath: "blueprints"
                        targetKey: modelData.blueprint
                        targetVal: "Got"
                    }
                }
            }
        }
    }
}
