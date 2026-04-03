import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import SoulKnightModifier

RowLayout {
    id: layout
    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 30

    property alias text: displayText.text
    required property var targetID
    required property string targetPath
    required property string targetIDName
    required property var chooseData
    required property int type

    //property bool originalValue: has(saveInfo.originalContent)
    //property bool modifiedValue: has(saveInfo.modifiedContent)
    //readonly property bool isValueDirty: originalValue !== modifiedValue

    //property int originalLevel: getLevel(saveInfo.originalContent)
    //property int modifiedLevel: getLevel(saveInfo.modifiedContent)
    //readonly property bool isLevelDirty: originalLevel !== modifiedLevel

    readonly property bool hasV: has(modified)
    readonly property int originalLevel: getLevel(original)
    readonly property int modifiedLevel: getLevel(modified)

    readonly property string dirtyKey: targetPath + "." + targetID + ".has"
    readonly property bool isDirty: dirty.hasOwnProperty(dirtyKey)

    readonly property string dirtyKey2: targetPath + "." + targetID + ".level"
    readonly property bool isDirty2: dirty.hasOwnProperty(dirtyKey2)

    property int lastLevel: modifiedLevel

    //onIsValueDirtyChanged: {
        //if(isValueDirty) modifiedCnt++;
        //else modifiedCnt--;
    //}

    //onIsLevelDirtyChanged: {
        //if(isLevelDirty) modifiedCnt++;
        //else modifiedCnt--;
    //}

    ColumnLayout {
        Layout.preferredWidth: 100
        Layout.fillHeight: true
        spacing: 10

        Text {
            id: displayText
            font.pixelSize: 15
            font.bold: true
            color: hasSwitch.checked ? Style.textNormal3 : Style.textNormal
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            style: Text.Outline
            styleColor: isDirty ? Style.textModified : "transparent"
            Behavior on color { ColorAnimation { duration: 150 } }
        }
        NormalSwitch {
            id: hasSwitch
            checked: hasV
            onToggled: {
                if(checked) {
                    add()
                }else {
                    lastLevel = modifiedLevel
                    remove()
                }
            }
        }
    }
    ButtonGroup { id: radioGroup }
    RowLayout {
        id: levelLayout
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: 20
        enabled: hasV

        Text {
            id: levelText
            text: "等级:"
            Layout.alignment: Qt.AlignVCenter
            font.pixelSize: 15
            font.bold: true
            color: levelLayout.enabled ? Style.textNormal3 : Style.textDisabled
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            style: Text.Outline
            styleColor: levelLayout.enabled ? (isDirty2 ? Style.textModified : "transparent") : "transparent"
            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }
        Repeater {
            model: chooseData
            delegate: RadioButton {
                id: control
                text: modelData
                ButtonGroup.group: radioGroup
                Layout.alignment: Qt.AlignVCenter
                checked: index === lastLevel

                indicator: Rectangle {
                    implicitWidth: 26
                    implicitHeight: 26
                    x: (control.width - width) / 2 // 水平居中
                    y: 0
                    radius: 13
                    color: "transparent"
                    border.color: levelLayout.enabled ? ((control.hovered || control.checked) ? Style.radioButtonBorderActive : Style.radioButtonBorderNormal) : Style.radioButtonDisabled

                    Behavior on border.color {
                        ColorAnimation { duration: 150 }
                    }

                    Rectangle {
                        width: 18
                        height: 18
                        x: 4
                        y: 4
                        radius: 9
                        color: levelLayout.enabled ? Style.radioButtonIndicator : Style.radioButtonDisabled
                        opacity: control.checked ? 1 : ((control.hovered && levelLayout.enabled) ? 0.5 : 0)
                        Behavior on opacity { OpacityAnimator { duration: 150 } }
                        Behavior on color { ColorAnimation { duration: 150 } }
                    }
                }
                contentItem: Text {
                    text: control.text
                    color: levelLayout.enabled ? (control.checked ? Style.textNormal3 : Style.textNormal) : Style.textDisabled
                    font.pixelSize: 15
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignBottom

                    anchors.top: control.indicator.bottom
                    anchors.topMargin: 8

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }
                onToggled: {
                    if(checked) {
                        setLevel(index)
                    }
                }
            }
        }
    }
    function has(obj) {
        const array = Util.getJsonValue(obj, targetPath)
        if (!Array.isArray(array)) return false
        return array.some(element => element[targetIDName] === targetID)
    }
    function remove() {
        const array = Util.getJsonValue(modified, targetPath)
        if (!Array.isArray(array)) return
        const newArray = array.filter(element => element[targetIDName] !== targetID)
        if(isDirty && dirty[dirtyKey] === false) SaveGameManager.removeDirty(fileIndex, dirtyKey)
        else if(!isDirty) SaveGameManager.insertDirty(fileIndex, dirtyKey, true)
        SaveGameManager.setValue(fileIndex, targetPath, newArray)
    }
    function add() {
        if(has(modified)) return
        let obj = {}
        if(type === 0) {
            obj = {
                "id" : targetID,
                "level": lastLevel
            }
        }else if(type === 1) {
            obj = {
                "followerConfigId": targetID,
                "level": lastLevel
            }
        }else if(type === 2) {
            obj = {
                "id": targetID,
                "index": 0,
                "level": lastLevel
            }
        }
        const array = Util.getJsonValue(modified, targetPath)
        array.push(obj)
        if(isDirty && dirty[dirtyKey] === true) SaveGameManager.removeDirty(fileIndex, dirtyKey)
        else if(!isDirty) SaveGameManager.insertDirty(fileIndex, dirtyKey, false)
        SaveGameManager.setValue(fileIndex, targetPath, array)
    }
    function getLevel(obj) {
        const array = Util.getJsonValue(obj, targetPath)
        if (!Array.isArray(array)) return -1
        const target = array.find(element =>element[targetIDName] === targetID)
        return target ? target.level : 0
    }
    function setLevel(level) {
        const array = Util.getJsonValue(modified, targetPath)
        if (!Array.isArray(array)) return
        const target = array.find(element => element[targetIDName] === targetID)
        if (target) {
            target.level = level
        }
        if(isDirty2 && dirty[dirtyKey2] === level) SaveGameManager.removeDirty(fileIndex, dirtyKey2)
        else if(!isDirty2 && level !== originalLevel) SaveGameManager.insertDirty(fileIndex, dirtyKey2, originalLevel)
        SaveGameManager.setValue(fileIndex, targetPath, array)
    }
}