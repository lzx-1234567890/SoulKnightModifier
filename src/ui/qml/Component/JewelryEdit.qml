import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import SoulKnightModifier

RowLayout {
    id: jewelryLayout
    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 30

    property alias text: jewelryText.text
    required property string jewelryName

    //property bool originalValue: jewelryLayout.hasJewelry(saveInfo.originalContent)
    //property bool modifiedValue: jewelryLayout.hasJewelry(saveInfo.modifiedContent)
    //readonly property bool isValueDirty: originalValue !== modifiedValue

    //property int originalDurability: jewelryLayout.getDurability(saveInfo.originalContent)
    //property int modifiedDurability: jewelryLayout.getDurability(saveInfo.modifiedContent)
    //readonly property bool isDurabilityDirty: originalDurability !== modifiedDurability

    readonly property bool has: hasJewelry(modified)
    readonly property int originalDurability: getDurability(original)
    readonly property int modifiedDurability: getDurability(modified)

    readonly property string dirtyKey: jewelryName + ".has"
    readonly property bool isDirty: dirty.hasOwnProperty(dirtyKey)

    readonly property string dirtyKey2: jewelryName + ".durability"
    readonly property bool isDirty2: dirty.hasOwnProperty(dirtyKey2)

    property int lastDurability: modifiedDurability
    property int displayDurability: modifiedDurability

    //onIsValueDirtyChanged: {
        //if(isValueDirty) modifiedCnt++;
        //else modifiedCnt--;
    //}

    //onIsDurabilityDirtyChanged: {
        //if(isDurabilityDirty) modifiedCnt++;
        //else modifiedCnt--;
    //}

    ColumnLayout {
        Layout.preferredWidth: 100
        Layout.fillHeight: true
        spacing: 10

        Text {
            id: jewelryText
            font.pixelSize: 15
            font.bold: true
            color: hasSwitch.checked ? Style.textNormal3 : Style.textNormal
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            style: Text.Outline
            styleColor: isDirty ? Style.textModified : "transparent"
            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }
        NormalSwitch {
            id: hasSwitch
            checked: has
            onToggled: {
                if(checked) {
                    addJewelry()
                }else {
                    lastDurability = modifiedDurability
                    removeJewelry()
                }
            }
        }
    }
    ButtonGroup { id: radioGroup }
    RowLayout {
        id: durabilityLayout
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 20
        enabled: has

        Text {
            id: durabilityText
            text: "充能:"
            Layout.alignment: Qt.AlignVCenter
            font.pixelSize: 15
            font.bold: true
            color: durabilityLayout.enabled ? Style.textNormal3 : Style.textDisabled
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            style: Text.Outline
            styleColor: durabilityLayout.enabled ? (displayDurability !== originalDurability ? Style.textModified : "transparent") : "transparent"
            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }

        Slider {
            id: durabilitySlider
            from: 0
            to: 100
            stepSize: 1
            snapMode: Slider.SnapAlways
            value: durabilityLayout.enabled ? modifiedDurability : lastDurability

            background: Rectangle {
                x: durabilitySlider.leftPadding
                y: durabilitySlider.topPadding + durabilitySlider.availableHeight / 2 - height / 2
                implicitWidth: 200
                implicitHeight: 6
                width: durabilitySlider.availableWidth
                height: implicitHeight
                radius: 3
                color: durabilityLayout.enabled ? Style.sliderNotFilled : Style.sliderDisabled

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }

                Rectangle {
                    width: durabilitySlider.visualPosition * parent.width
                    height: parent.height
                    color: durabilityLayout.enabled ? Style.sliderFilled : Style.sliderDisabled
                    radius: 3

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }
            }

            handle: Rectangle {
                x: durabilitySlider.leftPadding + durabilitySlider.visualPosition * (durabilitySlider.availableWidth - width)
                y: durabilitySlider.topPadding + durabilitySlider.availableHeight / 2 - height / 2
                implicitWidth: 20
                implicitHeight: 20
                radius: 10
                color: durabilityLayout.enabled ? (durabilitySlider.pressed ? Style.sliderIndicatorActive : Style.sliderIndicatorNormal) : Style.sliderDisabled
                layer.enabled: true

                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }

            onMoved: {
                displayDurability = value
            }

            onPressedChanged: {
                if(!pressed) setDurability(value)
                displayDurability = value
            }
        }

        Text {
            id: durabilitySliderText
            text: durabilityLayout.enabled ? displayDurability : lastDurability
            Layout.alignment: Qt.AlignVCenter
            font.pixelSize: 15
            font.bold: true
            color: durabilityLayout.enabled ? Style.textNormal3 : Style.textDisabled
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            style: Text.Outline
            styleColor: durabilityLayout.enabled ? (displayDurability !== originalDurability ? Style.textDisabled : "transparent") : "transparent"
            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }

    }
    function hasJewelry(jsonObject) {
        return Util.hasKey(jsonObject, "jewelryData." + jewelryName)
    }
    function removeJewelry() {
        const obj = modified
        Util.removeKey(obj, "jewelryData." + jewelryName)
        if(isDirty && dirty[dirtyKey] === false) SaveGameManager.removeDirty(fileIndex, dirtyKey)
        else if(!isDirty) SaveGameManager.insertDirty(fileIndex, dirtyKey, true)
        SaveGameManager.setValue(fileIndex, "jewelryData", Util.getJsonValue(obj, "jewelryData"))
    }
    function addJewelry() {
        const obj = modified
        const jewelry = {
            "durability": lastDurability,
            "item": jewelryName,
            "rune1": "None",
            "rune2": "None"
        }
        Util.setJsonValue(obj, "jewelryData." + jewelryName, jewelry)
        if(isDirty && dirty[dirtyKey] === true) SaveGameManager.removeDirty(fileIndex, dirtyKey)
        else if(!isDirty) SaveGameManager.insertDirty(fileIndex, dirtyKey, false)
        SaveGameManager.setValue(fileIndex, "jewelryData", Util.getJsonValue(obj, "jewelryData"))
    }
    function getDurability(jsonObject) {
        if(!hasJewelry(jsonObject)) return 100
        return Util.getJsonValue(jsonObject, "jewelryData." + jewelryName + ".durability")
    }
    function setDurability(durability) {
        if(isDirty2 && dirty[dirtyKey2] === durability) SaveGameManager.removeDirty(fileIndex, dirtyKey2)
        else if(!isDirty2 && durability !== originalDurability) SaveGameManager.insertDirty(fileIndex, dirtyKey2, originalDurability)
        SaveGameManager.setValue(fileIndex, "jewelryData." + jewelryName + ".durability", durability)
    }
}