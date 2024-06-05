from typing import List

import PyQt6.QtCore as qtc


class Asset:
    def __init__(self, name: str, asset_type: str):
        self.name = name
        self.type = asset_type

    def __str__(self):
        return f"Name: {self.name}, Type: {self.type}"
    

class AssetListModel(qtc.QAbstractListModel):
    NameRole = qtc.Qt.ItemDataRole.UserRole + 1
    TypeRole = qtc.Qt.ItemDataRole.UserRole + 2

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
            # return asset['name']

        elif role == AssetListModel.TypeRole:
            return asset.type
            # return asset['type']
        
    def setData(self, index, value, role=qtc.Qt.ItemDataRole.EditRole):
        if not index.isValid():
            return None
        
        asset: Asset = self._assets[index.row()]
        
        if role == AssetListModel.NameRole:
            asset.name = value
            # asset['name'] = value
        elif role == AssetListModel.TypeRole:
            asset.type = value
            # asset['type'] = value
        else:
            return False

        self.dataChanged.emit(index, index, [role])
        return True

    def roleNames(self):
        return {
            AssetListModel.NameRole: b'name',
            AssetListModel.TypeRole: b'type',
        }
    
    @qtc.pyqtProperty(int)
    def count(self) -> int:
        return self.rowCount()

    @qtc.pyqtSlot(str, str)
    def add(self, name: str, asset_type: str):
        self.beginInsertRows(qtc.QModelIndex(), self.rowCount(), self.rowCount())

        # self._assets.append({"name": name, "type": asset_type})
        self._assets.append(Asset(name, asset_type))
        
        self.endInsertRows()

    @qtc.pyqtSlot()
    def pop(self):
        if self.rowCount() > 0:
            self.beginRemoveRows(qtc.QModelIndex(), self.rowCount() - 1, self.rowCount() - 1)

            self._assets.pop()

            self.endRemoveRows()

    @qtc.pyqtProperty(list)
    def assets(self) -> List[Asset]:
        return self._assets