import QtQuick 2.11
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.15

ApplicationWindow {
    id: root
    visible: true
    width: 640
    height: 480
    minimumWidth: 400
    minimumHeight: 200
    title: 'VFXForge'

    Rectangle {
        width: parent.width
        height: parent.height
        color: "white"

        Column {
            anchors {
                centerIn: parent
            }
            spacing: 20

            Row {
                spacing: 10
                Text {
                    text: "Project Type"
                    width: 150
                }
                ComboBox {
                    id: projectTypeComboBox
                    width: 200
                    focusPolicy: Qt.NoFocus
                    model: ["VFX", "TV EPISODIC", "CG ANIMATION", "CG ANIMATION EPISODIC", "GAME"]
                }
            }
        }
    }
}