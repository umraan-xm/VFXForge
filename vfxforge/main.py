import sys
from typing import List

import logging
logging.basicConfig(
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s", level=logging.DEBUG
)
logger = logging.getLogger(__name__)

from PyQt6 import QtCore as qtc
from PyQt6 import QtGui as qtg
from PyQt6 import QtQml as qml

from core.project_builder import ProjectBuilder
from settings import JSONSettings, Settings
import constants

from models.asset import QAssetListModel, QAsset, QAssetSubtypeListModel


class Backend(qtc.QObject):
    def __init__(self, settings: Settings):
        super().__init__()
        self.project_builder = None
        self.settings = settings

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

            self.project_builder.build_project(project_type=project_type)
        
        if assets:
            logger.info(f"Project contains {len(assets)} assets.")
            for asset in assets:
                logger.info(asset)

                # asset_type_dir = self.settings.get_asset_type_dir_name(asset_type=asset.type)

                subtypes = []
                for subtype in asset.subtypes.items:
                    subtypes.append((subtype.name, map(str, subtype.variants.items)))

                self.project_builder.add_asset(name=asset.name, asset_type=asset.type, subtypes=subtypes)


        logger.info(f"Project '{project_name}' created successfully at {self.project_builder.path}.")

        
def main():
    app = qtg.QGuiApplication(sys.argv)

    engine = qml.QQmlApplicationEngine()

    settings = JSONSettings(filepath=constants.JSON_SETTINGS_FILEPATH)

    backend = Backend(settings=settings)
    engine.rootContext().setContextProperty('backend', backend)

    assetListModel = QAssetListModel()
    engine.rootContext().setContextProperty('assetListModel', assetListModel)

    engine.load(qtc.QUrl.fromLocalFile(constants.MAIN_QML_FILEPATH))

    if not engine.rootObjects():
        return -1

    return app.exec()


if __name__ == '__main__':
    main()
