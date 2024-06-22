from typing import List

import PyQt6.QtCore as qtc

class QSequence(qtc.QObject):
    def __init__(self):
        super().__init__()
        self._name = ""
        self._shots = 0

    def __repr__(self) -> str:
        return f"QSequence(name={self._name}, shots={self._shots})"

    @qtc.pyqtProperty(str)
    def name(self) -> str:
        return self._name
    
    @name.setter
    def name(self, value: str):
        self._name = value
    
    @qtc.pyqtProperty(int)
    def shots(self) -> int:
        return self._shots
    
    @shots.setter
    def shots(self, value: int):
        self._shots = int(value)
    

class QSequenceListModel(qtc.QAbstractListModel):
    NameRole = qtc.Qt.ItemDataRole.UserRole + 1
    ShotsRole = qtc.Qt.ItemDataRole.UserRole + 2

    def __init__(self):
        super().__init__()
        self._sequences = []

    def rowCount(self, parent=qtc.QModelIndex()):
        return len(self._sequences)

    def data(self, index, role=qtc.Qt.ItemDataRole.DisplayRole):
        if not index.isValid():
            return None

        sequence: QSequence = self._sequences[index.row()]
        
        if role == QSequenceListModel.NameRole:
            return sequence.name

        elif role == QSequenceListModel.ShotsRole:
            return sequence.shots
           
        
    def setData(self, index, value, role=qtc.Qt.ItemDataRole.EditRole):
        if not index.isValid():
            return None
        
        sequence: QSequence = self._sequences[index.row()]
        
        if role == QSequenceListModel.NameRole:
            sequence.name = value

        elif role == QSequenceListModel.ShotsRole:
            sequence.shots = value
            
        else:
            return False

        self.dataChanged.emit(index, index, [role])
        return True

    def roleNames(self):
        return {
            QSequenceListModel.NameRole: b'name',
            QSequenceListModel.ShotsRole: b'shots',
        }
    
    @qtc.pyqtProperty(int)
    def count(self) -> int:
        return self.rowCount()
    
    @qtc.pyqtProperty(bool)
    def isValid(self) -> bool:
        for sequence in self._sequences:
            if not sequence.name.strip():
                return False
        return True
    
    @qtc.pyqtProperty(list)
    def items(self) -> List[QSequence]:
        return self._sequences

    @qtc.pyqtSlot()
    def add(self):
        self.beginInsertRows(qtc.QModelIndex(), self.rowCount(), self.rowCount())

        self._sequences.append(QSequence())
        
        self.endInsertRows()

    @qtc.pyqtSlot()
    def pop(self):
        if self.rowCount() > 0:
            self.beginRemoveRows(qtc.QModelIndex(), self.rowCount() - 1, self.rowCount() - 1)

            self._sequences.pop()

            self.endRemoveRows()

    @qtc.pyqtSlot()
    def clear(self):
        self.beginRemoveRows(qtc.QModelIndex(), 0, self.rowCount() - 1)

        self._sequences.clear()

        self.endRemoveRows()