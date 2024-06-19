import QtQuick 
import QtQuick.Window 
import QtQuick.Controls 
import QtQuick.Layouts 
import QtQuick.Dialogs
import QtQml.Models 

Window {
    id: subtypesEditorWindow
    width: 600
    height: 350
    minimumWidth: 400
    minimumHeight: 200

    property var currentAssetName
    property var currentAssetType

    property var subtypesModel

    title: qsTr("Edit subtypes and variants for %1".arg(currentAssetName == null ? "" : currentAssetName))

    flags: Qt.Dialog

    modality: Qt.WindowModal

    MouseArea {
        anchors.fill: parent
        onClicked: forceActiveFocus()
    }

    // Set default subtypes if no subtypes were already set
    Component.onCompleted: {
        if(subtypesModel.count == 0){
            backend.getDefaultAssetSubtypes(currentAssetType).forEach(function(subtype) {
                subtypesListView.model.add(subtype);
            });
            subtypeCountTextField.text = String(subtypesListView.model.count)
        }
    }

    Item {
        id: subtypesEditorWindowSection
        height: parent.height
        width: parent.width

        Column {
            spacing: 20
            padding: 20

            Row {
                spacing: 3

                bottomPadding: 20
                
                property int sectionHeight: 25

                Label {
                    id: assetSubtypeCountLabel
                    width: 200

                    text: qsTr("Number of Subtypes")
                }
                
                // Container Item to stick children items together
                Item {
                    height: parent.sectionHeight
                    width: childrenRect.width
                    anchors.verticalCenter: assetSubtypeCountLabel.verticalCenter

                    // Integer TextField to manually enter required number of Subtypes
                    VFIntTextField {
                        id: subtypeCountTextField
                        width: 40
                        height: parent.height                         
                        
                        font.pointSize: root.font.pointSize - 3
                        
                        text: "1"

                        // If subtypes are empty, add an empty subtype
                        Component.onCompleted: {
                            if(subtypesListView.model.count == 0){
                                subtypesListView.model.add();
                            }  
                        }

                        onTextEdited: {
                            subtypesListView.model.clear()
                            for(var i=0; i < Number(text); i++){
                                subtypesListView.model.add();
                            }
                        }
                    }

                    // Add a Subtype
                    VFButton {
                        id: plusButton
                        height: parent.height
                        width: height

                        anchors.left: subtypeCountTextField.right

                        radius: 0
                        borderWidth: 1 

                        text: "+"

                        onClicked: {
                            subtypesListView.model.add()
                            subtypeCountTextField.text = String(Number(subtypeCountTextField.text) + 1)
                        }
                    }

                    // Remove a Subtype
                    VFButton {
                        height: parent.height
                        width: height
    
                        anchors.left: plusButton.right

                        radius: 0
                        borderWidth: 1  

                        text: "-"

                        onClicked: {
                            if(subtypesListView.model.count > 0){
                                subtypesListView.model.pop()
                                subtypeCountTextField.text = String(Number(subtypeCountTextField.text) - 1)
                            }
                        } 
                    }
                }

                // Clear Subtypes
                VFButton {
                    height: parent.sectionHeight
                    width: 75
                    anchors.verticalCenter: assetSubtypeCountLabel.verticalCenter
                    
                    radius: 0
                    borderWidth: 1 

                    text: qsTr("Clear")

                    onClicked: {
                        subtypesListView.model.clear()
                        subtypeCountTextField.text = 0
                    }
                }
            }

            Row {
                ScrollView {
                    width: subtypesEditorWindow.width - 55
                    height: subtypesEditorWindow.height - 150
                    clip: true

                    ListView {
                        id: subtypesListView
                        
                        model: subtypesModel

                        spacing: 20

                        delegate: Column {
                            Row {
                                
                                VFTextField {
                                    id: subtypeNameTextField
                                    placeholderText: qsTr("Enter subtype name")

                                    width: 200

                                    text: name

                                    onTextEdited: {
                                        name = text
                                    }
                                }

                                VFButton {
                                    id: addVariantButton
                                    text: "+"
                                    width: height
                                    height: subtypeNameTextField.height
                                    anchors.verticalCenter: subtypeNameTextField.verticalCenter

                                    radius: 0
                                    borderWidth: 1

                                    onClicked: {
                                        variantListView.model.add()
                                    }
                                }

                                VFButton {
                                    id: removeVariantButton
                                    text: "-"
                                    width: height
                                    height: subtypeNameTextField.height
                                    anchors.verticalCenter: subtypeNameTextField.verticalCenter

                                    radius: 0
                                    borderWidth: 1

                                    onClicked: {
                                        variantListView.model.pop()
                                    }
                                }
                            }

                            Row {
                                ListView {
                                    id: variantListView

                                    width: 30
                                    height: contentHeight

                                    leftMargin: 25

                                    model: variants

                                    spacing: 2

                                    delegate: Column {
                                        Row {
                                            
                                            VFTextField {
                                                id: subtypeNameTextField
                                                placeholderText: qsTr("Enter Variant name")

                                                width: 300

                                                text: name

                                                onTextEdited: {
                                                    name = text
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

            Row {
                Button {
                    id: saveSubtypesButton

                    width: 100

                    text: qsTr("Save")

                    onClicked: {
                        subtypesEditorWindow.close()
                    }
                }
            }
        }
    }
}