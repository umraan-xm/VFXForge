import QtQuick 2.15
import QtQuick.Controls 2.15

TabButton {
    background: Rectangle {
        anchors.fill: parent

        color: parent.checked ? "#999999": (parent.hovered ? "#bbbbbb" : "#dddddd")

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            cursorShape: Qt.PointingHandCursor
        }

        Behavior on color {
            ColorAnimation {
                duration: 300
            }
        }
    }
}