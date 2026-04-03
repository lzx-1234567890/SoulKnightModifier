#ifndef SAVELISTMODEL_H
#define SAVELISTMODEL_H

#include <QAbstractListModel>
#include "src/data/save_file_info.h"

class SaveListModel : public QAbstractListModel {
    Q_OBJECT

    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)

public:
    enum SaveRoles {
        SaveDataRole = Qt::UserRole + 1,
        FileNameRole,
        FilePathRole,
        FileTypeRole,
        OriginalContentRole,
        ModifiedContentRole,
        DirtyValueRole
    };

    explicit SaveListModel(QObject *parent = nullptr) : QAbstractListModel(parent) {}

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    void updateModifiedContent(int index, const QJsonObject &newData);
    void insertDirty(const int index, const QString &key, const QVariant &val);
    void removeDirty(const int index, const QString &key);
    int getDirtyCount(const int index);

    SaveFileInfo get(const int index);
    bool save(const QJsonObject &data, const int index);
    bool reset(const int index);
    void remove(const int index);
    void append(const SaveFileInfo &save);

private:
    QList<SaveFileInfo> m_data;

signals:
    void countChanged();
};

#endif // SAVELISTMODEL_H