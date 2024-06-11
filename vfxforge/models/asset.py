from typing import List
import json

import PyQt6.QtCore as qtc


class Variant:
    def __init__(self, name: str):
        self.name = name

    def __str__(self):
        return f"{self.name}"
    

class AssetSubtype:
    def __init__(self, name: str, variants: List[Variant]=[]):
        self.name = name
        self.variants = variants

    def __str__(self):
        return f"{self.name}"
    

class Asset:
    def __init__(self, name: str, asset_type: str, subtypes: List[AssetSubtype]=[]):
        self.name = name
        self.type = asset_type
        self.subtypes = subtypes

    def __str__(self):
        return f"Name: {self.name}, Type: {self.type}"
    

class AssetListModel(qtc.QAbstractListModel):
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

        asset: Asset = self._assets[index.row()]
        
        if role == AssetListModel.NameRole:
            return asset.name

        elif role == AssetListModel.TypeRole:
            return asset.type

        elif role == AssetListModel.SubtypesRole:
            return asset.subtypes
           
        
    def setData(self, index, value, role=qtc.Qt.ItemDataRole.EditRole):
        if not index.isValid():
            return None
        
        asset: Asset = self._assets[index.row()]
        
        if role == AssetListModel.NameRole:
            asset.name = value

        elif role == AssetListModel.TypeRole:
            asset.type = value

        elif role == AssetListModel.SubtypesRole:
            asset.subtypes = [AssetSubtype(name=subtype_dict["name"], variants=subtype_dict["variants"]) for subtype_dict in value.toVariant()]
            
           
        else:
            return False

        self.dataChanged.emit(index, index, [role])
        return True

    def roleNames(self):
        return {
            AssetListModel.NameRole: b'name',
            AssetListModel.TypeRole: b'type',
            AssetListModel.SubtypesRole: b'subtypes',
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

    @qtc.pyqtSlot(str, str)
    def add(self, name: str, asset_type: str, subtypes: List[AssetSubtype]=[]):
        self.beginInsertRows(qtc.QModelIndex(), self.rowCount(), self.rowCount())

        self._assets.append(Asset(name, asset_type))
        
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

    @qtc.pyqtProperty(list)
    def assets(self) -> List[Asset]:
        return self._assets
    
    @qtc.pyqtProperty(list)
    def toDictList(self) -> List[dict]:
        return [asset.__dict__ for asset in self._assets]