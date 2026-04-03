pragma Singleton
import QtQuick

QtObject {
    property bool isDark: true

    readonly property string qmlBase: "qrc:/qt/qml/SoulKnightModifier/src/ui/qml/"
    readonly property string iconBase: "qrc:/qt/qml/SoulKnightModifier/assets/icon/"
    readonly property string itemBase: "qrc:/qt/qml/SoulKnightModifier/assets/item/"
    readonly property string commonBase: "qrc:/qt/qml/SoulKnightModifier/assets/common/"
    readonly property string characterBase: "qrc:/qt/qml/SoulKnightModifier/assets/character/"
    readonly property string petBase: "qrc:/qt/qml/SoulKnightModifier/assets/pet/"
    readonly property string weaponBase: "qrc:/qt/qml/SoulKnightModifier/assets/weapon/"


    readonly property color windowBg: isDark ? "#121212" : "#F0F7FF" //主窗口背景
    readonly property color sidebarBg: isDark ? "#1E1E1E" : "#FFFFFF" //侧边栏背景
    readonly property color tabbarBg: isDark ? "#1E1E1E" : "#FFFFFF"  //标签栏背景
    readonly property color toolbarBg: isDark ? "#1E1E1E" : "#FFFFFF" //工具栏背景


    readonly property color normal: isDark ? yellowLight : blueSky //透明背景 底色
    readonly property color hovered: isDark ? yellowHovered : blueHovered //透明背景 悬浮
    readonly property color pressed: isDark ? yellowPressed : bluePressed //透明背景 按压

    readonly property color cardBg: isDark ? "#1E1E1E" : "#FFFFFF"//卡片 背景
    readonly property color cardTitle: isDark ? yellowGold : blueSky //卡片 标题

    readonly property color dialogBg: isDark ? "#1E1E1E" : "#FFFFFF" //对话框 背景
    readonly property color dialogClose: "red" //对话框 关闭按钮底色
    readonly property color dialogBorder: isDark ? greyLine : blueLine //对话框 边缘

    readonly property color toastBg: isDark ? "#FFFFFF" : "#CC000000"
    readonly property color toastText: isDark ? "#1E293B" : "#FFFFFF"


    readonly property color inputBg: isDark ? "#2D2D2D" : "#F8FAFC" // 输入框背景
    readonly property color inputText: isDark ? "white" : "black" // 输入框文字
    readonly property color inputPlaceholder: isDark ? greyPlaceholder :blueLine // 输入框提示文字
    readonly property color inputBorderNormal: isDark ? greyLine : blueLine // 输入框边缘普通
    readonly property color inputBorderActive: isDark ?yellowLight : blueSky // 输入框边缘选中

    readonly property color buttonNormal: isDark ? yellowLight : blueSky //按钮 普通
    readonly property color buttonHovered: isDark ? yellowGold : blueNormal //按钮 悬浮
    readonly property color buttonPressed: isDark ? yellowDeep : blueDeep //按钮 按压
    readonly property color buttonText: "black" //按钮 文字

    readonly property color switchBgNotChecked: greyDisabled //开关 关闭背景
    readonly property color switchBgChecked: isDark ? yellowGold : blueNormal //开关 开启背景
    readonly property color switchIndicatorNotChecked: "white" //开关 关闭指示器颜色
    readonly property color switchIndicatorChecked: isDark ? brownMain : blueDeep //开关 开启指示器颜色
    readonly property color switchBorderNotChecked: isDark ? yellowGold : blueNormal //开关 关闭边缘色彩
    readonly property color switchBorderChecked: isDark ? "white" : blueLine //开关 开启边缘色彩
    readonly property color switchTextNotChecked: isDark ? "white" : "#1E293B" //开关 关闭时文本颜色
    readonly property color switchTextChecked: isDark ? yellowGold : blueNormal //开关 开启时文本颜色
    readonly property color switchTextDisabled: isDark ? greyDisabled : greyDisabled2 //开关 禁用时文本颜色

    readonly property color radioButtonIndicator: isDark ? yellowGold : blueNormal //单选按钮 指示器
    readonly property color radioButtonBorderNormal: isDark ? "white" : blueLine //单选按钮 正常边缘色彩
    readonly property color radioButtonBorderActive: isDark ? yellowGold : blueNormal //单选按钮 悬浮或选中边缘色彩
    readonly property color radioButtonDisabled: isDark ? greyDisabled : greyDisabled2 //单选按钮 禁用

    readonly property color textNormal: isDark ? "white" : "#1E293B" //文本 样式1
    readonly property color textNormal2: isDark ? yellowLight : blueSky //文本 样式2
    readonly property color textNormal3: isDark ? yellowGold : blueNormal //文本 样式3
    readonly property color textModified: "red" //文本 修改
    readonly property color textPlaceholder: greyPlaceholder //文本 placeholder
    readonly property color textDisabled: greyDisabled //文本 禁用

    readonly property color iconNormal: isDark ? "white" : "#1E293B" //图标 样式1
    readonly property color iconNormal2: isDark ? yellowLight : blueSky //图标 样式2
    readonly property color iconNormal3: isDark ? yellowGold : blueNormal //图标 样式3

    readonly property color indicator: isDark ? yellowGold : blueNormal //指示器 样式1
    readonly property color indicator2: isDark ? "white" : blueSky //指示器 样式2


    readonly property color smallCardBorderNormal: isDark ? "white" : blueLine //小卡片 普通边缘色
    readonly property color smallCardBorderActive: isDark ? yellowGold : blueNormal //小卡片 悬浮边缘色
    readonly property color smallCardBgNormal: "transparent" //小卡片 普通背景
    readonly property color smallCardBgHovered: isDark ? yellowHovered : blueHovered //小卡片 悬浮背景
    readonly property color smallCardBgPressed: isDark ? yellowPressed : bluePressed //小卡片 按压背景

    readonly property color sliderFilled: isDark ? yellowGold : blueNormal //拖动条 填充色
    readonly property color sliderNotFilled: isDark ? "white" : blueLine //拖动条 未填充色
    readonly property color sliderIndicatorNormal: isDark ? yellowGold : blueNormal //拖动条 指示器普通
    readonly property color sliderIndicatorActive: isDark ? yellowDeep : blueDeep //拖动条 指示器按压
    readonly property color sliderDisabled: isDark ? greyDisabled : greyDisabled2 //拖动条 禁用

    readonly property color line: isDark ? greyLine : blueLine //虚线

    readonly property color yellowLight: "#FFFDE7" //接近白色的淡黄
    readonly property color yellowGold: "#FFE082" //金黄色
    readonly property color yellowDeep: "#C79A30" //深黄色
    readonly property color yellowHovered: "#1AFFFDE7" //悬浮色
    readonly property color yellowPressed: "#40FFFDE7" //按压色

    readonly property color blueSky: "#23B4F7" //天空蓝
    readonly property color blueNormal: "#4BA1FF" //普通蓝
    readonly property color blueDeep: "#0040FF" //深蓝
    readonly property color blueLine: "#E2E8F0" //线的颜色
    readonly property color blueHovered: "#3300A7F5" //悬浮色
    readonly property color bluePressed: "#7700A7F5" //按压色


    readonly property color brownMain: "#3E2723" //标准棕色

    readonly property color greyDisabled: "#444444" //禁用的灰色
    readonly property color greyDisabled2: "#94A3B8" //禁用的灰色
    readonly property color greyLine: "#1AFFFFFF" //线的颜色
    readonly property color greyPlaceholder: "#1AFFFFFF" //文本


}