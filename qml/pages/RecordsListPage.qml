import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."
import Multimedia 1.0

Page {
    Column {
        id: col1
    PageHeader {
        id: header
        title: qsTr("All Records")
    }
    Dao {id: dao}
    EditRecord { id: dial}
    SilicaListView {
        anchors.topMargin: header.height

        id: view
         ViewPlaceholder {
            enabled: view.count == 0
            text: "No records yet"
            hintText: "Record something"
         }
         width: 720; height: 1000
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
                            dao.updateRecord(id, dialog.name, dialog.note,function(){
                                col1.selectRecs();
                            });
                        });
                    }
                }
                MenuItem {
                    text: "Remove"
                    onClicked: {
                        console.log('delete', path)//REMOVE
                        fileApi.remove(path);
                        dao.removeRecord(id,function(){
                            col1.selectRecs();
                        });

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

    FileApi {
        id: fileApi
    }

    Component.onCompleted: {
        selectRecs()
    }
}

}
