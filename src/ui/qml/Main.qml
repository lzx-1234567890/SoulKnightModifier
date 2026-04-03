import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtCore
import SoulKnightModifier

import "Component"

ApplicationWindow {
    id: window
    width: 1280
    height: 720
    visible: true
    title: "Soul Knight Modifier"

    property real rippleX: 0
    property real rippleY: 0
    property real rippleSize: 0

    property bool isSilentUpdateCheck: false

    //主内容
    Rectangle {
        id: mainUI
        anchors.fill: parent
        color: Style.windowBg

        RowLayout {
            anchors.fill: parent
            spacing: 0

            NavigationSideBar {
                id: sidebar
                Layout.fillHeight: true
                Layout.preferredWidth: width
            }

            StackLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                currentIndex: sidebar.currentIndex

                Loader { source: "QuickEdit.qml" }
                //Loader { source: "ManualEdit.qml" }
                //Loader { source: "Setting.qml" }
                Loader { source: "UsefulTool.qml" }
                //Loader { source: "Tutorial.qml" }
                Loader { source: "About.qml" }
            }
        }
    }

    //全局遮罩
    Item {
        id: transitionOverlay
        anchors.fill: parent
        z: 9999
        visible: false

        Image {
            id: oldThemeSnapshot
            anchors.fill: parent
            cache: false
        }

        ShaderEffectSource {
            id: newThemeLive
            anchors.fill: parent
            sourceItem: mainUI
            live: true
            visible: false
        }

        Item {
            id: maskContainer
            anchors.fill: parent
            visible: false

            Rectangle {
                id: maskCircle
                x: window.rippleX - width/2
                y: window.rippleY - height/2
                width: window.rippleSize
                height: window.rippleSize
                radius: width/2
                color: "black"
            }
        }

        OpacityMask {
            anchors.fill: parent
            source: newThemeLive
            maskSource: maskContainer
        }
    }

    NumberAnimation {
        id: rippleAnim
        target: window
        property: "rippleSize"
        from: 0
        to: Math.sqrt(window.width * window.width + window.height * window.height) * 2
        duration: 500
        easing.type: Easing.InOutQuad
        onStopped: {
            window.rippleSize = 0;
            transitionOverlay.visible = false;
        }
    }

    Timer {
        id: themeSwitchDelay
        interval: 50
        onTriggered: {
            Style.isDark ^= 1
            uiSettings.isDark ^= 1
            rippleAnim.start();
        }
    }

    function triggerThemeSwitch(sourceItem) {
        if (rippleAnim.running || themeSwitchDelay.running) return;

        var pos = sourceItem.mapToItem(window.contentItem, sourceItem.width / 2, sourceItem.height / 2)
        window.rippleX = pos.x
        window.rippleY = pos.y

        mainUI.grabToImage(function(result) {
            oldThemeSnapshot.source = result.url;
            transitionOverlay.visible = true;
            themeSwitchDelay.start();
        });
    }

    Settings {
        id: uiSettings
        category: "UISettings"

        property alias windowWidth: window.width
        property alias windowHeight: window.height
        property bool isDark: true
        property bool warning: true
    }

    Settings {
        id: fileSettings
        category: "FileSettings"

        property url fileImportPath: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        property url fileExportPath: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
    }

    Settings {
        id: updateSettings
        category: "UpdateSettings"

        property string lastNotifiedVersion: ""
    }

    Toast {
        id: globalToast
    }

    function showMessage(msg) {
        globalToast.show(msg);
    }

    UpdateDisplayDialog {
        id: updateDisplayDialog
    }

    UpdateManager {
        id: updateManager

        onUpdateAvailable: (newVersion, log, url) => {
            if (isSilentUpdateCheck && newVersion === updateSettings.lastNotifiedVersion) {
                return;
            }
            updateDisplayDialog.newVersion = newVersion
            updateDisplayDialog.changelog = log
            updateDisplayDialog.downloadUrl = url
            updateDisplayDialog.open()

            if (isSilentUpdateCheck) {
                updateSettings.lastNotifiedVersion = newVersion
            }
        }

        onNoUpdate: {
            if (!isSilentUpdateCheck) showMessage("已是最新版本")
        }

        onCheckFailed: {
            if (!isSilentUpdateCheck) showMessage("检查更新失败，请检查网络")
        }
    }

    function checkForUpdates() {
        updateManager.checkForUpdates()
    }

    CustomDialog {
        id: warningDialog
        mtitle: "警告"
        message: "一切修改存档行为之前，必须备份存档或者上传云端，因各类原因导致存档损坏的或者丢失的，本人不负一切责任!!!"
        hasButton: 3
        acceptText: "不再提醒"
        rejectText: "我已知晓"

        onAccepted: {
            uiSettings.warning = false
        }
    }

    Component.onCompleted: {
        Style.isDark = uiSettings.isDark
        if(uiSettings.warning) warningDialog.open()
        isSilentUpdateCheck = true
        updateManager.checkForUpdates()
    }
}