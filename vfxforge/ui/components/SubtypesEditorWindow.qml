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

    // property var assetsModel

    property var subtypesModel

    title: qsTr("Edit subtypes and variants")

    flags: Qt.Dialog

    modality: Qt.WindowModal

    Item {
        id: subtypesEditorWindowSection
        height: parent.height
        width: parent.width

        Column {
            spacing: 20
            // anchors.centerIn: parent
            padding: 20

            Row {
                Button {
                    // width: 200
                    text: qsTr("Add Subtype")
                    onClicked: {
                        subtypesListView.model.add()
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
                                
                                TextField {
                                    id: subtypeNameTextField
                                    placeholderText: qsTr("Enter subtype name")

                                    text: name

                                    onTextEdited: {
                                        // subtypesListView.model.setProperty(index, "name", text);
                                        name = text
                                    }
                                }

                                Button {
                                    id: addVariantButton
                                    text: qsTr("+")
                                    width: height
                                    height: subtypeNameTextField.height + 2
                                    anchors.verticalCenter: subtypeNameTextField.verticalCenter

                                    onClicked: {
                                        variantListView.model.add()
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
                                            
                                            TextField {
                                                id: subtypeNameTextField
                                                placeholderText: qsTr("Enter Variant name")

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
                        // subtypesEditorWindow.subtypesModel = subtypesListView.model

                        // console.log(subtypesListView.model)

                        // var subtypes = subtypesListView.model.subtypes
                        // for(var i=0; i<subtypesListView.model.count; i++){
                        //     var subtype = subtypes[i]
                        //     console.log(subtype.name)
                        // }

                        // var subtypes = subtypesEditorWindow.subtypesModel.subtypes
                        // for(var i=0; i<subtypesListView.model.count; i++){
                        //     var subtype = subtypes[i]
                        //     console.log(subtype.name)
                        // }

                        subtypesEditorWindow.close()
                    }
                }
            }
        }
    }
}