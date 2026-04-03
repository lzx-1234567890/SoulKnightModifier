import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import SoulKnightModifier

//列表中是否包含

NormalSwitch {
    required property string listPath
    required property string target
    //property bool originalValue: Util.hasElement(saveInfo.originalContent, listPath, target)
    //property bool modifiedValue: Util.hasElement(saveInfo.modifiedContent, listPath, target)
    //readonly property bool isDirty: originalValue !== modifiedValue

    readonly property string dirtyKey: listPath + "." + target
    readonly property bool isDirty: dirty.hasOwnProperty(dirtyKey)

    checked: Util.hasElement(modified, listPath, target)
    textStyleColor: (isDirty === true) ? Style.textModified : "transparent"

    //onIsDirtyChanged: {
        //if(isDirty) modifiedCnt++;
        //else modifiedCnt--;
    //}

    onToggled: {
        if(checked) {
            let content = modified
            Util.addElement(content, listPath, target)
            if(isDirty && dirty[dirtyKey] === true) SaveGameManager.removeDirty(fileIndex, dirtyKey)
            else if(!isDirty) SaveGameManager.insertDirty(fileIndex, dirtyKey, false)
            SaveGameManager.setValue(fileIndex, listPath, Util.getJsonValue(content, listPath))
        }else {
            let content = modified
            Util.removeElement(content, listPath, target)
            if(isDirty && dirty[dirtyKey] === false) SaveGameManager.removeDirty(fileIndex, dirtyKey)
            else if(!isDirty) SaveGameManager.insertDirty(fileIndex, dirtyKey, true)
            SaveGameManager.setValue(fileIndex, listPath, Util.getJsonValue(content, listPath))
        }
    }
}

