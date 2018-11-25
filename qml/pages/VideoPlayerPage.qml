import QtQuick 2.6
import Sailfish.Silica 1.0
import QtMultimedia 5.6

Page {
    allowedOrientations: Orientation.All
    // ToDo: pause playback when the page is not active
    onStatusChanged: player.pause()

    SilicaFlickable {
        anchors.fill: parent

        Video {
            id: player
            width: parent.width
            height: parent.height
            autoPlay: true
            // ToDo: change progress slider value when position changed

            onPositionChanged: player.seek(progressChange.value)

            MouseArea {
                anchors.fill: parent
                // ToDo: play or pause on clicked
                onClicked: {
                    if (player.playbackState == MediaPlayer.PlayingState) {
                        player.pause();
                    } else {
                        player.play();
                    }
                }
            }
        }
        PullDownMenu {
            id: videoSelectMenu
            quickSelect: true

            MenuItem {
                text: "Select Video"
                onClicked: {
                    var videoPicker = pageStack.push("Sailfish.Pickers.VideoPickerPage");
                    videoPicker.selectedContentChanged.connect(function () { player.source = videoPicker.selectedContent;
                    player.play(); });
                }
            }

            onClicked: {
                if (player.playbackState == MediaPlayer.PlayingState) {
                    player.pause();
                } else {
                    player.play();

                }
            }

            // ToDo: add item to call video picker
        }
    }



    Slider {
        id: progressChange
        minimumValue: 0
        maximumValue: player.duration
        stepSize: 1
        onReleased: player.position = value

    }


    // ToDo: add silder to control playback
}
