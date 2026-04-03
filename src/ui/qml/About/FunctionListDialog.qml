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
- &#x2611; XML(蓝币 复活卡 角色等级/技能/皮肤 宠物)
- &#x2611; ItemData(蓝图解锁 神话武器 饰品 材料/种子/兑换券)
- &#x2611; WeaponEvolutionData(武器进化/皮肤)
- &#x2611; SeasonData(赛季币 新赛季数据(迷迭岛2-机械狂潮 仅迷迭岛1为90%进度))
- &#x2610; StatisticData(地窖数据 旧赛季数据(小小指挥官和古大陆的神器1)以及迷迭岛1剩下的10% 成就 邮件等...)
- &#x2610; ItemData(所有剩下的非合成武器的兑换券)
- &#x2610; TaskData(任务数据)
- &#x2610; 未知(击败特效皮肤)
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
                    text: "功能清单"
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