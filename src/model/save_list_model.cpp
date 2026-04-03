#include "save_list_model.h"

int SaveListModel::rowCount(const QModelIndex &parent) const {
    if (parent.isValid()) return 0;
    return m_data.size();
}

QVariant SaveListModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() >= m_data.size()) return QVariant();
    const SaveFileInfo &info = m_data[index.row()];
    switch (role) {
        //case SaveDataRole: return QVariant::fromValue(info);
        case FileNameRole: return QVariant::fromValue(info.fileName);
        case FilePathRole: return QVariant::fromValue(info.filePath);
        case FileTypeRole: return QVariant::fromValue(info.fileType);
        case OriginalContentRole: return QVariant::fromValue(info.originalContent);
        case ModifiedContentRole: return QVariant::fromValue(info.modifiedContent);
        case DirtyValueRole: return info.dirtyValue;
        default: return QVariant();
    }
}

QHash<int, QByteArray> SaveListModel::roleNames() const {
    QHash<int, QByteArray> roles;
    //roles[SaveDataRole] = "modelData";
    roles[FileNameRole] = "fileName";
    roles[FilePathRole] = "filePath";
    roles[FileTypeRole] = "fileType";
    roles[OriginalContentRole] = "original";
    roles[ModifiedContentRole] = "modified";
    roles[DirtyValueRole] = "dirty";
    return roles;
}

void SaveListModel::updateModifiedContent(int index, const QJsonObject &newData) {
    m_data[index].modifiedContent = newData;
    auto idx = createIndex(index, 0);
    //emit dataChanged(idx, idx, {SaveDataRole});
    emit dataChanged(idx, idx, {ModifiedContentRole});
}

void SaveListModel::insertDirty(const int index, const QString &key, const QVariant &val) {
    if(key == "") return;
    m_data[index].dirtyValue[key] = val;
    m_data[index].dirtyCount++;
    qWarning() << "插入:" << key << "||" << val;
    auto idx = createIndex(index, 0);
    emit dataChanged(idx, idx, {DirtyValueRole});
}

void SaveListModel::removeDirty(const int index, const QString &key) {
    m_data[index].dirtyValue.remove(key);
    qWarning() << "删除:" << key;
    m_data[index].dirtyCount--;
    auto idx = createIndex(index, 0);
    emit dataChanged(idx, idx, {DirtyValueRole});
}

int SaveListModel::getDirtyCount(const int index) {
    return m_data[index].dirtyCount;
}

SaveFileInfo SaveListModel::get(const int index) {
    return m_data.at(index);
}

bool SaveListModel::save(const QJsonObject &data, const int index) {
    if (index < 0 || index >= m_data.size()) return false;
    m_data[index].originalContent = m_data[index].modifiedContent;
    m_data[index].dirtyValue.clear();
    m_data[index].dirtyCount = 0;
    auto idx = createIndex(index, 0);
    //emit dataChanged(idx, idx, {SaveDataRole});
    emit dataChanged(idx, idx, {OriginalContentRole, DirtyValueRole});
    return true;
}

bool SaveListModel::reset(const int index) {
    if (index < 0) return false;
    m_data[index].modifiedContent = m_data[index].originalContent;
    m_data[index].dirtyValue.clear();
    m_data[index].dirtyCount = 0;
    auto idx = createIndex(index, 0);
    emit dataChanged(idx, idx, {ModifiedContentRole, DirtyValueRole});
    return true;
}

void SaveListModel::remove(const int index) {
    if (index < 0 || index >= m_data.size()) return;
    beginRemoveRows(QModelIndex(), index, index);
    m_data.removeAt(index);
    endRemoveRows();
    emit countChanged();
}

void SaveListModel::append(const SaveFileInfo &save) {
    beginInsertRows(QModelIndex(), m_data.size(), m_data.size());
    m_data.append(save);
    endInsertRows();
    emit countChanged();
}