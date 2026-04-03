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

    padding: 20

    anchors.centerIn: Overlay.overlay

    property string message: ""
    property string mtitle: ""
    property string acceptText: ""
    property string rejectText: ""
    property int hasButton: 0

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

        Text {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignTop
            text: control.mtitle
            color: Style.textNormal2
            font.pixelSize: 20
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            text: control.message
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            color: Style.textNormal
            font.pixelSize: 15
            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Item { Layout.fillWidth: true }

            NormalButton {
                btnText: acceptText
                fontSize: 15
                onClicked: control.accept()
                visible: hasButton & 1
            }

            NormalButton {
                btnText: rejectText
                fontSize: 15
                onClicked: control.reject()
                visible: hasButton & 2
            }
        }
    }

    enter: Transition {
        NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: 200; easing.type: Easing.OutBack }
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200 }
    }
}