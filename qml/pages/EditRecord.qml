import QtQuick 2.0
import Sailfish.Silica 1.0


Dialog {
    id: dial
    property string name
    property string note

    canAccept: {
        if (nameField.text == "")
            false
        else
            true
    }

    Column {
            width: parent.width

            DialogHeader {
                acceptText: "Save"
            }

            TextField {
                id: nameField
                width: 480
                label: "Name"
                placeholderText: "Name"
                text: name
                EnterKey.onClicked: textArea.focus = true
            }
            TextArea {
                id: textArea
                width: 720
                label: "Note"
                text: note
                placeholderText: "Write something"
                EnterKey.onClicked: dial.accept();
            }

        }

        onDone: {
            if (result == DialogResult.Accepted) {
                name = nameField.text
                note = textArea.text
                close()
            }
            if (result == DialogResult.Rejected) {
                close()
            }
        }
}
