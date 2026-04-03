import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import SoulKnightModifier

Rectangle {
    id: card
    radius: 10
    color: Style.cardBg
    border.width: 1
    border.color: Style.line
    Layout.fillWidth: true
    implicitHeight: mainLayout.implicitHeight + 20

    property string text: ""

    default property alias content: contentArea.data

    layer.enabled: true
    /*layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: "#80000000"
        shadowBlur: 0.8
        shadowVerticalOffset: 3
    }*/

    ColumnLayout {
        id: mainLayout
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 15
        spacing: 20

        Text {
            Layout.fillWidth: true
            text: card.text
            font.pixelSize: 20
            font.bold: true
            color: Style.cardTitle
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: Style.line
            opacity: 0.3
            visible: card.text !== ""
        }

        ColumnLayout {
            id: contentArea
            Layout.fillWidth: true
            spacing: 10
        }
    }
}