import QtQuick 2.6
import Sailfish.Silica 1.0

ApplicationWindow {
    initialPage: Qt.resolvedUrl("pages/DictaphonePage.qml")
    cover: Component { CoverBackground { } }
    allowedOrientations: defaultAllowedOrientations
}
