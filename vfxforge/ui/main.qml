import QtQuick 
import QtQuick.Window 
import QtQuick.Controls 
import QtQuick.Layouts 
import QtQuick.Controls 
// import QtQuick.Controls.Material
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

        Component.onCompleted: {
            // Preload the ComboBox popup
            projectTypeComboBox.popup.visible = true
            projectTypeComboBox.popup.visible = false
        }

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
                    id: projectNameTextField
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
                    width: 300
                }
                FolderDialog {
                    id: projectPathFolderDialog
                    title: "Select Project Path"
                    onAccepted: {
                        projectPathTextField.text = String(selectedFolder).replace("file:///", "");
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

            Row {
                Button {
                    text: qsTr("Create")
                    onClicked: {
                        if (projectNameTextField.text === "" || projectPathTextField.text === ""){
                            errorMessageDialog.informativeText = qsTr("Project Name and Path cannot be empty!");
                            errorMessageDialog.open();
                        } else{
                            backend.createProject(projectPathTextField.text, projectNameTextField.text, projectTypeComboBox.currentText)
                        }
                    }
                }
            }
        }
    }

    MessageDialog {
        id: errorMessageDialog
        title: "Error"
        informativeText: ""
        buttons: MessageDialog.Ok
    }
}