import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.impl
import SoulKnightModifier

Rectangle {
    id: sidebarContainer
    width: isExpanded ? expandedWidth : notExpandedWidth
    Layout.fillHeight: true
    color: Style.sidebarBg
    property alias currentIndex: sidebar.currentIndex

    property int topMargin: 5
    property int bottomMargin: 5
    property int leftMargin: 14
    property int rightMargin: 10

    property bool isExpanded: true
    property int expandedWidth: 250
    property int notExpandedWidth: 65

    Behavior on width { NumberAnimation { duration: 150 } }



    ColumnLayout {
        anchors.fill: parent
        spacing: 0
        clip: true

        ToolButton {
            id: menuBtn
            Layout.fillWidth: true;
            Layout.preferredHeight: 50

            background: Rectangle {
                anchors.fill: parent
                anchors.topMargin: topMargin
                anchors.bottomMargin: bottomMargin
                anchors.rightMargin: rightMargin
                anchors.leftMargin: leftMargin
                radius: 8
                color: parent.pressed ? Style.pressed : (parent.hovered ? Style.hovered : "transparent")
                Behavior on color { ColorAnimation { duration: 150 } }
            }

            contentItem: RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 18
                spacing: 10

                IconImage {
                    Layout.preferredWidth: 35
                    Layout.preferredHeight: 35
                    source: Style.iconBase + "menu-line.svg"
                    fillMode: Image.PreserveAspectFit
                    color: menuBtn.hovered ? Style.iconNormal2 : Style.iconNormal
                }

                Text {
                    text: "SoulKnightModifier"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 25
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 15
                    color: menuBtn.hovered ? Style.textNormal2 : Style.textNormal
                    opacity: isExpanded ? 1 : 0
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }
            }

            onClicked: {
                isExpanded ^= 1
            }

        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 1
            color: Style.line
        }

        ListView {
            id: sidebar
            Layout.fillWidth: true;
            Layout.fillHeight: true;
            model: ListModel {
                ListElement {text: "快速编辑";icon: "pencil-ai-line.svg"}
                //ListElement {text: "手动编辑";icon: "pencil-line.svg"}
                ListElement {text: "实用工具";icon: "hammer-line.svg"}
                //ListElement {text: "设置";icon: "settings-5-line.svg"}
                //ListElement {text: "使用教程";icon: "book-marked-line.svg"}
                ListElement {text: "关于";icon: "information-2-line.svg"}
            }
            delegate: ItemDelegate {
                id: control
                width: sidebar.width
                height: 50
                checked: ListView.isCurrentItem
                onClicked: {
                    //if(index == 1) return
                    sidebar.currentIndex = index
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 5
                    anchors.bottomMargin: 5
                    anchors.leftMargin: 5
                    color: Style.indicator
                    width: 4
                    radius: 2
                    opacity: parent.checked ? 1 : 0
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                background: Rectangle {
                    anchors.fill: parent
                    anchors.topMargin: topMargin
                    anchors.bottomMargin: bottomMargin
                    anchors.rightMargin: rightMargin
                    anchors.leftMargin: leftMargin
                    radius: 8
                    color: parent.pressed ? Style.pressed : (parent.hovered ? Style.hovered : "transparent")
                    Behavior on color { ColorAnimation { duration: 150 } }
                }

                contentItem: RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 18
                    spacing: 10
                    IconImage {
                        Layout.preferredWidth: 35
                        Layout.preferredHeight: 35
                        source: Style.iconBase + model.icon
                        fillMode: Image.PreserveAspectFit
                        color: control.checked ? Style.iconNormal2 : Style.iconNormal
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                    Text {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 25
                        verticalAlignment: Text.AlignVCenter
                        text: model.text
                        font.pixelSize: 15
                        color: control.checked ? Style.textNormal2 : Style.textNormal
                        opacity: isExpanded ? 1 : 0
                        Behavior on color { ColorAnimation { duration: 150 } }
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }
                }
            }
        }

        ToolButton {
            id: themeBtn
            Layout.fillWidth: true;
            Layout.preferredHeight: 50
            Layout.alignment: Qt.AlignBottom

            background: Rectangle {
                anchors.fill: parent
                anchors.topMargin: topMargin
                anchors.bottomMargin: bottomMargin
                anchors.rightMargin: rightMargin
                anchors.leftMargin: leftMargin
                radius: 8
                color: parent.pressed ? Style.pressed : (parent.hovered ? Style.hovered : "transparent")
                Behavior on color { ColorAnimation { duration: 150 } }
            }

            contentItem: RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 18
                spacing: 10

                IconImage {
                    Layout.preferredWidth: 35
                    Layout.preferredHeight: 35
                    source: Style.iconBase + (Style.isDark ? "sun-line.svg" : "moon-clear-line.svg")
                    fillMode: Image.PreserveAspectFit
                    color: themeBtn.hovered ? Style.iconNormal2 : Style.iconNormal
                }

                Text {
                    text: Style.isDark ? "白天主题" : "夜间主题"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 25
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 15
                    color: themeBtn.hovered ? Style.textNormal2 : Style.textNormal
                    opacity: isExpanded ? 1 : 0
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }
            }

            onClicked: {
                window.triggerThemeSwitch(themeBtn)
            }

        }

    }

    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 1
        color: Style.line
    }
}