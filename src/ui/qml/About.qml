import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls.impl

import "Component"
import "About"

ColumnLayout {
    id: aboutContainer
    anchors.fill: parent

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

            RowLayout {
                Layout.fillWidth: true
                spacing: 20

                Image {
                    Layout.preferredWidth: 128
                    Layout.preferredHeight: 128
                    sourceSize.width: 128
                    sourceSize.height: 128
                    source: Style.iconBase + "128x128.png"
                    fillMode: Image.PreserveAspectFit
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    Text {
                        text: "SoulKnightModifier"
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 15
                        font.bold: true
                        color: Style.textNormal
                    }

                    Text {
                        text: "version: " + Qt.application.version
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 15
                        font.bold: true
                        color: Style.textNormal
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 20

                        Text {
                            text: "by lzxnone"
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 15
                            font.bold: true
                            color: Style.textNormal
                        }

                        Item {
                            Layout.preferredWidth: 64
                            Layout.preferredHeight: 64

                            Image {
                                id: authorImage
                                anchors.fill: parent
                                sourceSize.width: 64
                                sourceSize.height: 64
                                source: Style.iconBase + "author.png"
                                fillMode: Image.PreserveAspectFit
                                horizontalAlignment: Image.AlignHCenter
                                verticalAlignment: Image.AlignVCenter
                                visible: false
                            }

                            Rectangle {
                                id: maskRect
                                anchors.fill: parent
                                radius: 8
                                visible: false
                                layer.enabled: true
                            }

                            MultiEffect {
                                anchors.fill: parent
                                source: authorImage
                                maskEnabled: true
                                maskSource: maskRect
                            }
                        }
                    }
                }
            }

            Text {
                text: "适配最新的元气骑士版本: 8.1.0"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 15
                font.bold: true
                color: Style.textNormal
            }

            CardView {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                text: "更多"

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 32
                    Layout.alignment: Qt.AlignVCenter

                    IconImage {
                        width: 32
                        height: 32
                        sourceSize.width: 32
                        sourceSize.height: 32
                        source: Style.iconBase + "megaphone-line.svg"
                        fillMode: Image.PreserveAspectFit
                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                        color: Style.iconNormal
                    }

                    NormalButton {
                        anchors.fill: parent
                        anchors.leftMargin: 40
                        isCenter: false
                        btnText: "更新公告"
                        fontSize: 15

                        onClicked: {
                            updateAnnocementDialog.open()
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 32
                    Layout.alignment: Qt.AlignVCenter

                    IconImage {
                        width: 32
                        height: 32
                        sourceSize.width: 32
                        sourceSize.height: 32
                        source: Style.iconBase + "list-unordered.svg"
                        fillMode: Image.PreserveAspectFit
                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                        color: Style.iconNormal
                    }

                    NormalButton {
                        anchors.fill: parent
                        anchors.leftMargin: 40
                        isCenter: false
                        btnText: "功能清单"
                        fontSize: 15

                        onClicked: {
                            functionListDialog.open()
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 32
                    Layout.alignment: Qt.AlignVCenter

                    IconImage {
                        width: 32
                        height: 32
                        sourceSize.width: 32
                        sourceSize.height: 32
                        source: Style.iconBase + "arrow-up-line.svg"
                        fillMode: Image.PreserveAspectFit
                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                        color: Style.iconNormal
                    }

                    NormalButton {
                        anchors.fill: parent
                        anchors.leftMargin: 40
                        isCenter: false
                        btnText: "检查更新"
                        fontSize: 15

                        onClicked: {
                            window.isSilentUpdateCheck = false
                            window.showMessage("正在检查更新...")
                            window.checkForUpdates()
                        }
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 32
                    Layout.alignment: Qt.AlignVCenter

                    IconImage {
                        width: 32
                        height: 32
                        sourceSize.width: 32
                        sourceSize.height: 32
                        source: Style.iconBase + "book-marked-line.svg"
                        fillMode: Image.PreserveAspectFit
                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                        color: Style.iconNormal
                    }

                    NormalButton {
                        anchors.fill: parent
                        anchors.leftMargin: 40
                        isCenter: false
                        btnText: "使用教程"
                        fontSize: 15

                        onClicked: {
                            tutorialDialog.open()
                        }
                    }

                    IconImage {
                        anchors.right: parent.right
                        width: 32
                        height: 32
                        sourceSize.width: 32
                        sourceSize.height: 32
                        source: Style.iconBase + "external-link-line.svg"
                        fillMode: Image.PreserveAspectFit
                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                        color: Style.iconNormal
                    }
                }

                Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 32
                    Layout.alignment: Qt.AlignVCenter

                    IconImage {
                        width: 32
                        height: 32
                        sourceSize.width: 32
                        sourceSize.height: 32
                        source: Style.iconBase + "github-fill.svg"
                        fillMode: Image.PreserveAspectFit
                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                        color: Style.iconNormal
                    }

                    NormalButton {
                        anchors.fill: parent
                        anchors.leftMargin: 40
                        isCenter: false
                        btnText: "项目地址"
                        fontSize: 15

                        onClicked: {
                            githubDialog.open()
                        }
                    }

                    IconImage {
                        anchors.right: parent.right
                        width: 32
                        height: 32
                        sourceSize.width: 32
                        sourceSize.height: 32
                        source: Style.iconBase + "external-link-line.svg"
                        fillMode: Image.PreserveAspectFit
                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                        color: Style.iconNormal
                    }
                }
            }

            Text {
                Layout.fillWidth: true
                text: "免责声明：本软件仅供学习交流使用，请勿用于商业等其他用途，一切商业行为都与此软件无关！如果有能力，请支持正版，不要宣扬此软件，此软件仅供个人娱乐。"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 15
                font.bold: true
                color: Style.textNormal
                wrapMode: Text.Wrap
            }

            Text {
                Layout.fillWidth: true
                text: "一切修改存档行为之前，必须备份存档或者上传云端，因各类原因导致存档损坏的或者丢失的，本人不负一切责任!!!"
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 15
                font.bold: true
                color: "red"
                wrapMode: Text.Wrap
            }
        }
    }

    UpdateAnnocementDialog {
        id: updateAnnocementDialog
    }

    FunctionListDialog {
        id: functionListDialog
    }

    CustomDialog {
        id: tutorialDialog
        mtitle: "外部链接"
        message: "是否前往" + tutorialUrl
        hasButton: 3
        acceptText: "确定"
        rejectText: "取消"

        property string tutorialUrl: "https://server.lzxnone.cloud/SoulKnightModifier/tutorial.pdf"

        onAccepted: {
            Qt.openUrlExternally(tutorialUrl)
        }
    }

    CustomDialog {
        id: githubDialog
        mtitle: "外部链接"
        message: "是否前往" + githubUrl
        hasButton: 3
        acceptText: "确定"
        rejectText: "取消"

        property string githubUrl: "https://github.com/lzx-1234567890/SoulKnightModifier"

        onAccepted: {
            Qt.openUrlExternally(githubUrl)
        }
    }
}