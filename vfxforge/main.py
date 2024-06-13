import sys
from typing import List

import os
os.chdir(os.path.dirname(os.path.abspath(__file__)))

import logging
logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s", level=logging.DEBUG
)
logger = logging.getLogger(__name__)

from PyQt6 import QtCore as qtc
from PyQt6 import QtGui as qtg
from PyQt6 import QtQml as qml

from core.project_builder import ProjectBuilder
from settings import JSONSettings
import constants

from models.asset import QAssetListModel, QAsset


class Backend(qtc.QObject):
    def __init__(self):
        super().__init__()
        self.project_builder = None
        self.settings = JSONSettings(filepath=constants.JSON_SETTINGS_FILEPATH)

    @qtc.pyqtProperty('QStringList', constant=True)
    def projectTypes(self):
        return self.settings.get_project_types()
    
    @qtc.pyqtProperty('QStringList', constant=True)
    def assetTypes(self):
        return self.settings.get_asset_types()

    @qtc.pyqtSlot(str, str, str, list)
    def createProject(self, project_path: str, project_name: str, project_type: str, assets: List[QAsset]):
        logger.info(f"Creating project at {project_path} with name {project_name} and type {project_type}")

        if not self.project_builder or not self.project_builder.matches(name=project_name, path=project_path):
            self.project_builder = ProjectBuilder(name=project_name, path=project_path, project_type=project_type)

            base_dirs = self.settings.get_project_base_dirs(project_type=self.project_builder.project_type)

            self.project_builder.build_project(base_dirs=base_dirs)
        
        if assets:
            logger.info(f"Project contains {len(assets)} assets.")
            for asset in assets:
                logger.info(asset)

                asset_type_dir = self.settings.get_asset_type_dir_name(asset_type=asset.type)
                # subtypes = self.settings.get_asset_subtypes(asset_type=asset.type)

                self.project_builder.add_asset(name=asset.name, asset_type_dir=asset_type_dir, subtypes=[])


        logger.info(f"Project '{project_name}' created successfully at {self.project_builder.path}.")

        
def main():
    app = qtg.QGuiApplication(sys.argv)

    engine = qml.QQmlApplicationEngine()

    backend = Backend()
    engine.rootContext().setContextProperty('backend', backend)

    assetListModel = QAssetListModel()
    engine.rootContext().setContextProperty('assetListModel', assetListModel)

    # qAsset = QAsset()
    # engine.rootContext().setContextProperty('qAsset', qAsset)

    engine.load(qtc.QUrl.fromLocalFile("ui/main.qml"))

    if not engine.rootObjects():
        return -1

    return app.exec()


if __name__ == '__main__':
    main()
