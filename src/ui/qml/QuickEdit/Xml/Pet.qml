import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SoulKnightModifier

import "../../Component"
import "../../../js/XmlData.js" as XmlData

ColumnLayout {
    id: cardLayout
    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 20
    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "宠物解锁"
        GridLayout {
            Layout.fillWidth: true
            columns: 4
            rowSpacing: 10
            columnSpacing: 10
            Repeater {
                model: XmlData.Pet
                delegate: RowLayout {
                    Layout.preferredHeight: 60

                    required property var model
                    required property int index

                    Item {
                        Layout.preferredWidth: 60
                        Layout.preferredHeight: 60
                        Image {
                            anchors.fill: parent
                            anchors.margins: 10
                            sourceSize.width: 40
                            sourceSize.height: 40
                            source: Style.petBase + model.id + ".png"
                            fillMode: Image.PreserveAspectFit
                            horizontalAlignment: Image.AlignHCenter
                            verticalAlignment: Image.AlignVCenter
                        }
                    }
                    ModifySwitch4 {
                        Layout.fillWidth: true
                        text: model.name
                        targetPath: "player.p" + model.id + "_unlock"
                        targetCheckedVal: "True"
                        targetNotCheckedVal: "False"
                    }
                }
            }
        }
    }
}