#include "json_processor.h"
#include <QObject>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonValue>
#include <QStringList>
#include <QVariant>
#include <QJSValue>
#include <QDomDocument>

QJsonObject JsonProcessor::setValue(QJsonObject obj, QStringList steps, const QVariant &val) {
    if (steps.isEmpty()) return obj;

    QString currentKey = steps.takeFirst();

    if (steps.isEmpty()) {
        // --- 基准情况：到达目标键名 ---
        // QJsonObject::insert 如果键名存在则覆盖，不存在则新建
        QVariant realVal = val;
        if (QString(val.typeName()) == "QJSValue") {
            // 把 QJSValue 转换回标准的 QVariantMap/List
            realVal = val.value<QJSValue>().toVariant();
        }
        obj.insert(currentKey, QJsonValue::fromVariant(realVal));
    } else {
        // --- 递归情况：还没到最后一层 ---
        // 获取子对象。如果不存在，value() 会返回一个 Undefined，toObject() 会转为空对象
        QJsonObject subObj = obj.value(currentKey).toObject();

        // 递归进入下一层，并将结果重新插回当前对象
        // 这样即使路径中途的键名不存在，也会被一层层创建出来
        obj.insert(currentKey, setValue(subObj, steps, val));
    }

    return obj; // 依然是那句话：必须返回 obj，供上一层 insert 使用
}

QString JsonProcessor::extractUid(const QString &xmlString) {
    QRegularExpression regex("name=\"(\\d+)_c0_unlock\"");
    QRegularExpressionMatch match = regex.match(xmlString);
    if (match.hasMatch()) {
        return match.captured(1);
    }
    return "";
}

QJsonObject JsonProcessor::convertXmlToJson(const QString &xmlString) {
    QJsonObject rootObj;
    QJsonObject playerObj; // 玩家专属抽屉
    QJsonObject globalObj; // 全局变量抽屉

    QDomDocument doc;
    if (!doc.setContent(xmlString)) return rootObj;

    // 1. 提取并保存 UID
    QString currentUid = extractUid(xmlString);
    rootObj["uid"] = currentUid;

    QDomElement root = doc.documentElement();
    QDomNode n = root.firstChild();

    while (!n.isNull()) {
        QDomElement e = n.toElement();
        if (!e.isNull()) {
            QString rawKey = e.attribute("name");
            QString tagName = e.tagName();

            // 提取值
            QJsonValue val;
            if (tagName == "int" || tagName == "long") val = e.attribute("value").toLongLong();
            else if (tagName == "string") val = e.text();
            else if (tagName == "boolean") val = (e.attribute("value") == "true");
            else if (tagName == "float") val = e.attribute("value").toDouble();

            // 2. 核心分流逻辑：是否有 UID 前缀？
            if (!currentUid.isEmpty() && rawKey.startsWith(currentUid + "_")) {
                // 有前缀 -> 砍掉前缀，放进 player 抽屉
                QString cleanKey = rawKey.mid(currentUid.length() + 1);
                playerObj[cleanKey] = val;
            } else {
                // 没前缀 -> 绝对是全局变量！原封不动放进 global 抽屉
                globalObj[rawKey] = val;
            }
        }
        n = n.nextSibling();
    }

    // 将两个抽屉封装好返回
    rootObj["player"] = playerObj;
    rootObj["global"] = globalObj;
    return rootObj;
}

QString JsonProcessor::convertJsonToXmlTags(const QJsonObject &jsonObj) {
    QString rawTags = "";

    // 1. 把我们在解析时放进去的三个“抽屉”拿出来
    QString currentUid = jsonObj.value("uid").toString();
    QJsonObject playerObj = jsonObj.value("player").toObject();
    QJsonObject globalObj = jsonObj.value("global").toObject();

    // 内部辅助工具：根据类型生成单行 XML 标签的 Lambda 函数
    auto createXmlTag = [](const QString &key, const QJsonValue &val) -> QString {
        if (val.isString()) {
            return QString("<string name=\"%1\">%2</string>\n").arg(key, val.toString());
        } else if (val.isBool()) {
            return QString("<boolean name=\"%1\" value=\"%2\" />\n").arg(key, val.toBool() ? "true" : "false");
        } else if (val.isDouble()) { // 包含 int 和 long
            return QString("<int name=\"%1\" value=\"%2\" />\n").arg(key).arg(val.toVariant().toLongLong());
        }
        return "";
    };

    // 2. 处理 Player 抽屉：必须把 UID 前缀原封不动地“拼回去”！
    for (auto it = playerObj.begin(); it != playerObj.end(); ++it) {
        QString cleanKey = it.key();

        // 如果 UID 存在，就把 UID_ 加上；如果万一没取到 UID，就原样输出兜底
        QString finalKey = currentUid.isEmpty() ? cleanKey : (currentUid + "_" + cleanKey);

        rawTags += createXmlTag(finalKey, it.value());
    }

    // 3. 处理 Global 抽屉：这些是全局变量，绝对不能加前缀，原样输出！
    for (auto it = globalObj.begin(); it != globalObj.end(); ++it) {
        rawTags += createXmlTag(it.key(), it.value());
    }

    return rawTags; // 返回带有 \n 换行的超长字符串
}