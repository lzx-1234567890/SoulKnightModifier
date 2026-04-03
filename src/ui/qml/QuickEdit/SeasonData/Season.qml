import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SoulKnightModifier

import "../../Component"
import "../../../js/SeasonData.js" as SeasonData


ColumnLayout {
    id: cardLayout
    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 20

    property int currentSeasonIndex: 0

    Component.onCompleted: {
        reload()
    }

    onCurrentSeasonIndexChanged: {
        reload()
    }

    function reload() {
        let id = SeasonData.AllSeason[currentSeasonIndex].id
        if(id === "Aram2") {
            seasonLoader.setSource("SeasonDetail2.qml", {
                "seasonName": SeasonData.AllSeason[currentSeasonIndex].name,
                "seasonID": "aram2",
                "seasonData": SeasonData.Aram2
            })
        }else if(id === "Artifacts2") {
            seasonLoader.setSource("SeasonDetail2.qml", {
                "seasonName": SeasonData.AllSeason[currentSeasonIndex].name,
                "seasonID": "artifacts2",
                "seasonData": SeasonData.Artifacts2
            })
        }else if(id === "Troop2") {
            seasonLoader.setSource("SeasonDetail2.qml", {
                "seasonName": SeasonData.AllSeason[currentSeasonIndex].name,
                "seasonID": "troop2",
                "seasonData": SeasonData.Troop2
            })
        }else if(id === "ComboGun") {
            seasonLoader.setSource("SeasonDetail.qml")
        }else if(id === "Aram") {
            seasonLoader.setSource("SeasonDetail3.qml")
        }else if(id === "IronTide") {
            seasonLoader.setSource("SeasonDetail4.qml")
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 60
        color: "transparent"
        border.width: 1
        border.color: Style.normal
        radius: 5

        ToolButton {
            id: leftButton
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 10
            implicitWidth: 40
            implicitHeight: 40
            padding: 0
            icon.source: Style.iconBase + "arrow-left-wide-line.svg"
            icon.color: Style.iconNormal2
            icon.width: 30
            icon.height: 30
            visible: currentSeasonIndex !== 0

            background: Rectangle {
                anchors.fill: parent
                radius: 5
                color: parent.pressed ? Style.pressed : (parent.hovered ? Style.hovered : "transparent")
                Behavior on color {ColorAnimation { duration: 150 }}
            }

            onClicked: {
                if(currentSeasonIndex > 0) currentSeasonIndex--
            }
        }
        Text {
            text: SeasonData.AllSeason[currentSeasonIndex].name
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.left: leftButton.right
            anchors.right: rightButton.left
            anchors.margins: 10
            color: Style.textNormal2
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 15
            font.bold: true
        }
        ToolButton {
            id: rightButton
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 10
            implicitWidth: 40
            implicitHeight: 40
            padding: 0
            icon.source: Style.iconBase + "arrow-right-wide-line.svg"
            icon.color: Style.iconNormal2
            icon.width: 30
            icon.height: 30
            visible: currentSeasonIndex !== (SeasonData.AllSeason.length - 1)

            background: Rectangle {
                anchors.fill: parent
                radius: 5
                color: parent.pressed ? Style.pressed : (parent.hovered ? Style.hovered : "transparent")
                Behavior on color {ColorAnimation { duration: 150 }}
            }

            onClicked: {
                if(currentSeasonIndex < SeasonData.AllSeason.length - 1) currentSeasonIndex++
            }
        }
    }

    Loader {
        id: seasonLoader
        Layout.fillWidth: true
    }
}