QT += quick

SOURCES += \
        $$files(src/*.cpp) \
        src/settingsreader.cpp
HEADERS += \
        $$files(src/*.h) \
        src/defaultsettings.h \
        src/settingsreader.h

#resources.files = qml/main.qml
#resources.prefix = /$${TARGET}
RESOURCES += mainResources.qrc #resources \


# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = /qml/modules

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH = /qml/modules

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target



#QMAKE_POST_LINK = qmllint $$PWD/qml/WelcomeScreen.qml

#DISTFILES += \
#    qml/TestScreen.qml \
#    qml/WelcomeScreen.qml
