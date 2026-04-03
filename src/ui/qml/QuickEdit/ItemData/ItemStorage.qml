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

    ListModel { id: materialsModel }
    ListModel { id: seedsModel }
    ListModel { id: tokenTicketsModel }

    ListModel { id: materialsDialogModel }
    ListModel { id: seedsDialogModel }
    ListModel { id: tokenTicketsDialogModel }

    property int itemCardWidth: 110
    property int itemCardMinHeight: 160
    property int itemCardMaxHeight: 200

    function remove(itemInfo, index) {
        if(itemInfo["itemType"] === "materials") {
            materialsModel.remove(index)
            materialsDialogModel.append(itemInfo)
            materialsAddDialog.updateItemData()
        }else if(itemInfo["itemType"] === "seeds") {
            seedsModel.remove(index)
            seedsDialogModel.append(itemInfo)
            seedsAddDialog.updateItemData()
        }else if(itemInfo["itemType"] === "tokenTickets") {
            tokenTicketsModel.remove(index)
            tokenTicketsDialogModel.append(itemInfo)
            tokenTicketsAddDialog.updateItemData()
        }
    }

    function add(itemInfo) {
        if(dirty.hasOwnProperty(itemInfo["itemId"]) && dirty[itemInfo["itemId"]] === 1) SaveGameManager.removeDirty(fileIndex, itemInfo["itemId"])
        else if(!dirty.hasOwnProperty(itemInfo["itemId"])) SaveGameManager.insertDirty(fileIndex, itemInfo["itemId"], 0)
        if(itemInfo["itemType"] === "materials") {
            materialsDialogModel.remove(findIndex(materialsDialogModel, itemInfo["itemId"]))
            materialsModel.append(itemInfo)
        }else if(itemInfo["itemType"] === "seeds") {
            seedsDialogModel.remove(findIndex(seedsDialogModel, itemInfo["itemId"]))
            seedsModel.append(itemInfo)
        }else if(itemInfo["itemType"] === "tokenTickets") {
            tokenTicketsDialogModel.remove(findIndex(tokenTicketsDialogModel, itemInfo["itemId"]))
            tokenTicketsModel.append(itemInfo)
        }
    }

    function findIndex(targetModel, itemId) {
        for(let i = 0;i < targetModel.count;i++) {
            let item = targetModel.get(i)
            if(item.itemId === itemId) return i
        }
    }

    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "材料"

        Flow {
            id: materialsLayout
            Layout.fillWidth: true
            spacing: 20

            Repeater {
                model: materialsModel
                delegate: ItemEdit {
                    width: itemCardWidth
                    height: itemCardMaxHeight
                }
            }

            ToolButton {
                id: materialsAddButton
                width: itemCardWidth
                height: itemCardMinHeight
                icon.source: Style.iconBase + "add-line.svg"
                icon.color: Style.iconNormal2
                icon.width: 60
                icon.height: 60
                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    radius: 10
                    border.width: 2
                    border.color: parent.hovered ? Style.smallCardBorderActive : Style.smallCardBorderNormal

                    Rectangle {
                        anchors.fill: parent
                        radius: 10
                        color: materialsAddButton.pressed ? Style.pressed : (materialsAddButton.hovered ? Style.hovered : "transparent")
                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                }
                onClicked: materialsAddDialog.open()
            }
        }
    }

    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "种子"

        Flow {
            id: seedsLayout
            Layout.fillWidth: true
            spacing: 20

            Repeater {
                model: seedsModel
                delegate: ItemEdit {
                    width: itemCardWidth
                    height: itemCardMaxHeight
                }
            }

            ToolButton {
                id: seedsAddButton
                width: itemCardWidth
                height: itemCardMinHeight
                icon.source: Style.iconBase + "add-line.svg"
                icon.color: Style.iconNormal2
                icon.width: 60
                icon.height: 60
                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    radius: 10
                    border.width: 2
                    border.color: parent.hovered ? Style.smallCardBorderActive : Style.smallCardBorderNormal

                    Rectangle {
                        anchors.fill: parent
                        radius: 10
                        color: seedsAddButton.pressed ? Style.pressed : (seedsAddButton.hovered ? Style.hovered : "transparent")
                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                }
                onClicked: seedsAddDialog.open()
            }
        }
    }

    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "兑换券"

        Flow {
            id: tokenTicketsLayout
            Layout.fillWidth: true
            spacing: 20

            Repeater {
                model: tokenTicketsModel
                delegate: ItemEdit {
                    width: itemCardWidth
                    height: itemCardMaxHeight
                }
            }

            ToolButton {
                id: tokenTicketsAddButton
                width: itemCardWidth
                height: itemCardMinHeight
                icon.source: Style.iconBase + "add-line.svg"
                icon.color: Style.iconNormal2
                icon.width: 60
                icon.height: 60
                background: Rectangle {
                    anchors.fill: parent
                    color: "transparent"
                    radius: 10
                    border.width: 2
                    border.color: parent.hovered ? Style.smallCardBorderActive : Style.smallCardBorderNormal

                    Rectangle {
                        anchors.fill: parent
                        radius: 10
                        color: tokenTicketsAddButton.pressed ? Style.pressed : (tokenTicketsAddButton.hovered ? Style.hovered : "transparent")
                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                                easing.type: Easing.OutQuad
                            }
                        }
                    }
                }
                onClicked: tokenTicketsAddDialog.open()
            }
        }
    }

    Component.onCompleted: {
        materialsModel.clear();
        materialsDialogModel.clear();
        let content = modified["materials"]
        Object.entries(ItemData.ItemMaterial).forEach(([key, value]) => {
            if(content.hasOwnProperty(key)) {
                materialsModel.append({
                    "itemId": key,
                    "itemName": ItemData.ItemMaterial[key]["name"],
                    "itemType": ItemData.ItemMaterial[key]["type"],
                    "itemIcon": ItemData.ItemMaterial[key]["icon"]
                });
                //hasItems.push(key)
            }else {
                materialsDialogModel.append({
                    "itemId": key,
                    "itemName": ItemData.ItemMaterial[key]["name"],
                    "itemType": ItemData.ItemMaterial[key]["type"],
                    "itemIcon": ItemData.ItemMaterial[key]["icon"]
                });
            }
        });
        materialsAddDialog.updateItemData()

        seedsModel.clear();
        seedsDialogModel.clear();
        content = modified["seeds"]
        Object.entries(ItemData.ItemSeed).forEach(([key, value]) => {
            if(content.hasOwnProperty(key)) {
                seedsModel.append({
                    "itemId": key,
                    "itemName": ItemData.ItemSeed[key]["name"],
                    "itemType": ItemData.ItemSeed[key]["type"],
                    "itemIcon": ItemData.ItemSeed[key]["icon"]
                });
                //hasItems.push(key)
            }else {
                seedsDialogModel.append({
                    "itemId": key,
                    "itemName": ItemData.ItemSeed[key]["name"],
                    "itemType": ItemData.ItemSeed[key]["type"],
                    "itemIcon": ItemData.ItemSeed[key]["icon"]
                });
            }
        });
        seedsAddDialog.updateItemData()

        tokenTicketsModel.clear();
        tokenTicketsDialogModel.clear();
        content = modified["tokenTickets"]
        Object.entries(ItemData.ItemTokenTicket).forEach(([key, value]) => {
            if(content.hasOwnProperty(key)) {
                tokenTicketsModel.append({
                    "itemId": key,
                    "itemName": ItemData.ItemTokenTicket[key]["name"],
                    "itemType": ItemData.ItemTokenTicket[key]["type"],
                    "itemIcon": ItemData.ItemTokenTicket[key]["icon"]
                });
                //hasItems.push(key)
            }else {
                tokenTicketsDialogModel.append({
                    "itemId": key,
                    "itemName": ItemData.ItemTokenTicket[key]["name"],
                    "itemType": ItemData.ItemTokenTicket[key]["type"],
                    "itemIcon": ItemData.ItemTokenTicket[key]["icon"]
                });
            }
        });
        tokenTicketsAddDialog.updateItemData()
    }

    /*Connections {
        target: itemDataContainer
        function onNeedReloadStorageItems(obj) {
            hasItems = []
            let content = obj["materials"]
            Object.entries(ItemData.ItemMaterial).forEach(([key, value]) => {
                if(content.hasOwnProperty(key)) {
                    hasItems.push(key)
                }
            });
            content = obj["seeds"]
            Object.entries(ItemData.ItemSeed).forEach(([key, value]) => {
                if(content.hasOwnProperty(key)) {
                    hasItems.push(key)
                }
            });
            content = obj["tokenTickets"]
            Object.entries(ItemData.ItemTokenTicket).forEach(([key, value]) => {
                if(content.hasOwnProperty(key)) {
                    hasItems.push(key)
                }
            });
        }
    }*/

    ItemAddDialog {
        id: materialsAddDialog
        itemData: materialsDialogModel
    }
    ItemAddDialog {
        id: seedsAddDialog
        itemData: seedsDialogModel
    }
    ItemAddDialog {
        id: tokenTicketsAddDialog
        itemData: tokenTicketsDialogModel
    }
}