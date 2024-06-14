from typing import List

import PyQt6.QtCore as qtc


class QAssetVariant(qtc.QObject):
    def __init__(self):
        super().__init__()
        self._name = ""

    def __str__(self) -> str:
        return self._name

    @qtc.pyqtProperty(str)
    def name(self) -> str:
        return self._name
    
    @name.setter
    def name(self, value: str):
        self._name = value


class QAssetVariantListModel(qtc.QAbstractListModel):
    NameRole = qtc.Qt.ItemDataRole.UserRole + 1

    def __init__(self):
        super().__init__()
        self._variants = []

    def rowCount(self, parent=qtc.QModelIndex()):
        return len(self._variants)

    def data(self, index, role=qtc.Qt.ItemDataRole.DisplayRole):
        if not index.isValid():
            return None

        variant: QAssetVariant = self._variants[index.row()]
        
        if role == QAssetSubtypeListModel.NameRole:
            return variant.name
           
        
    def setData(self, index, value, role=qtc.Qt.ItemDataRole.EditRole):
        if not index.isValid():
            return None
        
        variant: QAssetVariant = self._variants[index.row()]
        
        if role == QAssetSubtypeListModel.NameRole:
            variant.name = value   
           
        else:
            return False

        self.dataChanged.emit(index, index, [role])
        return True

    def roleNames(self):
        return {
            QAssetVariantListModel.NameRole: b'name',
        }
    
    @qtc.pyqtProperty(int)
    def count(self) -> int:
        return self.rowCount()
    
    @qtc.pyqtProperty(list)
    def items(self) -> List[QAssetVariant]:
        return self._variants

    @qtc.pyqtSlot()
    def add(self):
        self.beginInsertRows(qtc.QModelIndex(), self.rowCount(), self.rowCount())

        self._variants.append(QAssetVariant())
        
        self.endInsertRows()

    @qtc.pyqtSlot()
    def pop(self):
        if self.rowCount() > 0:
            self.beginRemoveRows(qtc.QModelIndex(), self.rowCount() - 1, self.rowCount() - 1)

            self._variants.pop()

            self.endRemoveRows()

    @qtc.pyqtSlot()
    def clear(self):
        self.beginRemoveRows(qtc.QModelIndex(), 0, self.rowCount() - 1)

        self._variants.clear()

        self.endRemoveRows()


class QAssetSubtype(qtc.QObject):
    def __init__(self, name: str=""):
        super().__init__()
        self._name = name
        self._variants = QAssetVariantListModel()

    def __repr__(self) -> str:
        return f"QAssetSubtype(name={self._name}, subtypes=QAssetVariantListModel)"

    @qtc.pyqtProperty(str)
    def name(self) -> str:
        return self._name
    
    @name.setter
    def name(self, value: str):
        self._name = value
    
    @qtc.pyqtProperty(str)
    def variants(self) -> str:
        return self._variants
    
    @variants.setter
    def variants(self, value: str):
        self._variants = value


class QAssetSubtypeListModel(qtc.QAbstractListModel):
    NameRole = qtc.Qt.ItemDataRole.UserRole + 1
    VariantsRole = qtc.Qt.ItemDataRole.UserRole + 2

    def __init__(self):
        super().__init__()
        self._subtypes = []

    def __len__(self) -> int:
        return len(self._subtypes)

    def rowCount(self, parent=qtc.QModelIndex()):
        return len(self._subtypes)

    def data(self, index, role=qtc.Qt.ItemDataRole.DisplayRole):
        if not index.isValid():
            return None

        subtype: QAssetSubtype = self._subtypes[index.row()]
        
        if role == QAssetSubtypeListModel.NameRole:
            return subtype.name

        elif role == QAssetSubtypeListModel.VariantsRole:
            return subtype.variants
           
        
    def setData(self, index, value, role=qtc.Qt.ItemDataRole.EditRole):
        if not index.isValid():
            return None
        
        subtype: QAssetSubtype = self._subtypes[index.row()]
        
        if role == QAssetSubtypeListModel.NameRole:
            subtype.name = value

        elif role == QAssetSubtypeListModel.VariantsRole:
            subtype.variants = value     
           
        else:
            return False

        self.dataChanged.emit(index, index, [role])
        return True

    def roleNames(self):
        return {
            QAssetSubtypeListModel.NameRole: b'name',
            QAssetSubtypeListModel.VariantsRole: b'variants',
        }
    
    @qtc.pyqtProperty(int)
    def count(self) -> int:
        return self.rowCount()
    
    @qtc.pyqtProperty(list)
    def items(self) -> List[QAssetSubtype]:
        return self._subtypes

    @qtc.pyqtSlot()
    def add(self):
        self.beginInsertRows(qtc.QModelIndex(), self.rowCount(), self.rowCount())

        self._subtypes.append(QAssetSubtype())
        
        self.endInsertRows()

    @qtc.pyqtSlot()
    def pop(self):
        if self.rowCount() > 0:
            self.beginRemoveRows(qtc.QModelIndex(), self.rowCount() - 1, self.rowCount() - 1)

            self._subtypes.pop()

            self.endRemoveRows()

    @qtc.pyqtSlot()
    def clear(self):
        self.beginRemoveRows(qtc.QModelIndex(), 0, self.rowCount() - 1)

        self._subtypes.clear()

        self.endRemoveRows()


