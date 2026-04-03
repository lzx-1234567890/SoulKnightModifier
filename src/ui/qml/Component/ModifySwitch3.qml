import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import SoulKnightModifier

//对象键名值添加/删除

NormalSwitch {
    required property string targetPath
    required property string targetKey
    required property var targetVal
    //property bool originalValue: Util.hasKey(saveInfo.originalContent, targetPath + '.' + targetKey)
    //property bool modifiedValue: Util.hasKey(saveInfo.modifiedContent, targetPath + '.' + targetKey)
    //readonly property bool isDirty: originalValue !== modifiedValue

    readonly property string dirtyKey: targetPath + "." + targetKey
    readonly property bool isDirty: dirty.hasOwnProperty(dirtyKey)

    checked: Util.hasKey(modified, targetPath + '.' + targetKey)
    textStyleColor: (isDirty === true) ? Style.textModified : "transparent"

    //onIsDirtyChanged: {
        //if(isDirty) modifiedCnt++;
        //else modifiedCnt--;
    //}

    onToggled: {
        if(checked) {
            if(isDirty && dirty[dirtyKey] === true) SaveGameManager.removeDirty(fileIndex, dirtyKey)
            else if(!isDirty) SaveGameManager.insertDirty(fileIndex, dirtyKey, false)
            SaveGameManager.setValue(fileIndex, targetPath + '.' + targetKey, targetVal)
        }else {
            let content = modified
            Util.removeKey(content, targetPath + '.' + targetKey)
            if(isDirty && dirty[dirtyKey] === false) SaveGameManager.removeDirty(fileIndex, dirtyKey)
            else if(!isDirty) SaveGameManager.insertDirty(fileIndex, dirtyKey, true)
            SaveGameManager.setValue(fileIndex, targetPath, Util.getJsonValue(content, targetPath))
        }
    }
}

