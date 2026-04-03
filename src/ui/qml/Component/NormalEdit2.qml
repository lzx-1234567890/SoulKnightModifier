import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SoulKnightModifier

//数组指定索引对象键名修改

RowLayout {
    Layout.fillWidth: true
    spacing: 20

    required property string text
    required property string holderText
    required property string targetPath
    required property string targetKey
    required property int targetIndex

    readonly property int originalValue: (Util.getJsonValue(original, targetPath))[targetIndex][targetKey]
    readonly property int modifiedValue: (Util.getJsonValue(modified, targetPath))[targetIndex][targetKey]

    readonly property string dirtyKey: targetPath + "." + targetKey + "." + targetIndex
    readonly property bool isDirty: dirty.hasOwnProperty(dirtyKey)

    property int lastValue: modifiedValue

    property alias textItem: quantityText
    property alias inputItem: quantityInput

    signal quantityChanged(int quantity)

    Text {
        id: quantityText
        text: parent.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 15
        font.bold: true
        color: Style.textNormal2
        style: Text.Outline
        styleColor: isDirty ? Style.textModified : "transparent"
    }

    TextField {
        id: quantityInput
        Layout.preferredWidth: 150
        Layout.preferredHeight: 40
        Layout.alignment: Qt.AlignVCenter
        text: modifiedValue
        placeholderText: parent.holderText
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
            anchors.bottom: parent.bottom
            color: parent.activeFocus ? Style.indicator : Style.indicator2
            height: parent.activeFocus ? 2 : 1
            Behavior on color { ColorAnimation { duration: 150 } }
            Behavior on height { NumberAnimation { duration: 150 } }
        }

        onActiveFocusChanged: {
            if(activeFocus) lastValue = parseInt(text, 10)
            else text = lastValue
        }
    }

    ToolButton {
        id: checkButton
        Layout.preferredWidth: 40
        Layout.preferredHeight: 40
        padding: 0
        Layout.alignment: Qt.AlignVCenter
        focusPolicy: Qt.NoFocus
        icon.source: Style.iconBase + "check-line.svg"
        icon.color: Style.iconNormal2
        icon.width: 30
        icon.height: 30

        background: Rectangle {
            Rectangle {
                anchors.fill: parent
                radius: 5
                color: parent.pressed ? Style.pressed : (parent.hovered ? Style.hovered : "transparent")
                Behavior on color {ColorAnimation { duration: 150 }}
            }
            border.width: 1
            border.color: Style.normal
            color: "transparent"
            radius: 5
        }

        scale: quantityInput.activeFocus ? 1 : 0
        Behavior on scale {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutBack
            }
        }

        onClicked: {
            let quantity = parseInt(quantityInput.text, 10)
            if(quantity > quantityInput.validator.top) quantity = quantityInput.validator.top
            lastValue = quantity
            let array = Util.getJsonValue(modified, targetPath)
            array[targetIndex][targetKey] = quantity
            if(isDirty && dirty[dirtyKey] === quantity) SaveGameManager.removeDirty(fileIndex, dirtyKey)
            else if(!isDirty && quantity !== originalValue) SaveGameManager.insertDirty(fileIndex, dirtyKey, originalValue)
            SaveGameManager.setValue(fileIndex, targetPath, array)
            quantityInput.focus = false
            quantityChanged(quantity)
        }
    }
    ToolButton {
        id: closeButton
        Layout.preferredWidth: 40
        Layout.preferredHeight: 40
        padding: 0
        Layout.alignment: Qt.AlignVCenter
        focusPolicy: Qt.NoFocus
        icon.source: Style.iconBase + "close-line.svg"
        icon.color: Style.iconNormal2
        icon.width: 30
        icon.height: 30

        background: Rectangle {
            Rectangle {
                anchors.fill: parent
                radius: 5
                color: parent.pressed ? Style.pressed : (parent.hovered ? Style.hovered : "transparent")
                Behavior on color {ColorAnimation { duration: 150 }}
            }
            border.width: 1
            border.color: Style.normal
            color: "transparent"
            radius: 5
        }

        scale: quantityInput.activeFocus ? 1 : 0
        Behavior on scale {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutBack
            }
        }

        onClicked: {
            quantityInput.focus = false
            quantityInput.text = lastValue
        }
    }
}
