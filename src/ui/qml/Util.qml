pragma Singleton
import QtQuick

QtObject {
    //深拷贝
    function deepClone(value) {
        // 优先使用现代浏览器/Node原生的高效深拷贝 API
        if (typeof structuredClone === 'function') {
            try {
                return structuredClone(value);
            } catch (e) {
                // 如果遇到不支持 structuredClone 的特殊对象(如包含函数的对象)，降级处理
                console.warn("structuredClone failed, falling back to JSON parse/stringify");
            }
        }
        // 传统且最稳妥的 JSON 序列化深拷贝（适用于绝大多数纯数据结构）
        return JSON.parse(JSON.stringify(value));
    }
    //获取值拷贝
    function getJsonValue(jsonObject, path) {
        if (!jsonObject || !path) return undefined;

        // 过滤掉空字符串，兼容 ".a.b" 或 "a.b." 格式
        const keys = path.split('.').filter(k => k.length > 0);

        // 如果没有路径，理论上返回整个对象的拷贝
        if (keys.length === 0) {
            return deepClone(jsonObject);
        }

        const result = keys.reduce((prev, curr) => {
            return (prev && prev[curr] !== undefined) ? prev[curr] : undefined;
        }, jsonObject);

        // 如果没找到对应的值，直接返回 undefined
        if (result === undefined) return undefined;

        // 【核心修改】：返回深拷贝，切断与原对象的引用联系
        return deepClone(result);
    }
    //设置引用值
    function setJsonValue(jsonObject, path, value) {
        if (!jsonObject || !path) return false;

        // 【核心修改】：统一路径解析，保持与 getJsonValue 一致
        const keys = path.split('.').filter(k => k.length > 0);
        if (keys.length === 0) return false; // 无法直接覆盖对象自身

        let current = jsonObject;
        for (let i = 0; i < keys.length - 1; i++) {
            const key = keys[i];
            // 增加容错：如果中间路径被非对象占用了（比如是个字符串），强制覆盖为空对象
            // 确保能继续往下挂载引用
            if (typeof current[key] !== 'object' || current[key] === null) {
                current[key] = {};
            }
            current = current[key];
        }

        const lastKey = keys[keys.length - 1];
        // 这里是标准的引用赋值，直接挂载到原对象对应的节点上
        current[lastKey] = value;
        return true;
    }

    //列表包含
    function hasElement(jsonObject, path, element) {
        const list = this.getJsonValue(jsonObject, path);
        return Array.isArray(list) && list.includes(element);
    }
    //列表添加
    function addElement(jsonObject, path, element) {
        let list = this.getJsonValue(jsonObject, path);

        // 如果不是数组，则初始化为空数组
        if (!Array.isArray(list)) {
            list = [];
        }

        // 只有不存在时才添加（去重）
        if (!list.includes(element)) {
            list.push(element);
            // 将修改后的副本写回原对象
            return this.setJsonValue(jsonObject, path, list);
        }
        return false; // 已存在，未执行修改
    }
    //列表删除
    function removeElement(jsonObject, path, element) {
        const list = this.getJsonValue(jsonObject, path);

        if (!Array.isArray(list)) return false;

        const index = list.indexOf(element);
        if (index > -1) {
            list.splice(index, 1); // 修改副本
            // 将修改后的副本写回原对象
            return this.setJsonValue(jsonObject, path, list);
        }

        return false; // 元素不存在，未执行删除
    }
    //对象键名
    function hasKey(jsonObject, path) {
        if (!jsonObject || !path) return false;
        const keys = path.split('.').filter(k => k.length > 0);
        if (keys.length === 0) return false;

        let current = jsonObject;
        for (let i = 0; i < keys.length; i++) {
            const key = keys[i];

            // 如果走到非对象节点，或者当前节点没有这个属性，说明路径断了
            if (current === null || typeof current !== 'object' || !Object.prototype.hasOwnProperty.call(current, key)) {
                return false;
            }
            // 继续往下走
            current = current[key];
        }
        return true; // 完整路径走通了，说明 Key 存在
    }
    //删除键名
    function removeKey(jsonObject, path) {
        if (!jsonObject || !path) return false;
        const keys = path.split('.').filter(k => k.length > 0);
        if (keys.length === 0) return false;

        let current = jsonObject;
        // 走到倒数第二层（目标键的父节点）
        for (let i = 0; i < keys.length - 1; i++) {
            const key = keys[i];
            if (current == null || typeof current !== 'object' || !Object.prototype.hasOwnProperty.call(current, key)) {
                return false; // 路径不存在，无需删除
            }
            current = current[key];
        }

        const lastKey = keys[keys.length - 1];
        // 确认父节点上确实有这个键，然后删除
        if (current != null && Object.prototype.hasOwnProperty.call(current, lastKey)) {
            delete current[lastKey]; // 原地删除属性
            return true;
        }
        return false;
    }
}