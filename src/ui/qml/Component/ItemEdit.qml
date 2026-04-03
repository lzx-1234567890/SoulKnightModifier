import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.impl
import QtQuick.Effects
import SoulKnightModifier

Item {
    id: itemContainer
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.alignment: Qt.AlignTop

    opacity: 0
    scale: 0.1

    required property string itemName
    required property string itemId
    required property string itemType
    required property string itemIcon
    required property int index

    //property int originalValue: getQuantity(saveInfo.originalContent)
    //property int modifiedValue: getQuantity(saveInfo.modifiedContent)
    //readonly property bool isValueDirty: originalValue !== modifiedValue

    property int lastQuantity: modifiedQuantity

    //onIsValueDirtyChanged: {
        //if(isValueDirty) modifiedCnt++;
        //else modifiedCnt--;
    //}

    readonly property int originalQuantity: getQuantity(original)
    readonly property int modifiedQuantity: getQuantity(modified)

    readonly property string dirtyKey: itemId
    readonly property bool isDirty: dirty.hasOwnProperty(dirtyKey)


    Component.onCompleted: {
        appearAnim.start()
    }

    ParallelAnimation {
        id: appearAnim
        NumberAnimation {
            target: itemContainer; property: "opacity"; to: 1
            duration: 250
        }
        NumberAnimation {
            target: itemContainer; property: "scale"; to: 1
            duration: 350; easing.type: Easing.OutBack
        }
    }

    ParallelAnimation {
        id: disappearAnim
        NumberAnimation {
            target: itemContainer; property: "opacity"; to: 0
            duration: 200
        }
        NumberAnimation {
            target: itemContainer; property: "scale"; to: 0
            duration: 200; easing.type: Easing.InBack
        }

        onFinished: {
            let info = {
                "itemName": itemContainer.itemName,
                "itemId": itemContainer.itemId,
                "itemType": itemContainer.itemType,
                "itemIcon": itemContainer.itemIcon
            }
            cardLayout.remove(info, itemContainer.index)
        }
    }

    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        color: "transparent"
        radius: 10
        border.width: 2
        border.color: quantityInput.activeFocus ? Style.smallCardBorderActive : Style.smallCardBorderNormal

        property real currentHeight: quantityInput.activeFocus ? 200 : 160
        Layout.preferredHeight: currentHeight
        implicitHeight: currentHeight

        Behavior on border.color {
            ColorAnimation { duration: 150 }
        }

        Behavior on currentHeight {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutQuad
            }
        }

        Rectangle {
            anchors.fill: parent
            color: itemMouseArea.pressed ? Style.smallCardBgPressed : Style.smallCardBgNormal
            radius: 10
            Behavior on color {
                ColorAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }
        }

        MouseArea {
            id: itemMouseArea
            anchors.fill: parent
            hoverEnabled: true
        }

        ColumnLayout {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            height: 150

            Text {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                text: itemName
                font.pointSize: 12
                minimumPointSize: 5
                font.bold: true
                fontSizeMode: Text.Fit
                color: quantityInput.activeFocus ? Style.textNormal3 : Style.textNormal2
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                style: Text.Outline
                styleColor: isDirty ? Style.textModified : "transparent"
                elide: Text.ElideNone
                wrapMode: Text.NoWrap
                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            Image {
                Layout.preferredWidth: 80
                Layout.preferredHeight: 80
                Layout.alignment: Qt.AlignHCenter
                sourceSize.width: 80
                sourceSize.height: 80
                source: itemIcon
                fillMode: Image.PreserveAspectFit
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
            }

            RowLayout {
                Layout.fillWidth: true
                TextField {
                    id: quantityInput
                    Layout.fillWidth: true
                    text: modifiedQuantity
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
                        color: "transparent"
                    }

                    onActiveFocusChanged: {
                        if(activeFocus) {
                            lastQuantity = parseInt(text, 10)
                        }else {
                            text = lastQuantity
                        }
                    }
                }
            }
        }

        RowLayout {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 50
            opacity: quantityInput.activeFocus ? 1.0 : 0.0
            visible: opacity > 0
            Behavior on opacity { NumberAnimation { duration: 150 } }

            Item { Layout.fillWidth: true }

            ToolButton {
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                padding: 0
                Layout.alignment: Qt.AlignCenter
                focusPolicy: Qt.NoFocus
                icon.source: Style.iconBase + "close-line.svg"
                icon.color: Style.iconNormal2
                icon.width: 25
                icon.height: 25
                background: Rectangle {
                    color: parent.pressed ? Style.pressed : (parent.hovered ? Style.hovered : "transparent")
                    radius: 5
                }

                onClicked: {
                    quantityInput.focus = false
                    quantityInput.text = lastQuantity
                }
            }

            Item { Layout.fillWidth: true }

            ToolButton {
                Layout.preferredWidth: 30
                Layout.preferredHeight: 30
                padding: 0
                Layout.alignment: Qt.AlignCenter
                focusPolicy: Qt.NoFocus
                icon.source: Style.iconBase + "check-line.svg"
                icon.color: Style.iconNormal2
                icon.width: 25
                icon.height: 25
                background: Rectangle {
                    color: parent.pressed ? Style.pressed : (parent.hovered ? Style.hovered : "transparent")
                    radius: 5
                }

                onClicked: {
                    if(quantityInput.text === "") quantityInput.text = lastQuantity
                    else if(quantityInput.text !== "0") {
                        lastQuantity = parseInt(quantityInput.text, 10)
                        if(lastQuantity > quantityInput.validator.top) lastQuantity = quantityInput.validator.top
                        setQuantity(lastQuantity)
                    }else {
                        enabled = false
                        lastQuantity = 0
                        let obj = modified
                        Util.removeKey(obj, itemType + "." + itemId)
                        if(isDirty && dirty[dirtyKey] === 0) SaveGameManager.removeDirty(fileIndex, dirtyKey)
                        else if(!isDirty && dirty[dirtyKey] !== originalQuantity) SaveGameManager.insertDirty(fileIndex, dirtyKey, originalQuantity)
                        SaveGameManager.setValue(fileIndex, itemType, Util.getJsonValue(obj, itemType))
                        disappearAnim.start()
                    }
                    quantityInput.focus = false
                }
            }

            Item { Layout.fillWidth: true }
        }
    }
    function getQuantity(obj) {
        if(!Util.hasKey(obj, itemType + "." + itemId)) return 0
        return Util.getJsonValue(obj, itemType + "." + itemId)
    }

    function setQuantity(num) {
        if(isDirty && dirty[dirtyKey] === num) SaveGameManager.removeDirty(fileIndex, dirtyKey)
        else if(!isDirty && num !== originalQuantity) SaveGameManager.insertDirty(fileIndex, dirtyKey, originalQuantity)
        SaveGameManager.setValue(fileIndex, itemType + "." + itemId, num)
    }
}