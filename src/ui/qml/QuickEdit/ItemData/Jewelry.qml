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
        text: "饰品"
        GridLayout {
            Layout.fillWidth: true
            columns: 2
            rowSpacing: 10
            columnSpacing: 10
            Repeater {
                model: ItemData.Jewelries
                delegate: Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 150
                    JewelryEdit {
                        text: modelData.name
                        jewelryName: modelData.item
                    }
                }
            }
        }
    }
}

