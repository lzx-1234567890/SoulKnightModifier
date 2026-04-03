import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import SoulKnightModifier

//数组指定索引的对象键名修改

NormalSwitch {
    required property string targetPath
    required property string targetKey
    required property int targetIndex
    required property var targetCheckedVal
    required property var targetNotCheckedVal
    //property bool originalValue: (Util.getJsonValue(saveInfo.originalContent, targetPath))[targetIndex][targetKey] === targetCheckedVal
    //property bool modifiedValue: (Util.getJsonValue(saveInfo.modifiedContent, targetPath))[targetIndex][targetKey] === targetCheckedVal
    //readonly property bool isDirty: originalValue !== modifiedValue

    readonly property string dirtyKey: targetPath + "." + targetKey + "." + targetIndex
    readonly property bool isDirty: dirty.hasOwnProperty(dirtyKey)

    checked: (Util.getJsonValue(modified, targetPath))[targetIndex][targetKey] === targetCheckedVal
    textStyleColor: (isDirty === true) ? Style.textModified : "transparent"

    //onIsDirtyChanged: {
        //if(isDirty) modifiedCnt++;
        //else modifiedCnt--;
    //}

    onToggled: {
        if(checked) {
            let array = Util.getJsonValue(modified, targetPath)
            array[targetIndex][targetKey] = targetCheckedVal
            if(isDirty && dirty[dirtyKey] === true) SaveGameManager.removeDirty(fileIndex, dirtyKey)
            else if(!isDirty) SaveGameManager.insertDirty(fileIndex, dirtyKey, false)
            SaveGameManager.setValue(fileIndex, targetPath, array)
        }else {
            let array = Util.getJsonValue(modified, targetPath)
            array[targetIndex][targetKey] = targetNotCheckedVal
            if(isDirty && dirty[dirtyKey] === false) SaveGameManager.removeDirty(fileIndex, dirtyKey)
            else if(!isDirty) SaveGameManager.insertDirty(fileIndex, dirtyKey, true)
            SaveGameManager.setValue(fileIndex, targetPath, array)
        }
    }
}

