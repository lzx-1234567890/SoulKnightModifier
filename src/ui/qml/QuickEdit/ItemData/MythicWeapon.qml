import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SoulKnightModifier

import "../../Component"
import "../../../js/ItemData.js" as ItemData

ColumnLayout {
    id: cardLayout
    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 20

    CardView {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        text: "神话武器"
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 10
            columnSpacing: 10
            Repeater {
                model: ItemData.MythicWeapons
                delegate: Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 150

                    required property var model
                    required property int index

                    LevelEdit {
                        text: model.name
                        targetID: model.id
                        targetIDName: "id"
                        targetPath: "mythicWeapons"
                        chooseData: ["0", "1", "2", "3"]
                        type: 0
                    }
                }
            }
        }
    }
}

