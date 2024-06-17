import QtQuick 2.15
import QtQuick.Controls 2.15

ComboBox {
    id: control

    // focusPolicy: Qt.NoFocus

    indicator: Item{

    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        cursorShape: Qt.PointingHandCursor
    }

    background: Rectangle {
        id: controlBackgroundRectangle

        color: control.hovered ? "#cccccc": "#eeeeee"

        radius: 5

        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }
    }

    popup: Popup {
        id: popup
        width: control.width
        height: Math.min(contentItem.implicitHeight, control.Window.height - 20)
        y: control.height

        padding: 0

        opacity: 1.0

        Behavior on opacity {
            PropertyAnimation {
                duration: 300
            }
        }

        onOpened: opacity = 1
        onClosed: opacity = 0 

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.delegateModel
            currentIndex: control.highlightedIndex
            highlightMoveDuration: 0

            Rectangle {
                width: parent.width
                height: parent.height
                color: "transparent"
                border.color: popupBackgroundRectangle.border.color
                radius: popupBackgroundRectangle.radius
            }
        }

        background: Rectangle {
            id: popupBackgroundRectangle
            color: "#ffffff"
            border.color: "#cccccc"
            // border.width: 20
            radius: 5
        }
    }
    
}