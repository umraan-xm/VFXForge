import QtQuick 
import QtQuick.Window 
import QtQuick.Controls 
import QtQuick.Layouts 
import QtQuick.Controls 
// import QtQuick.Controls.Material
import QtQuick.Dialogs
import QtQml.Models 

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

            // PROJECT NAME
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

            // PROJECT PATH
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
                    title: qsTr("Select Project Path")
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

            // PROJECT TYPE
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
                    model: backend !== null ? backend.projectTypes : []
                }
            }

            ToolSeparator {
                orientation: Qt.Horizontal
                width: parent.width
            }

            // ASSET SECTION
            Row {
                width: parent.width
                Column {
                    id: assetSectionColumn
                    width: parent.width
                    
                    // ADD OR DELETE ASSET BUTTONS
                    Row {
                        spacing: 0

                        bottomPadding: 20
                        
                        property int sectionHeight: 25

                        Text {
                            width: 120
                            anchors.verticalCenter: assetCountTextField.verticalCenter

                            text: qsTr("Number of Assets")
                        }

                        TextField {
                            id: assetCountTextField
                            width: 40
                            height: parent.sectionHeight - 2
                            horizontalAlignment: TextInput.AlignLeft
                            verticalAlignment: TextInput.AlignVCenter
                            leftPadding: 5
                            
                            rightInset: -2
                            

                            validator: IntValidator {bottom: 1; top: 99;}
                            text: String(1)

                        }

                        Button {
                            height: parent.sectionHeight
                            width: height
                            anchors.verticalCenter: assetCountTextField.verticalCenter
                            rightInset: -1
                            

                            text: "+"

                            onClicked: {
                                assetListView.model.add("", "")
                            }
                        }

                        Button {
                            height: parent.sectionHeight
                            width: height
                            anchors.verticalCenter: assetCountTextField.verticalCenter
                            leftInset: -2
                            leftPadding: 1
                           

                            text: "-"

                            onClicked: {
                                if(assetListView.model.count > 0){
                                    assetListView.model.pop()
                                }
                            } 
                        }

                        Button {
                            height: parent.sectionHeight
                            width: 50
                            anchors.verticalCenter: assetCountTextField.verticalCenter

                            text: qsTr("Clear")
                        }
                    }

                    // DISPLAY ASSETS
                    Row {
                        
                        ScrollView {
                            width: assetSectionColumn.width
                            height: 150
                            clip: true
                            
                            ListView {
                                id: assetListView
                                model: assetListModel
                                spacing: 20

                                delegate: Column {
                                    Component.onCompleted: {
                                        
                                    }
                                   
                                    // ASSET TYPE
                                    Row {
                                        spacing: 10

                                        Text {
                                            width: 80

                                            text: qsTr("Asset Type")
                                        }

                                        ComboBox {
                                            id: assetTypeComboBox

                                            width: 150

                                            model: backend !== null ? backend.assetTypes : []
                                            onCurrentTextChanged: {
                                                // Set the roles defined in AssetListModel
                                                name = assetNameTextField.text
                                                type = currentText
                                            }
                                        }
                                    }

                                    // ASSET NAME
                                    Row {
                                        spacing: 10

                                        Text {
                                            width: 80

                                            text: qsTr("Asset Name")
                                        }

                                        TextField {
                                            id: assetNameTextField
                                            
                                            width: 150

                                            placeholderText: qsTr("Enter asset name")
                                            validator: RegularExpressionValidator { regularExpression: /[a-zA-Z]*/}
                                            onEditingFinished: {
                                                // Set the roles defined in AssetListModel
                                                name = text
                                                type = assetTypeComboBox.currentText
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Row {
                Button {
                    text: qsTr("Create")
                    onClicked: {
                        if (projectNameTextField.text === "" || projectPathTextField.text === ""){
                            errorMessageDialog.informativeText = qsTr("Project Name and Path cannot be empty!");
                            errorMessageDialog.open();
                        } else if (!assetListView.model.isValid){
                            errorMessageDialog.informativeText = qsTr("Please enter asset names");
                            errorMessageDialog.open();
                        } else{
                            backend.createProject(projectPathTextField.text, projectNameTextField.text, projectTypeComboBox.currentText, assetListView.model.assets);
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