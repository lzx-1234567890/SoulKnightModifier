import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import SoulKnightModifier

//对象键名值修改

NormalSwitch {
    required property string targetPath
    required property var targetCheckedVal
    required property var targetNotCheckedVal
    //property bool originalValue: Util.hasKey(saveInfo.originalContent, targetPath) && (Util.getJsonValue(saveInfo.originalContent, targetPath) === targetCheckedVal)
    //property bool modifiedValue: Util.hasKey(saveInfo.modifiedContent, targetPath) && (Util.getJsonValue(saveInfo.modifiedContent, targetPath) === targetCheckedVal)
    //readonly property bool isDirty: originalValue !== modifiedValue

    readonly property string dirtyKey: targetPath
    readonly property bool isDirty: dirty.hasOwnProperty(dirtyKey)

    checked: Util.hasKey(modified, targetPath) && (Util.getJsonValue(modified, targetPath) === targetCheckedVal)
    textStyleColor: (isDirty === true) ? Style.textModified : "transparent"

    //onIsDirtyChanged: {
        //if(isDirty) modifiedCnt++;
        //else modifiedCnt--;
    //}

    onToggled: {
        if(checked) {
            if(isDirty && dirty[dirtyKey] === true) SaveGameManager.removeDirty(fileIndex, dirtyKey)
            else if(!isDirty) SaveGameManager.insertDirty(fileIndex, dirtyKey, false)
            SaveGameManager.setValue(fileIndex, targetPath, targetCheckedVal)
        }else {
            if(isDirty && dirty[dirtyKey] === false) SaveGameManager.removeDirty(fileIndex, dirtyKey)
            else if(!isDirty) SaveGameManager.insertDirty(fileIndex, dirtyKey, true)
            SaveGameManager.setValue(fileIndex, targetPath, targetNotCheckedVal)
        }
    }
}

