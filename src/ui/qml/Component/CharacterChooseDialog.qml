import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SoulKnightModifier

Dialog {
    id: characterChooseDialog
    title: "选择角色"

    width: 530
    height: 600
    modal: true

    anchors.centerIn: Overlay.overlay

    required property var characterData

    enter: Transition {
        NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: 200; easing.type: Easing.OutBack }
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200 }
    }

    background: Rectangle {
        color: Style.dialogBg
        radius: 10
        border.color: Style.dialogBorder
        border.width: 1
    }

    header: Rectangle {
        width: parent.width
        height: 60
        color: "transparent"

        Rectangle {
            anchors.fill: parent
            anchors.topMargin: 10
            anchors.bottomMargin: 10
            anchors.rightMargin: 20
            anchors.leftMargin: 20
            color: "transparent"

            Text {
                anchors.centerIn: parent
                text: "选择角色"
                color: Style.textNormal2
                font.pixelSize: 15
                font.bold: true
                horizontalAlignment: Text.horizontalAlignment
            }

            ToolButton {
                implicitWidth: 30
                implicitHeight: 30
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                padding: 0

                icon.source: Style.iconBase + "close-line.svg"
                icon.color: Style.iconNormal2
                icon.width: 25
                icon.height: 25

                background: Rectangle {
                    color: Style.dialogClose
                    radius: 5
                    opacity: parent.pressed ? 0.8 : (parent.hovered ? 0.4 : 0)
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                onClicked: characterChooseDialog.close()
            }
        }
    }

    contentItem: ScrollView {
        width: parent.width
        contentWidth: availableWidth
        topPadding: 20
        leftPadding: 20
        rightPadding: 20

        Flow {
            spacing: 15
            width: parent.width

            Repeater {
                model: characterData
                ToolButton {
                    id: control
                    implicitWidth: 100
                    implicitHeight: 140
                    padding: 0
                    text: modelData.name

                    background: Rectangle {
                        anchors.fill: parent
                        color: "transparent"
                        border.color: control.hovered ? Style.smallCardBorderActive : Style.smallCardBorderNormal
                        border.width: 1
                        radius: 5
                        Behavior on border.color { ColorAnimation { duration: 150 } }

                        Rectangle {
                            anchors.fill: parent
                            radius: 5
                            color: control.pressed ? Style.smallCardBgPressed : (control.hovered ? Style.smallCardBgHovered : Style.smallCardBgNormal)
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                    }

                    contentItem: ColumnLayout {
                        anchors.fill: parent
                        Item {
                            Layout.preferredWidth: 80
                            Layout.preferredHeight: 80
                            Layout.alignment: Qt.AlignHCenter
                            Layout.margins: 10

                            Image {
                                anchors.fill: parent
                                sourceSize.width: 80
                                sourceSize.height: 80
                                source: Style.characterBase + modelData.ename + ".png"
                                fillMode: Image.PreserveAspectFit
                                horizontalAlignment: Image.AlignHCenter
                                verticalAlignment: Image.AlignVCenter
                            }
                        }

                        Text {
                            text: modelData.name
                            Layout.fillWidth: true
                            Layout.preferredHeight: 30
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 15
                            font.bold: true
                            color: control.hovered ? Style.textNormal3 : Style.textNormal2
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                    }

                    onClicked: {
                        cardLayout.chooseCharacter(modelData.id)
                        characterChooseDialog.close()
                    }
                }
            }
        }
    }
}