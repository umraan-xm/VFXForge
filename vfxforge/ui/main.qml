import QtQuick 
import QtQuick.Window 
import QtQuick.Layouts 
// import QtQuick.Controls 
import QtQuick.Controls.Basic
import QtQuick.Dialogs
import QtQml.Models 

import "./components"

ApplicationWindow {
    id: root
    visible: true
    width: 1280
    height: 720
    minimumWidth: 640
    minimumHeight: 480
    title: 'VFXForge'

    font.pointSize: 12
    font.family: "Calibri"

    MouseArea {
        anchors.fill: parent
        onClicked: forceActiveFocus()
    }

    Rectangle {
        width: parent.width
        height: parent.height
        // color: "grey"

        Component.onCompleted: {
            // Preload the ComboBox popup
            projectTypeComboBox.popup.visible = true
            projectTypeComboBox.popup.visible = false
        }

        Column {
            id: projectDetailsColumn

            anchors {
                centerIn: parent
                fill: parent
                margins: 50
            }
            spacing: 20
        
            // color: "red"
            property real textFieldWidth: 600
            

            // PROJECT NAME
            Row {
                spacing: 10
                Label {
                    text: qsTr("Project Name")

                    anchors.verticalCenter: projectNameTextField.verticalCenter

                    width: 150
                }
                VFTextField {
                    id: projectNameTextField
                    placeholderText: qsTr("Enter a project name")
                    width: projectDetailsColumn.textFieldWidth
                }
            }

            // PROJECT PATH
            Row {
                spacing: 10
                Label {
                    text: qsTr("Project Path")

                    anchors.verticalCenter: projectPathTextField.verticalCenter

                    width: 150
                }
                VFTextField {
                    id: projectPathTextField
                    placeholderText: qsTr("Enter directory to place your project")
                    width: projectDetailsColumn.textFieldWidth
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
                    width: 50
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
                Label {
                    id: projectTypeLabel

                    text: qsTr("Project Type")
                    anchors.verticalCenter: projectTypeComboBox.verticalCenter
                    width: 150
                }
                VFComboBox {
                    id: projectTypeComboBox
                    width: 200
                    height: projectTypeLabel.height + 20
                    // focusPolicy: Qt.NoFocus
                    model: backend !== null ? backend.projectTypes : []
                }
            }

            ToolSeparator {
                orientation: Qt.Horizontal
                width: parent.width - parent.anchors.margins/2
            }

            // ASSET SECTION
            Row {
                id: assetSectionRow
                width: parent.width
                Column {
                    id: assetSectionColumn
                    width: parent.width
                    
                    // ADD OR DELETE ASSET BUTTONS
                    Row {
                        spacing: 0

                        bottomPadding: 20
                        
                        property int sectionHeight: 25

                        Label {
                            width: 200
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
                            
                            font.pointSize: root.font.pointSize - 3
                            
                            rightInset: -2
                            

                            validator: IntValidator {bottom: 0; top: 99;}
                            text: "1"

                            Component.onCompleted: {
                                assetListView.model.add();
                            }

                            onTextEdited: {
                                assetListView.model.clear()
                                for(var i=0; i < Number(text); i++){
                                    assetListView.model.add();
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                acceptedButtons: Qt.NoButton
                                cursorShape: Qt.IBeamCursor
                                onWheel: (wheel) => {
                                    if (wheel.angleDelta.y > 0) {
                                        assetCountTextField.text = Math.min(Number(assetCountTextField.text) + 1, 99).toString();
                                    } else if (wheel.angleDelta.y < 0) {
                                        assetCountTextField.text = Math.max(Number(assetCountTextField.text) - 1, 0).toString();
                                    }
                                    assetCountTextField.textEdited()
                                }
                            }
                        }

                        Button {
                            height: parent.sectionHeight
                            width: height
                            anchors.verticalCenter: assetCountTextField.verticalCenter
                            rightInset: -1
                            

                            text: "+"

                            onClicked: {
                                assetListView.model.add()
                                assetCountTextField.text = String(Number(assetCountTextField.text) + 1)
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
                                    assetCountTextField.text = String(Number(assetCountTextField.text) - 1)
                                }
                            } 
                        }

                        Button {
                            height: parent.sectionHeight
                            width: 75
                            anchors.verticalCenter: assetCountTextField.verticalCenter

                            text: qsTr("Clear")

                            onClicked: {
                                assetListView.model.clear()
                                assetCountTextField.text = 0
                            }
                        }
                    }

                    // DISPLAY ASSETS
                    Row {
                        ScrollView {
                            width: assetSectionColumn.width
                            // anchors.fill: parent
                            height: root.height - root.height/2
                            clip: true
                            
                            ListView {
                                id: assetListView
                                model: assetListModel
                                spacing: 20

                                delegate: Column {
                                    spacing: 10
                                   
                                    // ASSET TYPE
                                    Row {
                                        spacing: 10

                                        Label {
                                            id: assetTypeLabel

                                            anchors.verticalCenter: assetTypeComboBox.verticalCenter

                                            width: 140

                                            text: qsTr("Asset Type")
                                        }

                                        VFComboBox {
                                            id: assetTypeComboBox

                                            width: 200
                                            height: assetTypeLabel.height + 10

                                            model: backend !== null ? backend.assetTypes : []
                                            onCurrentTextChanged: {
                                                // Set the roles defined in AssetListModel
                                                name = assetNameTextField.text
                                                type = currentText
                                                subtypes.clear()
                                            }
                                        }
                                    }

                                    // ASSET NAME
                                    Row {
                                        spacing: 10

                                        Label {
                                            width: 140

                                            anchors.verticalCenter: assetNameTextField.verticalCenter

                                            text: qsTr("Asset Name")
                                        }

                                        VFTextField {
                                            id: assetNameTextField
                                            
                                            width: 200

                                            placeholderText: qsTr("Enter asset name")
                                            validator: RegularExpressionValidator { regularExpression: /[a-zA-Z]*/}
                                            onEditingFinished: {
                                                // Set the roles defined in AssetListModel
                                                name = text
                                                type = assetTypeComboBox.currentText
                                            }
                                        }
                                    }

                                    Row {
                                        Button {
                                            text: qsTr("Edit Subtypes and Variants")                                       

                                            onClicked: {
                                                // subtypesEditorWindow.visible = true
                                                
                                                subtypesEditorLoader.active = true
                                                
                                            }
                                        }                                        
                                    }

                                    //Loader to display subtypes and variants window for a particular asset
                                    Loader { 
                                        id: subtypesEditorLoader
                                        active: false

                                        sourceComponent: SubtypesEditorWindow {
                                            id: subtypesEditorWindow
                                            visible: true

                                            x: root.x + root.width / 2 - width / 2
                                            y: root.y + root.height / 2 - height / 2

                                            currentAssetName: name
                                            currentAssetType: type

                                            subtypesModel: subtypes

                                            onClosing: {
                                                subtypesEditorLoader.active = false
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
                            backend.createProject(projectPathTextField.text, projectNameTextField.text, projectTypeComboBox.currentText, assetListView.model.items);
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