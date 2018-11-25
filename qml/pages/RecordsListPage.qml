import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

Page {
    Dao {id: dao}
    EditRecord { id: dial}
    SilicaListView {
        id: view
         ViewPlaceholder {
            enabled: view.count == 0
            text: "No records yet"
            hintText: "Record something"
         }
         width: 720; height: 800
         model: ListModel {
             id: listModel

         }

         delegate: ListItem {
             width: ListView.view.width
             //height: Theme.itemSizeSmall

             Label {
                 anchors.horizontalCenter: parent.horizontalCenter
                 property string name
                 property string note
                 property string path
                 text: nam

             }
             onClicked: {
                console.log(path);
//                player.source = path;
//                player.play();
                pageStack.push(Qt.resolvedUrl('./PlayRecord.qml'),{"recordName": nam, "recordNote": note, "recordPath": path});

             }

             menu: ContextMenu {
                 MenuItem {
                    text: "Edit Record"
                    onClicked: {
                        var temp;
                        dao.retrieveRecordById(id, function(result) {
                            if (result !== null)
                                temp = result;
                            else
                                console.log("null");
                        })
                        var dialog = pageStack.push(dial,{"name": temp.Name, "note": temp.Note});
                        dialog.accepted.connect(function() {
                            dao.updateRecord(id, dialog.name, dialog.note);
                            selectRecs();
                        });
                    }
                }
                MenuItem {
                    text: "Remove"
                    onClicked: {
//                        var file = new QFile(path);
//                        file.remove();
                        dao.removeRecord(id);
                        selectRecs();
                    }
                }
            }
         }
     }

    function selectRecs() {
        listModel.clear();
        dao.retrieveRecords(function (recs) {
            for (var i = 0; i < recs.length; i++) {
                var rec = recs.item(i);
                listModel.append({id: rec.id, "nam": rec.Name, "note": rec.Note, "path": rec.Path});
            }
        });
    }

    Component.onCompleted: {
        selectRecs()
    }
}
