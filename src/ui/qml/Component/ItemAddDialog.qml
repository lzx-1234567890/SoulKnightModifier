import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SoulKnightModifier

Dialog {
    id: itemAddDialog
    title: "添加物品"

    width: 450
    height: 600
    modal: true

    anchors.centerIn: Overlay.overlay

    required property var itemData

    ListModel { id: filteredItemDataModel }

    enter: Transition {
        NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: 200; easing.type: Easing.OutBack }
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200 }
    }

    function updateItemData() {
        filterData(searchInput.text)
    }

    function filterData(searchText) {
        if(!itemData) return
        itemListView.model = null
        filteredItemDataModel.clear()
        var safeSearchText = searchText || ""
        var lowerSearchText = safeSearchText.toLowerCase()
        for (var i = 0; i < itemData.count; i++) {
            var item = itemData.get(i)
            if (safeSearchText === "" ||
                item.itemId.toLowerCase().indexOf(lowerSearchText) !== -1 ||
                item.itemName.toLowerCase().indexOf(lowerSearchText) !== -1) {
                filteredItemDataModel.append({
                    "itemId": item.itemId,
                    "itemName": item.itemName,
                    "itemType": item.itemType,
                    "itemIcon": item.itemIcon
                })
            }
        }
        itemListView.model = filteredItemDataModel
    }

    Transition {
        id: removeTransition
        ParallelAnimation {
            NumberAnimation {
                property: "opacity"; to: 0
                duration: 250; easing.type: Easing.OutQuad
            }
            NumberAnimation {
                property: "x"; to: itemListView.width / 2
                duration: 250; easing.type: Easing.OutQuad
            }
        }
    }

    Transition {
        id: displacedTransition
        NumberAnimation {
            properties: "x,y"
            duration: 250; easing.type: Easing.OutQuad
        }
    }

    background: Rectangle {
        color: Style.dialogBg
        radius: 10
        border.color: Style.dialogBorder
        border.width: 1
    }

    header: Rectangle {
        width: parent.width
        height: 60
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            anchors.rightMargin: 20
            anchors.leftMargin: 20
            color: "transparent"

            Text {
                anchors.centerIn: parent
                text: "添加物品"
                color: Style.textNormal2
                font.pixelSize: 15
                font.bold: true
                horizontalAlignment: Text.horizontalAlignment
            }

            ToolButton {
                implicitWidth: 30
                implicitHeight: 30
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                padding: 0

                icon.source: Style.iconBase + "close-line.svg"
                icon.color: Style.iconNormal2
                icon.width: 25
                icon.height: 25

                background: Rectangle {
                    color: Style.dialogClose
                    radius: 5
                    opacity: parent.pressed ? 0.8 : (parent.hovered ? 0.4 : 0)
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                onClicked: itemAddDialog.close()
            }
        }
    }

    contentItem: ColumnLayout {
        spacing: 15

        TextField {
            id: searchInput
            Layout.fillWidth: true
            Layout.preferredHeight: 45

            placeholderText: "输入物品名称搜索..."
            placeholderTextColor: Style.inputPlaceholder
            font.pixelSize: 15
            color: Style.inputText
            verticalAlignment: TextField.AlignVCenter

            background: Rectangle {
                color: Style.inputBg
                radius: 8
                border.width: 2
                border.color: searchInput.activeFocus ? Style.inputBorderActive : Style.inputBorderNormal

                Behavior on border.color { ColorAnimation { duration: 150 } }
            }

            onTextChanged: {
                filterData(text)
            }
        }

        ListView {
            id: itemListView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: 20
            clip: true
            spacing: 5

            model: filteredItemDataModel

            remove: removeTransition
            displaced: displacedTransition

            ScrollBar.vertical: ScrollBar {
                active: true
            }

            delegate: Item {
                width: itemListView.width
                height: 60

                required property string itemName
                required property string itemId
                required property string itemType
                required property string itemIcon
                required property int index

                Rectangle {
                    anchors.fill: parent
                    radius: 8
                    color: itemMouseArea.pressed ? Style.pressed : (itemMouseArea.containsMouse ? Style.hovered : "transparent")
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                MouseArea {
                    id: itemMouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 10
                    anchors.topMargin: 10
                    anchors.bottomMargin: 10
                    anchors.rightMargin: 25
                    spacing: 15

                    Image {
                        Layout.preferredWidth: 40
                        Layout.preferredHeight: 40
                        sourceSize.width: 40
                        sourceSize.height: 40
                        source: itemIcon
                        fillMode: Image.PreserveAspectFit
                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                    }

                    Text {
                        Layout.fillWidth: true
                        text: itemName
                        color: Style.textNormal
                        font.pixelSize: 15
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    ToolButton {
                        Layout.preferredWidth: 80
                        Layout.preferredHeight: 35
                        text: "添加"

                        background: Rectangle {
                            color: parent.pressed ? Style.buttonPressed : (parent.hovered ? Style.buttonHovered : Style.buttonNormal)
                            radius: 5
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }

                        contentItem: Text {
                            text: parent.text
                            font.bold: true
                            color: Style.buttonText
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            enabled = false
                            let obj = modified
                            Util.setJsonValue(obj, itemType + "." + itemId, 1)
                            SaveGameManager.setValue(fileIndex, itemType, Util.getJsonValue(obj, itemType))
                            cardLayout.add({
                                "itemName": itemName,
                                "itemId": itemId,
                                "itemType": itemType,
                                "itemIcon": itemIcon
                            })
                            filteredItemDataModel.remove(index)
                        }
                    }
                }
            }
        }
    }
}