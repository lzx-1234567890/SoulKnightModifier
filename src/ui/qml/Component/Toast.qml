import QtQuick
import QtQuick.Controls
import SoulKnightModifier

Rectangle {
    id: root

    property alias text: label.text
    property int duration: 2000

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 100

    width: label.implicitWidth + 40
    height: label.implicitHeight + 20
    radius: height / 2
    color: Style.toastBg

    opacity: 0
    visible: opacity > 0
    z: 999

    Text {
        id: label
        anchors.centerIn: parent
        color: Style.toastText
        font.pixelSize: 15
    }

    Behavior on opacity {
        NumberAnimation { duration: 300 }
    }

    Timer {
        id: displayTimer
        interval: root.duration
        onTriggered: root.opacity = 0
    }

    function show(message, time) {
        root.text = message;
        if (time) root.duration = time;
        root.opacity = 1;
        displayTimer.restart();
    }
}