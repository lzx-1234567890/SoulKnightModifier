import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtCore

import "Component"

ColumnLayout {
    id: quickEditContainer
    anchors.fill: parent
    spacing: 0

    property int modifiedCnt: 0

    onModifiedCntChanged: {
        console.log(modifiedCnt)
    }

    SaveFileTabBar {
        id: tabbar
        Layout.fillWidth: true
        Layout.preferredHeight: 40
        Layout.alignment: Qt.AlignTop
    }

    StackLayout {
        id: mainLayout
        Layout.fillWidth: true
        Layout.fillHeight: true
        currentIndex: tabbar.currentIndex

        Repeater {
            model: SaveGameManager.saveListModel
            Item {
                id: pageWrapper
                Layout.fillWidth: true
                Layout.fillHeight: true

                property string fileName: model.fileName

                //property alias loader: pageLoader
                //property int pageModifiedCnt: pageLoader.status === Loader.Ready ? Object.keys(pageLoader.item.dirty).length : 0

                //onPageModifiedCntChanged: {
                    //modifiedCnt = pageModifiedCnt
                //}

                StackLayout.onIsCurrentItemChanged: {
                    if (StackLayout.isCurrentItem && pageLoader.status === Loader.Null) {
                        let path = ""
                        if(fileType === 1) {
                            path = "QuickEdit/ItemData/ItemData.qml"
                        }else if(fileType === 50) {
                            path = "QuickEdit/Xml/Xml.qml"
                        }else if(fileType === 2){
                            path = "QuickEdit/SeasonData/SeasonData.qml"
                        }else if(fileType === 3){
                            path = "QuickEdit/Task/Task.qml"
                        }else if(fileType === 5){
                            path = "QuickEdit/Statistic/Statistic.qml"
                        }else if(fileType === 6){
                            path = "QuickEdit/WeaponEvolution/WeaponEvolution.qml"
                        }else {
                            dialog.open()
                        }

                        pageLoader.setSource(path, {
                            //"saveInfo": modelData,
                            "fileIndex": index,
                            "original": original,
                            "modified": modified,
                            "dirty": dirty
                        })
                    }
                }

                Loader {
                    id: pageLoader
                    anchors.fill: parent
                    visible: status === Loader.Ready
                }

                /*Binding {
                    target: pageLoader.item
                    property: "saveInfo"
                    value: modelData
                    when: pageLoader.status === Loader.Ready
                }*/

                Binding {
                    target: pageLoader.item
                    property: "fileIndex"
                    value: index
                    when: pageLoader.status === Loader.Ready
                }

                Binding {
                    target: pageLoader.item
                    property: "original"
                    value: original
                    when: pageLoader.status === Loader.Ready
                }

                Binding {
                    target: pageLoader.item
                    property: "modified"
                    value: modified
                    when: pageLoader.status === Loader.Ready
                }

                Binding {
                    target: pageLoader.item
                    property: "dirty"
                    value: dirty
                    when: pageLoader.status === Loader.Ready
                }

                Connections {
                    target: pageLoader.item
                    function onDirtyChanged() {
                        if(pageLoader.status === Loader.Ready) modifiedCnt = SaveGameManager.getDirtyCount(index)
                    }
                }

                BusyIndicator {
                    anchors.centerIn: parent
                    running: pageLoader.status === Loader.Loading || pageLoader.status === Loader.Null
                    visible: running
                    width: 48
                    height: 48
                }
            }
        }
    }

    BottomToolBar {
        id: toolbar
        Layout.fillWidth: true
        Layout.preferredHeight: 75
        Layout.alignment: Qt.AlignBottom
        visible: SaveGameManager.saveListModel.count >= 1

        onButtonClicked: (index) => {
            if(index === 0) {
                exportEncryptedFile()
            }else if(index === 1) {
                exportDecryptedFile()
            //}else if(index === 2) {
            //    resetFile()
            }else if(index === 2) {
                saveFile()
            }
        }
    }

    function exportEncryptedFile() {
        let fileName = mainLayout.children[mainLayout.currentIndex].fileName
        if(!fileName.endsWith(".xml")) fileSaveDialog.currentFile = Qt.url(fileName.endsWith(".data") ? fileName : fileName + ".data")
        else fileSaveDialog.currentFile = Qt.url(fileName)
        fileSaveDialog.type = 0;
        //if(mainLayout.children[mainLayout.currentIndex].loader.item.modifiedCnt >= 1) {
        if(modifiedCnt >= 1) {
            dialog2.open()
        }else {
            fileSaveDialog.open()
        }
    }
    function exportDecryptedFile() {
        let fileName = mainLayout.children[mainLayout.currentIndex].fileName
        if(!fileName.endsWith(".xml")) fileSaveDialog.currentFile = Qt.url(fileName.endsWith(".decrypted") ? fileName : fileName + ".decrypted")
        else fileSaveDialog.currentFile = Qt.url(fileName)
        fileSaveDialog.type = 1;
        //if(mainLayout.children[mainLayout.currentIndex].loader.item.modifiedCnt >= 1) {
        if(modifiedCnt >= 1) {
            dialog2.open()
        }else {
            fileSaveDialog.open()
        }
    }
    function resetFile() {
        dialog3.open()
    }
    function saveFile() {
        if(SaveGameManager.saveFile(mainLayout.children[mainLayout.currentIndex].modified, mainLayout.currentIndex)) {
            //mainLayout.children[mainLayout.currentIndex].loader.item.modifiedCnt = 0
            window.showMessage("保存成功")
        }else {
            window.showMessage("保存失败")
        }
    }

    FileDialog {
        id: fileSaveDialog
        title: "选择保存路径"

        property int type: 0

        fileMode: FileDialog.SaveFile

        nameFilters: ["Files (*.data *.decrypted *.xml)", "All files (*)"]
        currentFolder: fileSettings.fileExportPath

        onAccepted: {
            fileSettings.fileExportPath = fileSaveDialog.currentFolder
            let path = FileProcessor.urlToLocalFile(selectedFile)
            if(path !== "") {
                if(fileSaveDialog.type === 0) {
                    if(SaveGameManager.exportEncryptedFile(path, mainLayout.currentIndex)) {
                        window.showMessage("导出成功")
                    }else {
                        window.showMessage("导出失败")
                    }
                }else if(fileSaveDialog.type === 1) {
                    if(SaveGameManager.exportDecryptedFile(path, mainLayout.currentIndex)) {
                        window.showMessage("导出成功")
                    }else {
                        window.showMessage("导出失败")
                    }
                }
            }
        }
    }

    CustomDialog {
        id: dialog
        mtitle: "错误"
        message: "不支持该类型文件"
        hasButton: 1
        acceptText: "确定"
    }

    CustomDialog {
        id: dialog2
        mtitle: "警告"
        message: "你还未保存已修改的部分，直接导出将无法应用你的修改。"
        hasButton: 3
        acceptText: "导出"
        rejectText: "取消"

        onAccepted: {
            fileSaveDialog.open()
        }
    }

    CustomDialog {
        id: dialog3
        mtitle: "警告"
        message: "重置后，你的所有未保存修改将丢失。"
        hasButton: 3
        acceptText: "重置"
        rejectText: "取消"

        onAccepted: {
            if(SaveGameManager.resetFile(mainLayout.currentIndex)) {
                window.showMessage("重置成功")
            }else {
                window.showMessage("重置失败")
            }
        }
    }
}