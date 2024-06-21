import QtQuick 2.15
import QtQuick.Controls 2.15

ComboBox {
    id: control

    // focusPolicy: Qt.NoFocus
    implicitHeight: popup.contentItem.implicitHeight + 30

    indicator: Image {
            id: downArrowIcon
            source: "../images/down_arrow.svg"

            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 10

            fillMode: Image.PreserveAspectFit

            height: 15
            width: 15

            Behavior on rotation {
                RotationAnimation {
                    duration: 350
                    easing.type: Easing.Linear
                }
            }
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

        onOpened: {
            downArrowIcon.rotation = 180
            opacity = 1
        }
        onClosed: {
            downArrowIcon.rotation = 0
            opacity = 0 
        }

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