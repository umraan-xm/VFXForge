import QtQuick 2.15
import QtQuick.Controls 2.15
// import QtQuick.Controls.Basic

TextField {
        id: root

        width: parent.width 

        background: Rectangle {
            
            Rectangle {
                id: underline

                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                
                height: 2
                color: "#cccccc"
            }
            Rectangle {
                id: highlight

                anchors.left: parent.left
                anchors.bottom: parent.bottom

                height: 2
                width: 0

                color: "#007bff"

                Behavior on width {
                    PropertyAnimation {
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        onActiveFocusChanged: {
                if (root.activeFocus) {
                    highlight.width = underline.width
                } else if (root.text === "") {
                    highlight.width = 0
                }
            }
}