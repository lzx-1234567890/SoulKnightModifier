import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SoulKnightModifier

Rectangle {
    Layout.fillWidth: true
    Layout.preferredHeight: 75
    color: Style.toolbarBg

    signal buttonClicked(int index)

    RowLayout {
        anchors.fill: parent
        anchors.rightMargin: 15
        spacing: 25

        Item {Layout.fillWidth: true}

        Repeater {
            model: ["导出加密文件", "导出解密文件", "保存"]

            NormalButton {
                btnText: modelData
                fontSize: 15

                onClicked: buttonClicked(index)
            }
        }
    }
}