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
    property alias levelText: levelText.text
    property alias levelText2: levelText2.text
    required property var targetID
    required property string targetPath
    required property string targetIDName
    required property string targetLevelName
    required property string targetLevelName2
    required property var chooseData
    required property var chooseData2
    required property int type

    //property bool originalValue: has(saveInfo.originalContent)
    //property bool modifiedValue: has(saveInfo.modifiedContent)
    //readonly property bool isValueDirty: originalValue !== modifiedValue

    //property int originalLevel: getLevel(saveInfo.originalContent, 0)
    //property int modifiedLevel: getLevel(saveInfo.modifiedContent, 0)
    //readonly property bool isLevelDirty: originalLevel !== modifiedLevel

    readonly property bool hasV: has(modified)
    readonly property string dirtyKey: targetPath + "." + targetID + ".has"
    readonly property bool isDirty: dirty.hasOwnProperty(dirtyKey)

    readonly property int originalLevel: getLevel(original, 0)
    readonly property int modifiedLevel: getLevel(modified, 0)
    property int lastLevel: modifiedLevel

    readonly property string dirtyKey2: targetPath + "." + targetID + ".level"
    readonly property bool isDirty2: dirty.hasOwnProperty(dirtyKey2)

    readonly property int originalLevel2: getLevel(original, 1)
    readonly property int modifiedLevel2: getLevel(modified, 1)
    property int lastLevel2: modifiedLevel2

    readonly property string dirtyKey3: targetPath + "." + targetID + ".level2"
    readonly property bool isDirty3: dirty.hasOwnProperty(dirtyKey3)

    //onIsValueDirtyChanged: {
        //if(isValueDirty) modifiedCnt++;
        //else modifiedCnt--;
    //}

    //onIsLevelDirtyChanged: {
        //if(isLevelDirty) modifiedCnt++;
        //else modifiedCnt--;
    //}

    //property int originalLevel2: getLevel(saveInfo.originalContent, 1)
    //property int modifiedLevel2: getLevel(saveInfo.modifiedContent, 1)
    //readonly property bool isLevelDirty2: originalLevel2 !== modifiedLevel2




    //onIsLevelDirty2Changed: {
        //if(isLevelDirty2) modifiedCnt++;
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
                    lastLevel2 = modifiedLevel2
                    remove()
                }
            }
        }
    }
    ButtonGroup { id: radioGroup }
    ButtonGroup { id: radioGroup2 }
    ColumnLayout {
        Layout.fillWidth: true
        spacing: 40
        RowLayout {
            id: levelLayout
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 20
            enabled: hasV

            Text {
                id: levelText
                Layout.preferredWidth: 150
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
                            setLevel(index, 0)
                        }
                    }
                }
            }
        }
        RowLayout {
            id: levelLayout2
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 20
            enabled: hasV

            Text {
                id: levelText2
                Layout.preferredWidth: 150
                Layout.alignment: Qt.AlignVCenter
                font.pixelSize: 15
                font.bold: true
                color: levelLayout2.enabled ? Style.textNormal3 : Style.textDisabled
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                style: Text.Outline
                styleColor: levelLayout2.enabled ? (isDirty3 ? Style.textModified : "transparent") : "transparent"
                Behavior on color {
                    ColorAnimation { duration: 150 }
                }
            }
            Repeater {
                model: chooseData2
                delegate: RadioButton {
                    id: control2
                    text: modelData
                    ButtonGroup.group: radioGroup2
                    Layout.alignment: Qt.AlignVCenter
                    checked: index === lastLevel2

                    indicator: Rectangle {
                        implicitWidth: 26
                        implicitHeight: 26
                        x: (control2.width - width) / 2 // 水平居中
                        y: 0
                        radius: 13
                        color: "transparent"
                        border.color: levelLayout2.enabled ? ((control2.hovered || control2.checked) ? Style.radioButtonBorderActive : Style.radioButtonBorderNormal) : Style.radioButtonDisabled

                        Behavior on border.color {
                            ColorAnimation { duration: 150 }
                        }

                        Rectangle {
                            width: 18
                            height: 18
                            x: 4
                            y: 4
                            radius: 9
                            color: levelLayout2.enabled ? Style.radioButtonIndicator : Style.radioButtonDisabled
                            opacity: control2.checked ? 1 : ((control2.hovered && levelLayout2.enabled) ? 0.5 : 0)
                            Behavior on opacity { OpacityAnimator { duration: 150 } }
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                    }
                    contentItem: Text {
                        text: control2.text
                        color: levelLayout2.enabled ? (control2.checked ? Style.textNormal3 : Style.textNormal) : Style.textDisabled
                        font.pixelSize: 15
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignBottom

                        anchors.top: control2.indicator.bottom
                        anchors.topMargin: 8

                        Behavior on color {
                            ColorAnimation { duration: 150 }
                        }
                    }
                    onToggled: {
                        if(checked) {
                            setLevel(index, 1)
                        }
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
                "chipName": targetID,
                "level": lastLevel,
                "refineLevel": lastLevel2
            }
        }
        const array = Util.getJsonValue(modified, targetPath)
        array.push(obj)
        if(isDirty && dirty[dirtyKey] === true) SaveGameManager.removeDirty(fileIndex, dirtyKey)
        else if(!isDirty) SaveGameManager.insertDirty(fileIndex, dirtyKey, false)
        SaveGameManager.setValue(fileIndex, targetPath, array)
    }
    function getLevel(obj, idx) {
        const levelName = idx === 0 ? targetLevelName : targetLevelName2
        const array = Util.getJsonValue(obj, targetPath)
        if (!Array.isArray(array)) return -1
        const target = array.find(element =>element[targetIDName] === targetID)
        return target ? target[levelName] : 0
    }
    function setLevel(level, idx) {
        const levelName = idx === 0 ? targetLevelName : targetLevelName2
        const array = Util.getJsonValue(modified, targetPath)
        if (!Array.isArray(array)) return
        const target = array.find(element => element[targetIDName] === targetID)
        if (target) {
            target[levelName] = level
        }
        if(idx === 0) {
            if(isDirty2 && dirty[dirtyKey2] === level) SaveGameManager.removeDirty(fileIndex, dirtyKey2)
            else if(!isDirty2 && level !== originalLevel) SaveGameManager.insertDirty(fileIndex, dirtyKey2, originalLevel)
        }else if(idx === 1) {
            if(isDirty3 && dirty[dirtyKey3] === level) SaveGameManager.removeDirty(fileIndex, dirtyKey3)
            else if(!isDirty3 && level !== originalLevel2) SaveGameManager.insertDirty(fileIndex, dirtyKey3, originalLevel2)
        }
        SaveGameManager.setValue(fileIndex, targetPath, array)
    }
}