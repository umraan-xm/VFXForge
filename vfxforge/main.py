from PyQt6 import QtCore as qtc
from PyQt6 import QtGui as qtg
from PyQt6 import QtQml as qml
import sys
import os
os.chdir(os.path.dirname(os.path.abspath(__file__)))

from core.project_loader import ProjectStructureLoader, JSONProjectStructureSource


class Backend(qtc.QObject):
    def __init__(self):
        super().__init__()
        self.project_structure_loader = ProjectStructureLoader(JSONProjectStructureSource("database/project_structure.json"))

    @qtc.pyqtProperty('QStringList', constant=True)
    def projectTypes(self):
        return self.project_structure_loader.get_project_types()

    @qtc.pyqtSlot(str, str, str)
    def createProject(self, project_path, project_name, project_type):
        print(f"Creating project at {project_path} with name {project_name} and type {project_type}")

        subdirectories = ["asset", "sequence", "IO", "development", "pipeline", "rnd"]

        full_project_path = os.path.join(project_path, project_name)

        os.makedirs(full_project_path, exist_ok=True)

        for subdir in subdirectories:
            os.makedirs(os.path.join(full_project_path, subdir), exist_ok=True)

        print(f"Project '{project_name}' created successfully at {full_project_path}.")

        
def main():
    app = qtg.QGuiApplication(sys.argv)

    engine = qml.QQmlApplicationEngine()

    backend = Backend()
    engine.rootContext().setContextProperty('backend', backend)

    engine.load(qtc.QUrl.fromLocalFile("ui/main.qml"))

    if not engine.rootObjects():
        return -1

    return app.exec()


if __name__ == '__main__':
    main()
