import QtQuick 2.6
import Sailfish.Silica 1.0
import QtMultimedia 5.6
import Multimedia 1.0
import ".."

Page {
    id: playerPage
    property string recordNote : ""
    property string recordName : ""
    property string recordPath : ""

    Audio {
        id: player
        source: recordPath
        onPositionChanged: {
            progressBar.value = position
        }
    }

    Column {
        id: module
        anchors.fill: parent
        spacing: Theme.paddingLarge
        Label {
           anchors.horizontalCenter: parent.horizontalCenter
           id: name
           text: recordName
           font.pixelSize: Theme.fontSizeExtraLarge
           truncationMode: TruncationMode.Elide
        }
        Label {
           anchors.horizontalCenter: parent.horizontalCenter
           id: note
           text: recordNote
           font.pixelSize: 40
           font.italic: true
        }

        Slider {
            id: progressBar
            stepSize: 0.01
            //label: qsTr("Player position")
            width: parent.width
//                value: audioPlayer.position
            minimumValue: 0
            maximumValue: player.duration
            valueText: value/1000
            // ToDo: set value, minimumValue, maximumValue and valueText properties
//                enabled: false
            down: true
            visible: audioRecorder.state != AudioRecorder.RecordingState && audioRecorder.state != AudioRecorder.PausedState
            onValueChanged: {
                if (down)//Math.abs(value - audioPlayer.position) > 0.1)
                player.seek(value)
            }
        }
    }

        Row {
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: parent.bottom
                bottomMargin: Theme.paddingLarge
            }
           IconButton {
            id: playButton
            icon.source: "image://theme/icon-m-media"
            enabled: true
            onClicked: {
                    player.play()
            }
            visible: player.playbackState == Audio.PausedState || player.playbackState == Audio.StoppedState
          }

           IconButton {
               icon.source: "image://theme/icon-m-pause?" + (pressed
                                               ? Theme.highlightColor
                                               : Theme.primaryColor)
               onClicked: {
                   player.pause()
               }

               visible: player.playbackState == Audio.PlayingState
           }

          IconButton {
            icon.source: "image://theme/icon-m-tabs?" + (pressed
                                               ? Theme.highlightColor
                                               : Theme.primaryColor)
            onClicked: {
                player.stop();
            }
            enabled: player.playbackState != Audio.StoppedState
          }
        }

}
