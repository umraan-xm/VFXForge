import QtQuick 2.15
import QtQuick.Controls 2.15


Button {
    id: control

    property int radius: 5
    property int borderWidth: 0

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        cursorShape: Qt.PointingHandCursor
    }

    background: Rectangle {
        color: control.hovered ? "#bbbbbb" : "#dddddd"
        
        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }

        radius: control.radius
        border.width: borderWidth
        border.color: Qt.rgba(0, 0, 0, 0.2)
    }
}