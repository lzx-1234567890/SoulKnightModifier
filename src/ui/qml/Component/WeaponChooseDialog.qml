import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SoulKnightModifier

Dialog {
    id: weaponChooseDialog
    title: "选择武器"

    width: 530
    height: 600
    modal: true

    property int sumModifiedCnt: 0
    property var modifiedRecord: ({})

    anchors.centerIn: Overlay.overlay

    required property var weaponData
    ListModel { id: filteredWeaponDataModel }

    enter: Transition {
        NumberAnimation { property: "scale"; from: 0.8; to: 1.0; duration: 200; easing.type: Easing.OutBack }
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200 }
    }

    onWeaponDataChanged: {
        filterData(searchInput.text)
    }

    Component.onCompleted: {
        filterData("")
    }

    function filterData(searchText) {
        if(!weaponData) return
        weaponRepeater.model = null
        filteredWeaponDataModel.clear()
        var safeSearchText = searchText || ""
        var lowerSearchText = safeSearchText.toLowerCase()
        for (var i = 0; i < weaponData.length; i++) {
            var weapon = weaponData[i]
            if (safeSearchText === "" ||
                weapon.id.toLowerCase().indexOf(lowerSearchText) !== -1 ||
                weapon.name.toLowerCase().indexOf(lowerSearchText) !== -1) {
                filteredWeaponDataModel.append(weapon)
            }
        }
        weaponRepeater.model = filteredWeaponDataModel
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
                text: "选择武器"
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

                onClicked: weaponChooseDialog.close()
            }
        }
    }

    contentItem: ColumnLayout {
        spacing: 15

        TextField {
            id: searchInput
            Layout.fillWidth: true
            Layout.preferredHeight: 45

            placeholderText: "输入武器名称搜索..."
            placeholderTextColor: Style.inputPlaceholder
            font.pixelSize: 15
            color: Style.inputText
            verticalAlignment: TextField.AlignVCenter

            background: Rectangle {
                color: Style.inputBg
                radius: 8
                border.width: 2
                border.color: searchInput.activeFocus ? Style.inputBorderActive : Style.inputBorderNormal

                Behavior on border.color { ColorAnimation { duration: 150 } }
            }

            onTextChanged: {
                filterData(text)
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: availableWidth
            clip: true
            topPadding: 20
            leftPadding: 20
            rightPadding: 20

            Flow {
                id: weaponFlow
                width: parent.width
                spacing: 15

                Repeater {
                    id: weaponRepeater
                    model: filteredWeaponDataModel
                    delegate: ToolButton {
                        id: control
                        implicitWidth: 100
                        implicitHeight: 140
                        padding: 0
                        text: model.name

                        required property var model
                        required property int index

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
                                    source: Style.weaponBase + model.id + ".png"
                                    fillMode: Image.PreserveAspectFit
                                    horizontalAlignment: Image.AlignHCenter
                                    verticalAlignment: Image.AlignVCenter
                                }
                            }

                            Text {
                                text: model.name
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
                            cardLayout.chooseWeapon(index)
                            weaponChooseDialog.close()
                        }
                    }
                }
            }
        }
    }
}