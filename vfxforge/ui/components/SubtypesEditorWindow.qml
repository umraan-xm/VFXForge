import QtQuick 
import QtQuick.Window 
import QtQuick.Controls 
import QtQuick.Layouts 
import QtQuick.Dialogs
import QtQml.Models 

Window {
    id: subtypesEditorWindow
    width: 500
    height: 300
    minimumWidth: 400
    minimumHeight: 200

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
                    height: subtypesEditorWindow.height - 100
                    clip: true
                    
                    ListView {
                        id: subtypesListView
                        
                        model: ListModel {}

                        spacing: 20

                        delegate: Column {
                            Row {
                                
                                TextField {
                                    id: subtypeNameTextField
                                    placeholderText: qsTr("Enter subtype name")
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

                                    model: ListModel {}

                                    spacing: 2

                                    delegate: Column {
                                        Row {
                                            
                                            TextField {
                                                id: subtypeNameTextField
                                                placeholderText: qsTr("Enter Variant name")
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