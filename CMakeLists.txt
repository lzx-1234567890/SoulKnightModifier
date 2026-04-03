cmake_minimum_required(VERSION 3.16)

project(SoulKnightModifier VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 QuickEffects Svg Xml Network)

qt_standard_project_setup(REQUIRES 6.10)

set_source_files_properties(
    src/ui/qml/Style.qml
    src/ui/qml/Util.qml
    PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

file(GLOB_RECURSE IMAGE_FILES CONFIGURE_DEPENDS
    RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
    "assets/icon/*.svg"
    "assets/icon/*.png"
    "assets/common/*.png"
    "assets/item/material/*.png"
    "assets/item/seed/*.png"
    "assets/item/token_ticket/*.png"
    "assets/factor/*.png"
    "assets/factor/*.gif"
    "assets/weapon/*.png"
    "assets/weapon/*.gif"
    "assets/character/*.png"
    "assets/pet/*.png"
)

if(WIN32)
    set(app_icon_resource "src/resources.rc")
endif()

qt_add_executable(appSoulKnightModifier
    src/main.cpp
    ${app_icon_resource}
)

qt_add_qml_module(appSoulKnightModifier
    URI SoulKnightModifier
    SOURCES
        src/data/save_file_info.h
        src/data/save_file_info.cpp
        src/manager/save_game_manager.h
        src/manager/save_game_manager.cpp
        src/manager/update_manager.h
        src/manager/update_manager.cpp
        src/model/save_list_model.h
        src/model/save_list_model.cpp
        src/utils/file_processor.h
        src/utils/file_processor.cpp
        src/utils/save_game_processor.h
        src/utils/save_game_processor.cpp
        src/utils/lite_des.h
        src/utils/lite_des.cpp
        src/utils/json_processor.h
        src/utils/json_processor.cpp
    QML_FILES
        src/ui/qml/Main.qml
        src/ui/qml/Util.qml
        src/ui/qml/Style.qml
        src/ui/qml/Component/Toast.qml
        src/ui/qml/Component/SaveFileTabBar.qml
        src/ui/qml/Component/CategoryTabBar.qml
        src/ui/qml/Component/NavigationSideBar.qml
        src/ui/qml/Component/BottomToolBar.qml
        src/ui/qml/Component/CustomDialog.qml
        src/ui/qml/Component/NormalButton.qml
        src/ui/qml/Component/NormalSwitch.qml
        src/ui/qml/Component/CardView.qml
        src/ui/qml/Component/ModifySwitch.qml
        src/ui/qml/Component/ModifySwitch2.qml
        src/ui/qml/Component/ModifySwitch3.qml
        src/ui/qml/Component/ModifySwitch4.qml
        src/ui/qml/Component/ModifySwitch5.qml
        src/ui/qml/Component/LevelEdit.qml
        src/ui/qml/Component/LevelEdit2.qml
        src/ui/qml/Component/JewelryEdit.qml
        src/ui/qml/Component/ItemEdit.qml
        src/ui/qml/Component/ItemAddDialog.qml
        src/ui/qml/Component/CharacterChooseDialog.qml
        src/ui/qml/Component/WeaponChooseDialog.qml
        src/ui/qml/Component/NormalEdit.qml
        src/ui/qml/Component/NormalEdit2.qml
        src/ui/qml/Component/UpdateDisplayDialog.qml
        src/ui/qml/QuickEdit.qml
        src/ui/qml/ManualEdit.qml
        src/ui/qml/UsefulTool.qml
        src/ui/qml/Setting.qml
        src/ui/qml/About.qml
        src/ui/qml/Tutorial.qml
        src/ui/qml/QuickEdit/ItemData/ItemData.qml
        src/ui/qml/QuickEdit/ItemData/BluePrintUnlock.qml
        src/ui/qml/QuickEdit/ItemData/MythicWeapon.qml
        src/ui/qml/QuickEdit/ItemData/Jewelry.qml
        src/ui/qml/QuickEdit/ItemData/ItemStorage.qml
        src/ui/qml/QuickEdit/Xml/Xml.qml
        src/ui/qml/QuickEdit/Xml/Basic.qml
        src/ui/qml/QuickEdit/Xml/Character.qml
        src/ui/qml/QuickEdit/Xml/Pet.qml
        src/ui/qml/QuickEdit/SeasonData/SeasonData.qml
        src/ui/qml/QuickEdit/SeasonData/Season.qml
        src/ui/qml/QuickEdit/SeasonData/Basic.qml
        src/ui/qml/QuickEdit/SeasonData/SeasonDetail.qml
        src/ui/qml/QuickEdit/SeasonData/SeasonDetail2.qml
        src/ui/qml/QuickEdit/SeasonData/SeasonDetail3.qml
        src/ui/qml/QuickEdit/SeasonData/SeasonDetail4.qml
        src/ui/qml/QuickEdit/Task/Task.qml
        src/ui/qml/QuickEdit/Statistic/Statistic.qml
        src/ui/qml/QuickEdit/WeaponEvolution/WeaponEvolution.qml
        src/ui/qml/About/UpdateAnnocementDialog.qml
        src/ui/qml/About/FunctionListDialog.qml
    RESOURCES
        src/app_icon.ico
        src/qtquickcontrols2.conf
        src/ui/js/ItemData.js
        src/ui/js/XmlData.js
        src/ui/js/SeasonData.js
        src/ui/js/WeaponEvolutionData.js
        ${IMAGE_FILES}
)

target_include_directories(appSoulKnightModifier PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/src/data
    ${CMAKE_CURRENT_SOURCE_DIR}/src/manager
    ${CMAKE_CURRENT_SOURCE_DIR}/src/utils
    ${CMAKE_CURRENT_SOURCE_DIR}/src/model
)


# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appSoulKnightModifier PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appSoulKnightModifier
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appSoulKnightModifier
    PRIVATE
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::QuickEffects
    Qt6::Svg
    Qt6::Xml
    Qt6::Network
)

target_compile_definitions(appSoulKnightModifier PRIVATE
    APP_VERSION="${PROJECT_VERSION}"
)

install(TARGETS appSoulKnightModifier
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
