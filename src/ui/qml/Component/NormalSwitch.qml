import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import SoulKnightModifier

Switch {
    id: control
    property alias textStyleColor: switchText.styleColor

    indicator: Rectangle {
        implicitWidth: 46
        implicitHeight: 24
        y: parent.height / 2 - height / 2
        radius: 12
        color: parent.checked ? Style.switchBgChecked : Style.switchBgNotChecked
        border.color: parent.hovered ? (control.checked ? Style.switchBorderChecked : Style.switchBorderNotChecked) : "transparent"
        border.width: 1

        Behavior on color { ColorAnimation { duration: 150 } }

        Rectangle {
            x: control.checked ? parent.width - width - 2 : 2
            y: 2
            width: 20
            height: 20
            radius: 10
            color: control.checked ? Style.switchIndicatorChecked : Style.switchIndicatorNotChecked
            Behavior on x {
                NumberAnimation { duration: 250; easing.type: Easing.OutBack }
            }
            Behavior on color {
                ColorAnimation { duration: 250 }
            }
        }
    }

    contentItem: Text {
        id: switchText
        leftPadding: parent.indicator.width + parent.spacing
        text: parent.text
        font.pixelSize: 15
        font.bold: true
        style: Text.Outline
        styleColor: "transparent"
        color: parent.enabled ? (parent.checked ? Style.switchTextChecked : Style.switchTextNotChecked) : Style.switchTextDisabled
        verticalAlignment: Text.AlignVCenter
        Behavior on color { ColorAnimation { duration: 150 } }
    }
}