class QAsset(qtc.QObject):
    def __init__(self):
        super().__init__()
        self._name = ""
        self._type = ""
        self._subtypes = QAssetSubtypeListModel()

    def __repr__(self) -> str:
        return f"QAsset(name={self._name}, type={self._type}, subtypes=QAssetSubtypeListModel)"

    @qtc.pyqtProperty(str)
    def name(self) -> str:
        return self._name
    
    @name.setter
    def name(self, value: str):
        self._name = value
    
    @qtc.pyqtProperty(str)
    def type(self) -> str:
        return self._type
    
    @type.setter
    def type(self, value: str):
        self._type = value

    @qtc.pyqtProperty(list)
    def subtypes(self) -> list:
        return self._subtypes
    
    @subtypes.setter
    def subtypes(self, value: list):
        self._subtypes = value
    

class QAssetListModel(qtc.QAbstractListModel):
    NameRole = qtc.Qt.ItemDataRole.UserRole + 1
    TypeRole = qtc.Qt.ItemDataRole.UserRole + 2
    SubtypesRole = qtc.Qt.ItemDataRole.UserRole + 3

    def __init__(self):
        super().__init__()
        self._assets = []

    def rowCount(self, parent=qtc.QModelIndex()):
        return len(self._assets)

    def data(self, index, role=qtc.Qt.ItemDataRole.DisplayRole):
        if not index.isValid():
            return None

        asset: QAsset = self._assets[index.row()]
        
        if role == QAssetListModel.NameRole:
            return asset.name

        elif role == QAssetListModel.TypeRole:
            return asset.type

        elif role == QAssetListModel.SubtypesRole:
            return asset.subtypes
           
        
    def setData(self, index, value, role=qtc.Qt.ItemDataRole.EditRole):
        if not index.isValid():
            return None
        
        asset: QAsset = self._assets[index.row()]
        
        if role == QAssetListModel.NameRole:
            asset.name = value

        elif role == QAssetListModel.TypeRole:
            asset.type = value

        elif role == QAssetListModel.SubtypesRole:
            asset.subtypes = value
            
           
        else:
            return False

        self.dataChanged.emit(index, index, [role])
        return True

    def roleNames(self):
        return {
            QAssetListModel.NameRole: b'name',
            QAssetListModel.TypeRole: b'type',
            QAssetListModel.SubtypesRole: b'subtypes',
        }
    
    @qtc.pyqtProperty(int)
    def count(self) -> int:
        return self.rowCount()
    
    @qtc.pyqtProperty(bool)
    def isValid(self) -> bool:
        for asset in self._assets:
            if not asset.name.strip():
                return False
        return True
    
    @qtc.pyqtProperty(list)
    def items(self) -> List[QAsset]:
        return self._assets
    
    @qtc.pyqtProperty(list)
    def toDictList(self) -> List[dict]:
        return [asset.__dict__ for asset in self._assets]

    @qtc.pyqtSlot()
    def add(self):
        self.beginInsertRows(qtc.QModelIndex(), self.rowCount(), self.rowCount())

        self._assets.append(QAsset())
        
        self.endInsertRows()

    @qtc.pyqtSlot()
    def pop(self):
        if self.rowCount() > 0:
            self.beginRemoveRows(qtc.QModelIndex(), self.rowCount() - 1, self.rowCount() - 1)

            self._assets.pop()

            self.endRemoveRows()

    @qtc.pyqtSlot()
    def clear(self):
        self.beginRemoveRows(qtc.QModelIndex(), 0, self.rowCount() - 1)

        self._assets.clear()

        self.endRemoveRows()