import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtCore

import "Component"

ColumnLayout {
    id: settingContainer
    anchors.fill: parent

    property string importPath: ""
    property string exportPath: ""
    property int type: 0

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

        ColumnLayout {
            id: dataLayout
            anchors.fill: parent
            spacing: 20

            CardView {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                text: "加密工具"

                ColumnLayout {
                    Layout.fillWidth: true
                    NormalButton {
                        Layout.fillWidth: true
                        isCenter: false
                        btnText: "XOR 加密(或解密)"
                        fontSize: 15

                        onClicked: {
                            type = 1
                            fileImportDialog.nameFilters = ["Decrypted files (*.decrypted)", "All files (*)"]
                            fileImportDialog.open()
                        }
                    }

                    NormalButton {
                        Layout.fillWidth: true
                        isCenter: false
                        btnText: "DES(iambo密钥) 加密"
                        fontSize: 15

                        onClicked: {
                            type = 2
                            fileImportDialog.nameFilters = ["Decrypted files (*.decrypted)", "All files (*)"]
                            fileImportDialog.open()
                        }
                    }

                    NormalButton {
                        Layout.fillWidth: true
                        isCenter: false
                        btnText: "DES(crst1密钥) 加密"
                        fontSize: 15

                        onClicked: {
                            type = 3
                            fileImportDialog.nameFilters = ["Decrypted files (*.decrypted)", "All files (*)"]
                            fileImportDialog.open()
                        }
                    }
                }
            }

            CardView {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                text: "解密工具"

                NormalButton {
                    Layout.fillWidth: true
                    isCenter: false
                    btnText: "XOR 解密(或加密)"
                    fontSize: 15

                    onClicked: {
                        type = 4
                        fileImportDialog.nameFilters = ["Data files (*.data)", "All files (*)"]
                        fileImportDialog.open()
                    }
                }

                NormalButton {
                    Layout.fillWidth: true
                    isCenter: false
                    btnText: "DES(iambo密钥) 解密"
                    fontSize: 15

                    onClicked: {
                        type = 5
                        fileImportDialog.nameFilters = ["Data files (*.data)", "All files (*)"]
                        fileImportDialog.open()
                    }
                }

                NormalButton {
                    Layout.fillWidth: true
                    isCenter: false
                    btnText: "DES(crst1密钥) 解密"
                    fontSize: 15

                    onClicked: {
                        type = 6
                        fileImportDialog.nameFilters = ["Data files (*.data)", "All files (*)"]
                        fileImportDialog.open()
                    }
                }
            }

            CardView {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                text: "其他"

                NormalButton {
                    Layout.fillWidth: true
                    isCenter: false
                    btnText: "XML 格式化"
                    fontSize: 15

                    onClicked: {
                        type = 7
                        fileImportDialog.nameFilters = ["XML files (*.xml)", "All files (*)"]
                        fileImportDialog.open()
                    }
                }
            }
        }
    }

    FileDialog {
        id: fileImportDialog
        title: "选择需要处理的文件"
        currentFolder: fileSettings.fileImportPath

        onAccepted: {
            fileSettings.fileImportPath = fileImportDialog.currentFolder
            importPath = FileProcessor.urlToLocalFile(selectedFile)
            if(importPath !== "") {
                let fileName = importPath.split(/[/\\]/).pop();
                if(type === 1 || type === 2 || type === 3) {
                    if(!fileName.endsWith(".data")) fileName = fileName + ".data"
                }else if(type === 4 || type === 5 || type === 6) {
                    if(!fileName.endsWith(".decrypted")) fileName = fileName + ".decrypted"
                }
                fileExportDialog.currentFile = Qt.url(fileName)
                fileExportDialog.open()
            }else {
                dialog.mtitle = "错误"
                dialog.message = "路径错误"
                dialog.open()
            }
        }
    }

    FileDialog {
        id: fileExportDialog
        title: "选择保存路径"
        fileMode: FileDialog.SaveFile
        currentFolder: fileSettings.fileExportPath

        onAccepted: {
            fileSettings.fileExportPath = fileExportDialog.currentFolder
            exportPath = FileProcessor.urlToLocalFile(selectedFile)
            if(exportPath !== "") {
                let ok = false
                if(type === 1) {
                    ok = SaveGameProcessor.xorCipherTool(importPath, exportPath)
                }else if(type === 2) {
                    ok = SaveGameProcessor.encryptDESTool(importPath, exportPath, 0)
                }else if(type === 3) {
                    ok = SaveGameProcessor.encryptDESTool(importPath, exportPath, 1)
                }else if(type === 4) {
                    ok = SaveGameProcessor.xorCipherTool(importPath, exportPath)
                }else if(type === 5) {
                    ok = SaveGameProcessor.decryptDESTool(importPath, exportPath, 0)
                }else if(type === 6) {
                    ok = SaveGameProcessor.decryptDESTool(importPath, exportPath, 1)
                }else if(type === 7) {
                    ok = SaveGameProcessor.formatXMLTool(importPath, exportPath)
                }
                if(ok) {
                    dialog.mtitle = "成功"
                    dialog.message = "处理成功"
                    dialog.open()
                }else {
                    dialog.mtitle = "错误"
                    dialog.message = "处理失败"
                    dialog.open()
                }
            }else {
                dialog.mtitle = "错误"
                dialog.message = "路径错误"
                dialog.open()
            }
        }
    }

    CustomDialog {
        id: dialog
        mtitle: ""
        message: ""
        hasButton: 1
        acceptText: "确定"
    }
}