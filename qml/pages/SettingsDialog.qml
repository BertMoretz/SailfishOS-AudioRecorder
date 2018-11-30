import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

Dialog {
    forwardNavigation: false
    property bool initDone: false
    Dao {id: dao}

    Column {
        width: parent.width

        DialogHeader {
            acceptText: ""
            cancelText: "Back"
        }

        ComboBox {
            id: quality
            width: parent.width
            label: "Quality"

            menu: ContextMenu {
                MenuItem { text: "verylow" }
                MenuItem { text: "low" }
                MenuItem { text: "normal" }
                MenuItem { text: "high" }
                MenuItem { text: "veryhigh" }
            }

            onCurrentItemChanged: {
                if (initDone) {
                    updateSettings();
                }
            }
        }

        ComboBox {
            id: format
            width: parent.width
            label: "Container Format"

            menu: ContextMenu {
                MenuItem { text: "wav" }
                MenuItem { text: "ogg" }
                MenuItem { text: "avi" }
            }

            onCurrentItemChanged: {
                if (initDone) {
                    updateSettings();
                }
            }
        }

        ComboBox {
            id: codec
            width: parent.width
            label: "Audio Codec"

            menu: ContextMenu {
                MenuItem { text: "audio/PCM" }
                MenuItem { text: "audio/vorbis" }
                MenuItem { text: "audio/speex" }
                MenuItem { text: "audio/FLAC" }
            }

            onCurrentItemChanged: {
                if (initDone) {
                    updateSettings();
                }
            }
        }

        ValueButton {
            id: saveLocation
            label: "Save Location"
            onClicked: {
                var dialog = pageStack.push(Qt.resolvedUrl('./DirectoryPage.qml'),{path:StandardPaths.home});
                dialog.accepted.connect(function() {
                    value = dialog.path;
                    if (initDone) {
                        updateSettings();
                    }
                });
            }
        }
    }

    function updateSettings() {
        dao.writeSettings({
            Quality: quality.currentItem.text,
            ContainerFormat: format.currentItem.text,
            SaveLocation: saveLocation.value,
            Codec: codec.currentItem.text,
        });
    }

    Component.onCompleted: {
       dao.readSettings(function(settings) {
           for (var i = 0; i < quality.menu.children.length; i ++) {
               if (quality.menu.children[i].text === settings.Quality) {
                   quality.currentIndex = i;
               }
           }
           for (var i = 0; i < format.menu.children.length; i ++) {
               if (format.menu.children[i].text === settings.ContainerFormat) {
                   format.currentIndex = i;
               }
           }
           saveLocation.value = settings.SaveLocation;
           for (var i = 0; i < codec.menu.children.length; i ++) {
               if (codec.menu.children[i].text === settings.Codec) {
                   codec.currentIndex = i;
               }
           }
           initDone = true;
       })
    }
}
