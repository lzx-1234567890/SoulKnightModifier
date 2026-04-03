import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.impl
import SoulKnightModifier


TabBar {
    id: root
    Layout.fillWidth: true
    Layout.preferredHeight: 50
    topPadding: 10
    leftPadding: 20
    rightPadding: 20
    bottomPadding: 5

    required property var tabData
    readonly property real tabWidth: root.count > 0 ? (root.availableWidth / root.count) : 0

    background: Rectangle {
        color: Style.tabbarBg
        anchors.fill: parent
        anchors.topMargin: parent.topPadding
        anchors.leftMargin: parent.leftPadding
        anchors.rightMargin: parent.rightPadding
        radius: 10

        border.width: 1
        border.color: Style.line

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: "#80000000"
            shadowBlur: 0.8
            shadowVerticalOffset: 3
        }
        Rectangle {
            id: indicator
            height: 4
            width: root.tabWidth * 0.6
            radius: 2
            color: Style.indicator2

            anchors.bottom: parent.bottom
            anchors.bottomMargin: 6
            x: (root.currentIndex * root.tabWidth) + (root.tabWidth - width) / 2

            Behavior on x {
                NumberAnimation {
                    duration: 350
                    easing.type: Easing.OutBack
                    easing.overshoot: 2.0
                }
            }
        }
    }

    Repeater {
        id: repeater
        model: tabData
        TabButton {
            id: tabbtn
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            text: modelData
            background: Rectangle {
                color: "transparent"
            }
            contentItem: Text {
                text: tabbtn.text
                font.pixelSize: 15
                font.bold: true
                color: tabbtn.checked ? Style.textNormal3 : Style.textNormal
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
        }
    }
}
