import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SoulKnightModifier

import "../../Component"
import "../../../js/ItemData.js" as ItemData

ColumnLayout {
    id: itemDataContainer
    Layout.fillWidth: true
    Layout.fillHeight: true

    //required property var saveInfo
    //required property int itemIndex
    //property int modifiedCnt: 0

    required property int fileIndex
    required property var original
    required property var modified
    required property var dirty

    signal needReloadStorageItems(var obj)


    //onSaveInfoChanged: {
        //needReloadStorageItems(saveInfo.originalContent)
    //}

    CategoryTabBar {
        id: categoryTabBar
        Layout.fillWidth: true
        Layout.preferredHeight: 50
        tabData: ["解锁", "神话武器", "饰品", "物品"]
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
                source: "BluePrintUnlock.qml"
            }

            Loader {
                Layout.fillWidth: true
                source: "MythicWeapon.qml"
            }

            Loader {
                Layout.fillWidth: true
                source: "Jewelry.qml"
            }

            Loader {
                Layout.fillWidth: true
                source: "ItemStorage.qml"
            }
        }
    }

}

