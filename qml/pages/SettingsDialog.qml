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
                MenuItem { text: "low" }
                MenuItem { text: "normal" }
                MenuItem { text: "high" }
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
            }

            onCurrentItemChanged: {
                if (initDone) {
                    updateSettings();
                }
            }
        }
    }

    function updateSettings() {
        dao.writeSettings({
            Quality: quality.currentItem.text,
            ContainerFormat: format.currentItem.text,
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
           initDone = true;
       })
    }
}
