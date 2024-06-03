import os
from typing import List

import logging
logger = logging.getLogger(__name__)

class ProjectBuilder:
    def __init__(self, name: str, path: str, project_type: str) -> None:
        self.name = name
        self.path = os.path.join(path, name)
        self.project_type = project_type

    def build_project(self, base_dirs: List[str]):
        os.makedirs(self.path, exist_ok=True)
        logger.debug(f"Project directory created at {self.path}")

        for directory in base_dirs:
            os.makedirs(os.path.join(self.path, directory), exist_ok=True)
            logger.debug(f"Created directory: {directory}")

    def add_asset():
        pass