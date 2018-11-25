TARGET = multimedia

CONFIG += sailfishapp

SOURCES += \
    src/multimedia.cpp \
    src/AudioRecorder.cpp

HEADERS += \
    src/AudioRecorder.h

DISTFILES += \
    qml/* \
    rpm/multimedia.yaml \
    translations/*.ts \
    multimedia.desktop \
    qml/pages/SettingsDialog.qml \
    qml/Dao.qml \
    qml/pages/RecordsListPage.qml \
    qml/pages/EditRecord.qml \
    qml/pages/PlayRecord.qml


SAILFISHAPP_ICONS = 86x86 108x108 128x128 172x172
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/multimedia-ru.ts

OTHER_FILES += soundeffects/*
soundeffects.files = soundeffects/*
soundeffects.path = /usr/share/$$TARGET/soundeffects
INSTALLS += soundeffects

# ToDo: add requires to use QtMultimedia in C++

QT += multimedia
