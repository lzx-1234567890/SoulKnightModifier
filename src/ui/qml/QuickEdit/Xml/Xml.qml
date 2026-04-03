import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SoulKnightModifier

import "../../Component"

ColumnLayout {
    Layout.fillWidth: true
    Layout.fillHeight: true

    required property int fileIndex
    required property var original
    required property var modified
    required property var dirty

    CategoryTabBar {
        id: categoryTabBar
        Layout.fillWidth: true
        Layout.preferredHeight: 50
        tabData: ["基本", "角色", "宠物"]
    }

    ScrollView {
        id: dataContainer
        Layout.fillWidth: true
        Layout.fillHeight: true
        topPadding: 10
        bottomPadding: 20
        leftPadding: 20
        rightPadding: 20
        contentHeight: dataLayout.height
        contentWidth: availableWidth
        clip: true

        StackLayout {
            id: dataLayout
            width: dataContainer.availableWidth
            height: children[currentIndex] ? children[currentIndex].implicitHeight : 0
            currentIndex: categoryTabBar.currentIndex

            Loader {
                Layout.fillWidth: true
                source: "Basic.qml"
            }

            Loader {
                Layout.fillWidth: true
                source: "Character.qml"
            }

            Loader {
                Layout.fillWidth: true
                source: "Pet.qml"
            }
        }
    }

}

