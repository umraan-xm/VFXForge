import os
from typing import List

import logging
logger = logging.getLogger(__name__)

class ProjectBuilder:
    def __init__(self, name: str, path: str, project_type: str) -> None:
        self.name = name
        self.path = os.path.join(path, name)
        self.project_type = project_type

        self.asset_dir = 'asset'

    def build_project(self, base_dirs: List[str]):
        logger.debug(f"Creating Project Directories: {self.path}")
        os.makedirs(self.path, exist_ok=True)
        

        for directory in base_dirs:
            logger.debug(f"Creating directory: {directory}")
            os.makedirs(os.path.join(self.path, directory), exist_ok=True)
            

    def add_asset(self, name: str, asset_type_dir: str):
        asset_path = os.path.join(self.path, self.asset_dir, asset_type_dir, name)

        logger.debug(f"Creating asset directory: {asset_path}")
        os.makedirs(asset_path, exist_ok=True)