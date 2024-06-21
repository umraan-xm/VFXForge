import QtQuick 2.15
import QtQuick.Controls 2.15
// import QtQuick.Controls.Basic

TextField {
        id: control

        // width: parent.width 

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
                width: control.activeFocus ? underline.width : 0

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
                if (control.activeFocus) {
                    highlight.width = underline.width
                } else if (control.text === "") {
                    highlight.width = 0
                }
            }
}