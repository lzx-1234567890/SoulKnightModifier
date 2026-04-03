import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.impl
import SoulKnightModifier
import QtQuick.Dialogs
import QtCore

Rectangle {
    id: headerContainer
    Layout.fillWidth: true
    Layout.preferredHeight: 40
    color: "transparent"

    property alias currentIndex: fileTabBar.currentIndex

    RowLayout {
        id: headerLayout
        anchors.fill: parent
        spacing: 0

        TabBar {
            id: fileTabBar
            property int fileTabBarCurrentIndex: currentIndex
            Layout.fillHeight: true
            width: Math.min(implicitWidth, headerContainer.width - addBtn.width - 20)
            Layout.preferredWidth: width
            background: Rectangle{
                color: Style.tabbarBg
            }
            contentItem: ListView {
                model: fileTabBar.contentModel
                orientation: ListView.Horizontal
                spacing: fileTabBar.spacing

                add: Transition {
                    NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 300 }
                    NumberAnimation { property: "scale"; from: 0.5; to: 1; duration: 300; easing.type: Easing.OutBack }
                }
                remove: Transition {
                    ParallelAnimation {
                        NumberAnimation { property: "opacity"; to: 0; duration: 200 }
                        NumberAnimation { property: "scale"; to: 0.5; duration: 200 }
                        NumberAnimation { property: "y"; to: 20; duration: 200 }
                    }
                }
                displaced: Transition {
                    NumberAnimation {
                        properties: "x,y"
                        duration: 300
                        easing.type: Easing.OutQuad
                    }
                }
            }
            Repeater {
                model: SaveGameManager.saveListModel
                TabButton {
                    id: tabbtn
                    text: fileName
                    width: {
                        const normalWidth = 150
                        let maxTabBarWidth = headerContainer.width - addBtn.width - 20
                        let realWidth = SaveGameManager.saveListModel.count * normalWidth
                        if(realWidth < maxTabBarWidth) return normalWidth
                        else {
                            let targetWidth = maxTabBarWidth / realWidth * normalWidth
                            while(targetWidth * SaveGameManager.saveListModel.count >= maxTabBarWidth) targetWidth -= 1
                            return targetWidth
                        }
                    }
                    height: parent.height
                    ToolTip.visible: hovered
                    ToolTip.delay: 600
                    ToolTip.text: filePath
                    background: Rectangle {
                        color: closeBtn.hovered ? "transparent" : (tabbtn.pressed ? Style.pressed : (tabbtn.hovered ? Style.hovered : "transparent"))
                        radius: 8
                    }
                    contentItem: RowLayout {
                        anchors.fill: parent
                        spacing: 2
                        Text {
                            Layout.fillWidth: true
                            text: tabbtn.text
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            elide: Text.ElideRight
                            font.pixelSize: 15
                            color: (tabbtn.checked || tabbtn.pressed) ? Style.textNormal2 : Style.textNormal
                        }
                        ToolButton {
                            id: closeBtn
                            Layout.rightMargin: 4
                            Layout.alignment: Qt.AlignVCenter
                            Layout.preferredWidth: 25
                            Layout.preferredHeight: 25
                            background: Rectangle {
                                color: parent.pressed ? Style.pressed : (parent.hovered ? Style.hovered : "transparent")
                                radius: 8
                            }
                            contentItem: IconImage {
                                source: Style.iconBase + "close-line.svg"
                                color: (parent.hovered || parent.pressed) ? Style.iconNormal2 : Style.iconNormal
                            }

                            onClicked: {
                                if (index >= 0 && index < SaveGameManager.saveListModel.count) {
                                    if(modifiedCnt >= 1) {
                                        dialog2.target = index
                                        dialog2.open()
                                    }
                                    else closeAnimation.start()
                                }
                            }
                        }
                    }
                    function forceClose() {
                        closeAnimation.start()
                    }
                    SequentialAnimation {
                        id: closeAnimation
                        NumberAnimation { target: tabbtn; property: "opacity"; to: 0; duration: 150 }
                        NumberAnimation { target: tabbtn; property: "width"; to: 0; duration: 150 }
                        onStopped: {
                            SaveGameManager.remove(index)
                        }
                    }
                    Rectangle {
                        anchors.bottom: tabbtn.bottom
                        anchors.left: tabbtn.left
                        anchors.right: tabbtn.right
                        height: 1
                        color: tabbtn.checked ? Style.indicator : "transparent"
                    }
                    Rectangle {
                        anchors.right: tabbtn.right
                        anchors.top: tabbtn.top
                        anchors.bottom: tabbtn.bottom
                        width: 1
                        color: Style.line
                    }
                }
            }
        }
        ToolButton {
            id: addBtn
            Layout.preferredWidth: 25
            Layout.preferredHeight: 25
            Layout.leftMargin: 5
            background: Rectangle {
                color: parent.pressed ? Style.pressed : (parent.hovered ? Style.hovered : "transparent")
                radius: 8
            }
            contentItem: Text {
                anchors.fill: parent
                text: "+"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 15
                color: (parent.hovered || parent.pressed) ? Style.textNormal2 : Style.textNormal
            }
            onClicked: {
                fileOpenDialog.open()
            }
        }
        Item {
            Layout.fillWidth: true
        }
    }

    Rectangle {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 1
        color: Style.line
    }

    FileDialog {
        id: fileOpenDialog
        title: "选择要修改的存档或配置文件"
        currentFolder: fileSettings.fileImportPath
        nameFilters: ["Data files (*.data *.decrypted *.xml)", "All files (*)"]

        onAccepted: {
            fileSettings.fileImportPath = fileOpenDialog.currentFolder
            let path = FileProcessor.urlToLocalFile(selectedFile)
            let name = path.split(/[/\\]/).pop()
            if(SaveGameManager.parseSaveGame(path)) {
                fileTabBar.currentIndex = SaveGameManager.saveListModel.count - 1;
            }else {
                dialog.open()
            }
        }
    }

    CustomDialog {
        id: dialog
        mtitle: "错误"
        message: "文件解析失败"
        hasButton: 1
        acceptText: "确定"
    }

    CustomDialog {
        id: dialog2
        mtitle: "警告"
        message: "你已经对该文件进行了修改，如果此时关闭文件，所有修改将丢失。"
        hasButton: 3
        acceptText: "关闭文件"
        rejectText: "取消"
        onAccepted: {
            if (target !== -1) {
                let targetTab = fileTabBar.itemAt(target)
                if (targetTab) {
                    targetTab.forceClose()
                }
            }
        }

        property int target: -1
    }
}