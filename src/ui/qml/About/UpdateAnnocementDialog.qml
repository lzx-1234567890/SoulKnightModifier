import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import SoulKnightModifier

Dialog {
    id: control
    modal: true
    dim: true

    width: 500
    property real maxHeight: 600

    padding: 20

    height: Math.min(implicitHeight, maxHeight)

    anchors.centerIn: Overlay.overlay

    property string text: "
---
### v0.1(2026-4-04)
- 初始版本
"

    background: Rectangle {
        color: Style.dialogBg
        border.color: Style.line
        border.width: 2
        radius: 10
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#80000000"
            shadowBlur: 1.0
        }
    }

    contentItem: ColumnLayout {
        spacing: 15

        ScrollView {
            id: dataContainer
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            contentWidth: availableWidth
            ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

            ColumnLayout {
                id: dataLayout
                width: dataContainer.availableWidth
                spacing: 10

                Text {
                    Layout.fillWidth: true
                    text: "更新公告"
                    color: Style.textNormal2
                    font.pixelSize: 20
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                }

                Text {
                    text: control.text
                    Layout.fillWidth: true
                    color: Style.textNormal
                    font.pixelSize: 15
                    wrapMode: Text.WordWrap
                    lineHeight: 1.2
                    textFormat: Text.MarkdownText
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Item { Layout.fillWidth: true }

            NormalButton {
                btnText: "关闭"
                fontSize: 15
                onClicked: {
                    control.close()
                }
            }
        }
    }

    enter: Transition {
        NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: 200; easing.type: Easing.OutBack }
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200 }
    }
}