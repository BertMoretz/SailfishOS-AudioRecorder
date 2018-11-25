import QtQuick 2.6
import Sailfish.Silica 1.0
import QtMultimedia 5.6

Page {
    property var metaBySource: new Object

    Audio {
        id: audioPlayer
        autoLoad: false
        playlist: playlist
    }
    Playlist { id: playlist }
    SilicaListView {
        id: playlistView
        anchors { fill: parent; bottomMargin: buttonsRow.height }
        header: PageHeader { title: qsTr("Playlist") }
        model: playlist
        delegate: ListItem {
            // ToDo: add menu to remove item
            // ToDo: make current on clicked
            menu: ContextMenu {
                MenuItem{
                    text: "Remove"
                    onClicked: {
                        playlist.removeItem(model.index)
                    }
                }
            }

            onClicked: {
                playlist.currentIndex = model.index
                audioPlayer.play();
            }

            Label {
                // ToDo: show title but not the url
                text: metaBySource[source].title
                font.bold: playlist.currentIndex === model.index
                // ToDo: highlight current track with bold font
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    right: parent.right
                    margins: Theme.horizontalPageMargin
                }
                color: highlighted ? Theme.highlightColor : Theme.primaryColor
            }
        }

        PullDownMenu {
            quickSelect: true

            MenuItem {
                text: qsTr("Select music")
                onClicked: {
                    var musicPicker = pageStack.push("Sailfish.Pickers.MultiMusicPickerDialog");
                    musicPicker.accepted.connect(function () {
                        playlist.clear();
                        metaBySource = new Object;
                        for (var iSelectedItem = 0; iSelectedItem < musicPicker.selectedContent.count; ++iSelectedItem) {
                            var selectedItem = musicPicker.selectedContent.get(iSelectedItem);
                            metaBySource[selectedItem.url] = {
                                title: selectedItem.title,
                                fileName: selectedItem.fileName,
                                filePath: selectedItem.filePath,
                                mime: selectedItem.mimeType,
                                // ToDo: store content properties
                            }
                            playlist.addItem(selectedItem.url)
                            // ToDo: add url to playlist
                        }
                        audioPlayer.play()
                        // ToDo: start playing
                    });
                    musicPicker.rejected.connect(function () {
                        playlist.clear()
                    });
                }
            }
        }
    }
    Row {
        id: buttonsRow
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: Theme.paddingLarge
        }
        spacing: Theme.paddingLarge
        IconButton {
                            icon.source: "image://theme/icon-m-shuffle?" + (pressed
                                         ? Theme.highlightColor
                                         : Theme.primaryColor)
                            onClicked: {
                                playlist.shuffle()
                            }
                        }
        IconButton {
                            icon.source: "image://theme/icon-m-previous?" + (pressed
                                         ? Theme.highlightColor
                                         : Theme.primaryColor)
                            onClicked: {
                                playlist.previous()
                            }
                        }
        IconButton {
                            icon.source: "image://theme/icon-m-next?" + (pressed
                                         ? Theme.highlightColor
                                         : Theme.primaryColor)
                            onClicked: {
                                playlist.next()
                            }
                        }
        // ToDo: add buttons for suffle playlist, move to previous and next tracks
    }
}
