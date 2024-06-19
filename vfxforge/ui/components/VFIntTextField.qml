import QtQuick 2.15
import QtQuick.Controls 2.15

TextField {
    id: control
   
    horizontalAlignment: TextInput.AlignLeft
    verticalAlignment: TextInput.AlignVCenter

    validator: IntValidator {bottom: 0; top: 99;}

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        cursorShape: Qt.IBeamCursor
        onWheel: (wheel) => {
            if (wheel.angleDelta.y > 0) {
                control.text = Math.min(Number(control.text) + 1, 99).toString();
            } else if (wheel.angleDelta.y < 0) {
                control.text = Math.max(Number(control.text) - 1, 0).toString();
            }
            control.textEdited()
        }
    }
}