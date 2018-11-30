import QtQuick 2.5
import Sailfish.Silica 1.0
import Nemo.FileManager 1.0

Dialog {
    id: root
    property alias path: fileModel.path
    FileModel {
        id: fileModel
        active: root.status === PageStatus.Active
        directorySort: FileModel.SortDirectoriesBeforeFiles
        caseSensitivity: Qt.CaseInsensitive
    }
    SilicaListView {
        anchors.fill: parent
        header: DialogHeader {
            title: fileModel.path.match(/([^\/]*)\/?$/)[1] // the last part of the path
        }
        model: fileModel
        delegate: ListItem {
            visible: model.isDir
            readonly property string type: model.isDir ? "folder" : ExampleAssets.fileType(model.mimeType)

            Label { text: model.fileName }
            onClicked: {
                if (model.isDir) {
                    fileModel.path = fileModel.appendPath(model.fileName)
                }
            }
        }

        VerticalScrollDecorator { }

        ViewPlaceholder { // message when there are no items in the directory
            enabled: fileModel.count === 0
            text: qsTr("No files")
        }
    }
}
