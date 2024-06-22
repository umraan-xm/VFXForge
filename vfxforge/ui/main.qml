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

    readonly property int margin: 15

    minimumWidth: mainLayout.Layout.minimumWidth + 2 * margin
    minimumHeight: mainLayout.Layout.minimumHeight + 2 * margin

    title: 'VFXForge'

    font.pointSize: 12
    font.family: "Calibri"

    MouseArea {
        anchors.fill: parent
        onClicked: forceActiveFocus()
    }

    ColumnLayout {
        id: mainLayout

        anchors.fill: parent // If the size of the Layout is not set it will not reposition or resize elements. Do not set this if the parent is also a layout and has this property.
        anchors.margins: root.margin
        
        Rectangle {
            Layout.fillWidth: true // Resize the Rectangle given the below constraints.

            /*
                Layouts calculate implicit minimum and maximum from their child items.
                Every other item has an implicit minimum of 0 and implicit maximum of  Infinity
            */
            Layout.minimumHeight: projectDetailsColumnLayout.Layout.minimumHeight + 60 //constraints simply stop resizing but the window may still crop out the element.
            Layout.minimumWidth: projectDetailsColumnLayout.Layout.minimumWidth

            Component.onCompleted: {
                // Preload the ComboBox popup
                projectTypeComboBox.popup.visible = true
                projectTypeComboBox.popup.visible = false
            }    

            // color: Qt.rgba(1, 0, 0, 0.2)

            ColumnLayout {
                id: projectDetailsColumnLayout

                anchors.fill: parent
                anchors.right: undefined

                readonly property int labelWidth: 100
                readonly property int textFieldWidth: 500
                readonly property int rowSpacing: 20

                spacing: 15

                RowLayout {
                    id: projectNameRowLayout
                    
                    spacing: projectDetailsColumnLayout.rowSpacing

                    Label {
                        /*
                            If the Layout can resize (eg: Layout.fillWidth: true), then this property acts as a ratio while resizing

                            If two elements have this value set, then while resizing the Layout will try to keep the ratio of the two values
                            until it exceeds its minimum and maximum constraints.

                            While resizing if the size of the componenet goes below this value then the ratio will no longer be maintained. The size will go down to its minimum constraint
                        */
                        Layout.preferredWidth: projectDetailsColumnLayout.labelWidth // Since fillWidth is not set, this property just determines the width of the element

                        verticalAlignment: Text.AlignVCenter

                        text: qsTr("Project Name")
                    }

                    VFTextField {
                        id: projectNameTextField

                        Layout.fillWidth: true

                        placeholderText: qsTr("Enter a project name")
                        
                    }
                }

                RowLayout {
                    id: projectPathRowLayout
                    
                    spacing: projectDetailsColumnLayout.rowSpacing

                    Label {
                        Layout.preferredWidth: projectDetailsColumnLayout.labelWidth

                        verticalAlignment: Text.AlignVCenter

                        text: qsTr("Project Path")
                    }

                    VFTextField {
                        id: projectPathTextField

                        Layout.fillWidth: true

                        placeholderText: qsTr("Enter directory to place your project")
                       
                    }
                    
                    FolderDialog {
                        id: projectPathFolderDialog

                        title: qsTr("Select Project Path")

                        onAccepted: {
                            projectPathTextField.text = String(selectedFolder).replace("file:///", "");
                        }
                    }

                    VFButton {
                        Layout.preferredWidth: 50

                        text: "..."

                        onClicked: {
                            projectPathFolderDialog.open()
                        }
                    }
                }

                RowLayout {

                    spacing: projectDetailsColumnLayout.rowSpacing

                    Label {
                        Layout.preferredWidth: projectDetailsColumnLayout.labelWidth

                        verticalAlignment: Text.AlignVCenter

                        text: qsTr("Project Type")
                    }
                    VFComboBox {
                        id: projectTypeComboBox

                        Layout.preferredWidth: 200
                        Layout.preferredHeight: 35
                        
                        model: backend !== null ? backend.projectTypes : []
                    }
                }
            }
        }

        ToolSeparator {
                orientation: Qt.Horizontal
                
                Layout.fillWidth: true
            }

        TabBar {
            id: mainTabBar

            Layout.fillWidth: true

            VFTabButton {
                

                text: qsTr("Assets")
            }

            VFTabButton {
                

                text: qsTr("Sequences")
            }
        }

        StackLayout {
            Layout.minimumWidth: assetsColumnLayout.implicitWidth + 20
            Layout.margins: 10

            currentIndex: mainTabBar.currentIndex

            // StackLayout sets Layout.fillWidth and fillHeight as defaults to its child items
            Rectangle {
                
                ColumnLayout {
                    id: assetsColumnLayout
                    anchors.fill: parent
                    anchors.right: undefined

                    RowLayout {
                        id: assetCountRowLayout

                        readonly property int buttonHeight: 25

                        spacing: 5

                        Label {
                            id: assetCountLabel

                            Layout.rightMargin: 40
                            
                            verticalAlignment: Text.AlignVCenter

                            text: qsTr("Number of Assets")
                        }

                        RowLayout {
                            spacing: 0

                            VFIntTextField {
                                id: assetCountTextField

                                Layout.preferredWidth: 40
                                Layout.preferredHeight: assetCountRowLayout.buttonHeight                        
                                
                                font.pointSize: root.font.pointSize - 2
                                
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
                            }

                            // Add an Asset
                            VFButton {  
                                Layout.preferredHeight: assetCountRowLayout.buttonHeight  
                                Layout.preferredWidth: Layout.preferredHeight

                                radius: 0
                                borderWidth: 1 

                                text: "+"

                                onClicked: {
                                    assetListView.model.add()
                                    assetCountTextField.text = String(Number(assetCountTextField.text) + 1)
                                }
                            }

                            // Remove an Asset
                            VFButton {
                                Layout.preferredHeight: assetCountRowLayout.buttonHeight  
                                Layout.preferredWidth: Layout.preferredHeight

                                radius: 0
                                borderWidth: 1  

                                text: "-"

                                onClicked: {
                                    if(assetListView.model.count > 0){
                                        assetListView.model.pop()
                                        assetCountTextField.text = String(Number(assetCountTextField.text) - 1)
                                    }
                                } 
                            }
                        }

                        // Clear Assets
                        VFButton {
                            Layout.preferredHeight: assetCountRowLayout.buttonHeight 

                            Layout.fillWidth: true
                            Layout.maximumWidth: implicitWidth * 2
                            
                            radius: 0
                            borderWidth: 1 

                            text: qsTr("Clear")

                            onClicked: {
                                assetListView.model.clear()
                                assetCountTextField.text = 0
                            }
                        }
                    }

                    RowLayout {

                        Layout.margins: 20

                        ScrollView {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            clip: true

                            // ScrollBar.vertical.interactive: true

                            ListView {
                                id: assetListView
                                model: assetListModel
                        
                                delegate: Rectangle {
                                   
                                    height: 150
                                    width: contentItem.width
                                    

                                    ColumnLayout {
                                        id: assetDelegateColumnLayout
                                        anchors.fill: parent

                                        readonly property int labelWidth: 100
                                        
                                        spacing: 5

                                        RowLayout {

                                            Label {
                                                Layout.preferredWidth: assetDelegateColumnLayout.labelWidth

                                                Layout.rightMargin: 40

                                                verticalAlignment: Text.AlignVCenter

                                                text: qsTr("Asset Type")
                                            }

                                            VFComboBox {
                                                id: assetTypeComboBox

                                                Layout.fillWidth: true
                                                Layout.maximumWidth: 200

                                                Layout.preferredHeight: 35                                                                                            

                                                model: backend !== null ? backend.assetTypes : []
                                                onCurrentTextChanged: {
                                                    // Set the roles defined in QAssetListModel
                                                    name = assetNameTextField.text
                                                    type = currentText
                                                    subtypes.clear()
                                                }
                                            }
                                        }

                                        RowLayout {
                                            
                                            Label {
                                                Layout.preferredWidth: assetDelegateColumnLayout.labelWidth

                                                Layout.rightMargin: 40

                                                verticalAlignment: Text.AlignVCenter

                                                text: qsTr("Asset Name")
                                            }

                                            VFTextField {
                                                id: assetNameTextField
                                                
                                                Layout.fillWidth: true
                                                Layout.maximumWidth: 300

                                                placeholderText: qsTr("Enter asset name")
                                                validator: RegularExpressionValidator { regularExpression: /[a-zA-Z]*/}
                                                onEditingFinished: {
                                                    // Set the roles defined in QAssetListModel
                                                    name = text
                                                    type = assetTypeComboBox.currentText
                                                }
                                            }
                                        }

                                        RowLayout {
                                            Layout.bottomMargin: 30
                                            VFButton {
                                                text: qsTr("Edit Subtypes and Variants")                                       

                                                onClicked: {                                         
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

                                                //Pass current asset name and type via the roles of QAssetListModel
                                                currentAssetName: name
                                                currentAssetType: type

                                                //subtypes is also a role in QAssetListModel of type QAssetSubtypeListModel.
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
            }

            Rectangle {

                ColumnLayout {
                    id: sequencesColumnLayout
                    anchors.fill: parent
                    anchors.right: undefined

                    RowLayout {
                        id: sequenceCountRowLayout

                        readonly property int buttonHeight: 25

                        spacing: 5

                        Label {
                            Layout.rightMargin: 40
                            
                            verticalAlignment: Text.AlignVCenter

                            text: qsTr("Number of Sequences")
                        }

                        RowLayout {
                            spacing: 0

                            VFIntTextField {
                                id: sequenceCountTextField

                                Layout.preferredWidth: 40
                                Layout.preferredHeight: sequenceCountRowLayout.buttonHeight                        
                                
                                font.pointSize: root.font.pointSize - 2
                                
                                text: "1"

                                Component.onCompleted: {
                                    sequenceListView.model.add();
                                }

                                onTextEdited: {
                                    sequenceListView.model.clear()
                                    for(var i=0; i < Number(text); i++){
                                        sequenceListView.model.add();
                                    }
                                }
                            }

                            // Add a Sequence
                            VFButton {  
                                Layout.preferredHeight: sequenceCountRowLayout.buttonHeight  
                                Layout.preferredWidth: Layout.preferredHeight

                                radius: 0
                                borderWidth: 1 

                                text: "+"

                                onClicked: {
                                    sequenceListView.model.add()
                                    sequenceCountTextField.text = String(Number(sequenceCountTextField.text) + 1)
                                }
                            }

                            // Remove a Sequence
                            VFButton {
                                Layout.preferredHeight: sequenceCountRowLayout.buttonHeight  
                                Layout.preferredWidth: Layout.preferredHeight

                                radius: 0
                                borderWidth: 1  

                                text: "-"

                                onClicked: {
                                    if(sequenceListView.model.count > 0){
                                        sequenceListView.model.pop()
                                        sequenceCountTextField.text = String(Number(sequenceCountTextField.text) - 1)
                                    }
                                } 
                            }
                        }

                        // Clear Sequences
                        VFButton {
                            Layout.preferredHeight: sequenceCountRowLayout.buttonHeight 

                            Layout.fillWidth: true
                            Layout.maximumWidth: implicitWidth * 2
                            
                            radius: 0
                            borderWidth: 1 

                            text: qsTr("Clear")

                            onClicked: {
                                sequenceListView.model.clear()
                                sequenceCountTextField.text = 0
                            }
                        }
                    }

                    RowLayout {

                        Layout.margins: 20

                        ScrollView {
                            Layout.fillHeight: true
                            Layout.fillWidth: true

                            clip: true

                            // ScrollBar.vertical.interactive: true

                            ListView {
                                id: sequenceListView
                                model: sequenceListModel
                        
                                delegate: Rectangle {
                                   
                                    height: 100
                                    width: contentItem.width
                                    
                                    ColumnLayout {
                                        id: sequenceDelegateColumnLayout
                                        anchors.fill: parent

                                        readonly property int labelWidth: 100
                                        
                                        spacing: 5

                                        RowLayout {
                                            
                                            Label {
                                                Layout.preferredWidth: sequenceDelegateColumnLayout.labelWidth

                                                Layout.rightMargin: 40

                                                verticalAlignment: Text.AlignVCenter

                                                text: qsTr("Sequence Name")
                                            }

                                            VFTextField {
                                                id: sequenceNameTextField
                                                
                                                Layout.fillWidth: true
                                                Layout.maximumWidth: 300

                                                placeholderText: qsTr("Enter sequence name")
                                                validator: RegularExpressionValidator { regularExpression: /[a-zA-Z]*/}
                                                onEditingFinished: {
                                                    // Set the roles defined in QAssetListModel
                                                    name = text
                                                    // type = assetTypeComboBox.currentText
                                                }
                                            }
                                        }

                                        RowLayout {

                                            Layout.bottomMargin: 30
                                            
                                            Label {
                                                Layout.preferredWidth: sequenceDelegateColumnLayout.labelWidth

                                                Layout.rightMargin: 40

                                                verticalAlignment: Text.AlignVCenter

                                                text: qsTr("Number of Shots")
                                            }

                                            // SpinBox {
                                            //     id: sequenceShotsSpinBox
                                                
                                            //     Layout.fillWidth: true
                                            //     Layout.maximumWidth: 300

                                            //     editable: true
                                            //     from: 1
                                            //     live: true

                                            //     contentItem: TextInput {
                                            //         text: sequenceShotsSpinBox.textFromValue(sequenceShotsSpinBox.value, sequenceShotsSpinBox.locale)
                                            //         font: sequenceShotsSpinBox.font
                                            //         horizontalAlignment: Qt.AlignHCenter
                                            //         verticalAlignment: Qt.AlignVCenter
                                            //         readOnly: !sequenceShotsSpinBox.editable
                                            //         validator: sequenceShotsSpinBox.validator
                                            //         inputMethodHints: Qt.ImhFormattedNumbersOnly
                                            //         onTextChanged: {
                                                        
                                            //             sequenceShotsSpinBox.value =  parseInt(text);
                                            //             sequenceShotsSpinBox.valueModified()
                                            //         }
                                            //     }

                                            //     onValueModified: {
                                            //         console.log(value)
                                            //         shots = value
                                            //     }
                                            // }

                                            RowLayout {
                                                id: shotCountRowLayout

                                                readonly property int itemHeight: 35

                                                spacing: 0

                                                VFIntTextField {
                                                    id: shotCountTextField

                                                    Layout.preferredWidth: 80
                                                    Layout.preferredHeight: shotCountRowLayout.itemHeight                        
                                                    
                                                    font.pointSize: root.font.pointSize - 2
                                                    
                                                    text: "1"
                                                    
                                                    onTextEdited: {
                                                        if(Number(text) == 0){
                                                            shotCountTextField.text = "1"
                                                        }
                                                        shots = Number(text)
                                                    }
                                                }

                                                VFButton {  
                                                    Layout.preferredHeight: shotCountRowLayout.itemHeight   
                                                    Layout.preferredWidth: Layout.preferredHeight

                                                    radius: 0
                                                    borderWidth: 1 

                                                    text: "+"

                                                    onClicked: {
                                                        shotCountTextField.text = String(Number(shotCountTextField.text) + 1)
                                                    }
                                                }

                                                VFButton {
                                                    Layout.preferredHeight: shotCountRowLayout.itemHeight     
                                                    Layout.preferredWidth: Layout.preferredHeight

                                                    radius: 0
                                                    borderWidth: 1  

                                                    text: "-"

                                                    onClicked: {
                                                        if(Number(shotCountTextField.text) > 1){
                                                            shotCountTextField.text = String(Number(shotCountTextField.text) - 1)
                                                        }
                                                    } 
                                                }
                                            }
                                        }

                                        

                                        
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        VFButton {
            Layout.preferredWidth: 100

            text: qsTr("Create")
            onClicked: {
                if (projectNameTextField.text === "" || projectPathTextField.text === ""){
                    errorMessageDialog.informativeText = qsTr("Project Name and Path cannot be empty!");
                    errorMessageDialog.open();
                } else if (!assetListView.model.isValid){
                    errorMessageDialog.informativeText = qsTr("Please enter asset names");
                    errorMessageDialog.open();
                } else{
                    backend.createProject(projectPathTextField.text, projectNameTextField.text, projectTypeComboBox.currentText, assetListView.model.items, sequenceListView.model.items);
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