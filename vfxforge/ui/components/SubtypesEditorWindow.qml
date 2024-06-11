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

    property var assetsModel

    property var subtypes: []

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
                        subtypesListView.model.append({"name": "", "variants": []})
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
                        
                        model: ListModel {
                            Component.onCompleted: {
                                let subtypes = [
                                    {
                                        name: "",
                                        variants: [
                                            {
                                                name: "",
                                            }
                                        ]
                                    }
                                ]
                                append(subtypes)
                            }
                        }

                        spacing: 20

                        delegate: Column {
                            Row {
                                
                                TextField {
                                    id: subtypeNameTextField
                                    placeholderText: qsTr("Enter subtype name")

                                    onTextEdited: {
                                        subtypesListView.model.setProperty(index, "name", text);
                                    }
                                }

                                Button {
                                    id: addVariantButton
                                    text: qsTr("+")
                                    width: height
                                    height: subtypeNameTextField.height + 2
                                    anchors.verticalCenter: subtypeNameTextField.verticalCenter

                                    onClicked: {
                                        variantListView.model.append({"name": ""})
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

                                                onTextEdited: {
                                                    variantListView.model.setProperty(index, "name", text);
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
                        var subtypes = []
                        for(var i=0; i<subtypesListView.model.count; i++){
                            var subtype = subtypesListView.model.get(i)

                            var variants = []
                            for(var j=0; j<subtype["variants"].count; j++){
                                variants.push(subtype["variants"].get(j)["name"])
                            }
                            
                            subtypes.push({"name": subtype["name"], "variants": variants})
                        }

                        subtypesEditorWindow.subtypes = subtypes

                        subtypesEditorWindow.close()
                    }
                }
            }
        }
    }
}