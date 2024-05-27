import QtQuick 2.11
import QtQuick.Window 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.4
import QtQuick.Controls 2.15
import QtQuick.Dialogs 

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
                    text: qsTr("Project Name")
                    width: 150
                }
                TextField {
                    placeholderText: qsTr("Enter a project name")
                    width: 150
                }
            }

            Row {
                spacing: 10
                Text {
                    text: qsTr("Project Path")
                    width: 150
                }
                TextField {
                    id: projectPathTextField
                    placeholderText: qsTr("Enter directory to place your project")
                    width: 150
                }
                FolderDialog {
                    id: projectPathFolderDialog
                    title: "Select Project Path"
                    onAccepted: {
                        projectPathTextField.text = selectedFolder;
                    }
                }
                Button {
                    height: projectPathTextField.height
                    anchors.verticalCenter: projectPathTextField.verticalCenter
                    text: "..."
                    onClicked: {
                        projectPathFolderDialog.open()
                    }
                }
            }

            Row {
                spacing: 10
                Text {
                    text: qsTr("Project Type")
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