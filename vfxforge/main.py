from PyQt6 import QtCore as qtc
from PyQt6 import QtGui as qtg
from PyQt6 import QtQml as qml
import sys
import os
os.chdir(os.path.dirname(os.path.abspath(__file__)))

from core.project_builder import ProjectBuilder
from core.settings import Settings, JSONSettingsSource




class Backend(qtc.QObject):
    def __init__(self):
        super().__init__()
        self.project_builder = None
        self.settings = Settings(source=JSONSettingsSource(json_file="database/settings.json"))

    @qtc.pyqtProperty('QStringList', constant=True)
    def projectTypes(self):
        return self.settings.get_project_types()

    @qtc.pyqtSlot(str, str, str)
    def createProject(self, project_path, project_name, project_type):
        print(f"Creating project at {project_path} with name {project_name} and type {project_type}")

        if not self.project_builder:
            self.project_builder = ProjectBuilder(name=project_name, path=project_path, project_type=project_type)

        base_dirs = self.settings.get_project_base_dirs(project_type=self.project_builder.project_type)

        self.project_builder.build_project(base_dirs=base_dirs)

        print(f"Project '{project_name}' created successfully at {self.project_builder.path}.")

        
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
