import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ToolButton {
    id: control

    property alias btnText: btnText.text
    property alias fontSize: btnText.font.pixelSize
    property bool isCenter: true

    background: Rectangle {
        anchors.fill: parent
        radius: 8
        color: parent.pressed ? Style.pressed : (parent.hovered ? Style.hovered : "transparent")
        Behavior on color { ColorAnimation { duration: 150 } }
    }
    contentItem: Text {
        id: btnText
        text: btn.parent.text
        font.pixelSize: btn.parent
        color: Style.textNormal2
        horizontalAlignment: isCenter ? Text.AlignHCenter : Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }
}