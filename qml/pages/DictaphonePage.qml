import QtQuick 2.6
import Sailfish.Silica 1.0
import QtMultimedia 5.6
import Multimedia 1.0
import "../assets"
import ".."

Page {
    Dao { id: dao }
    SilicaFlickable {
        anchors.fill: parent
        id: dict
        property string fileName: ""
        property string saveLocation: StandardPaths.documents
        property string format: "wav"
        property string filePath: saveLocation + "/" + fileName + "." + format

        PullDownMenu {
            MenuItem {
                text: "All Records "
                onClicked: pageStack.push(Qt.resolvedUrl('./RecordsListPage.qml'));
            }
            MenuItem {
                text: "Settings"
                onClicked: {
                    function done() {
                        reloadSettings();
                    }
                    var dialog = pageStack.push(Qt.resolvedUrl('./SettingsDialog.qml'));
                    dialog.accepted.connect(done);
                    dialog.rejected.connect(done);
                }
            }
        }

        AudioRecorder {
            id: audioRecorder
            outputLocation: dict.filePath

            onStateChanged: {
                if (audioRecorder.state == AudioRecorder.StoppedState) {
                    console.log(audioRecorder.outputLocation);
                    audioPlayer.source = "";
                    //dict.fileName = new Date().toISOString().replace(/\.|:/g, "-");
                    audioPlayer.source = dict.filePath;
                    dao.createRecord(dict.fileName, " ", dict.filePath);
                }
            }

            // ToDo: handle stop to reload audioPlayer
        }
        Audio {
            id: audioPlayer
            source: dict.filePath
            autoLoad: true
            onPositionChanged: {
                playInfo.value = position
            }

        }
        Column {
            anchors.fill: parent
            spacing: Theme.paddingLarge

            PageHeader { title: qsTr("Dictaphone") }
            ValueDisplay {
                id: recordInfo
                label: qsTr("Recorded duration")
                value: audioRecorder.duration / 1000
                // ToDo: set text property to show recorded duration in seconds
                width: parent.width
            }
            Slider {
                id: playInfo
                stepSize: 0.01
                label: qsTr("Player position")
                width: parent.width
//                value: audioPlayer.position
                minimumValue: 0
                maximumValue: audioPlayer.duration
                valueText: value/1000
                // ToDo: set value, minimumValue, maximumValue and valueText properties
//                enabled: false
                down: true
                visible: audioRecorder.state != AudioRecorder.RecordingState && audioRecorder.state != AudioRecorder.PausedState
                onValueChanged: {
                    if (down)//Math.abs(value - audioPlayer.position) > 0.1)
                    audioPlayer.seek(value)
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
                icon.source: "image://theme/icon-m-call-recording-on"
                onClicked: {
                    if (audioRecorder.state != AudioRecorder.PausedState)
                     dict.fileName = new Date().toISOString().replace(/\.|:/g, "-");
                    audioRecorder.record()
                }
                visible: audioRecorder.state != AudioRecorder.RecordingState && audioPlayer.playbackState == Audio.StoppedState
            }
            IconButton {
                icon.source: "image://theme/icon-m-pause"
                onClicked: {
                    audioRecorder.pause()
                }
                visible: audioRecorder.state == AudioRecorder.RecordingState && audioPlayer.playbackState == Audio.StoppedState
            }
            IconButton {
                icon.source: "image://theme/icon-m-call-recording-off"
                onClicked: {
                    audioRecorder.stop()
                }
                visible: audioRecorder.state != AudioRecorder.StoppedState && audioPlayer.playbackState == Audio.StoppedState
            }


            IconButton {
                icon.source: "image://theme/icon-m-play"
                onClicked: {
                    audioPlayer.play()
                }

                visible: audioPlayer.playbackState == Audio.PausedState || (audioPlayer.playbackState == Audio.StoppedState && audioRecorder.state == AudioRecorder.StoppedState)



            }
            IconButton {
                icon.source: "image://theme/icon-m-pause"
                onClicked: {
                    audioPlayer.pause()
                }
                visible: audioRecorder.state == AudioRecorder.StoppedState && audioPlayer.playbackState == Audio.PlayingState
            }


            IconButton {
                icon.source: "image://theme/icon-m-clear"
                onClicked: {
                    audioPlayer.stop()
                }
                visible: audioPlayer.playbackState != Audio.StoppedState && audioRecorder.state == AudioRecorder.StoppedState
            }

            // ToDo: add button to start recording
            // ToDo: add button to pause recording
            // ToDo: add button to stop recording
            // ToDo: add button to start playing
            // ToDo: add button to pause playing
            // ToDo: add button to stop playing




            // ToDo: control buttons visibility
        }
    }

    function reloadSettings() {
        dao.readSettings(function(settings) {
            audioRecorder.configure(settings.Quality, settings.ContainerFormat, settings.Codec);
            dict.format = settings.ContainerFormat;
            dict.saveLocation = settings.SaveLocation;
        })
    }

    Component.onCompleted: {
        reloadSettings();
    }
}
