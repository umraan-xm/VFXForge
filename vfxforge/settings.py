from typing import List

from abc import ABC, abstractmethod
import json

import logging
logger = logging.getLogger(__name__)


class Settings(ABC):
    def get_project_types(self) -> List[str]:
        pass

    def get_asset_types(self) -> List[str]:
        pass
    
    def get_project_base_dirs(self, project_type) -> List[str]:
        pass


class JSONSettings(Settings):
    def __init__(self, filepath: str):
        self._json_file = filepath
        self._settings = self._load_settings()

    def _load_settings(self):
        logger.debug(f"Retrieving settings via JSON file: {self._json_file}")

        with open(self._json_file, 'r') as file:
            return json.load(file)
 
    def get_project_types(self) -> List[str]:
        return list(self._settings.get("base_dirs").keys())
    
    def get_asset_types(self) -> List[str]:
        return list(self._settings.get("asset_types"))
        
    def get_project_base_dirs(self, project_type) -> List[str]:
        return self._settings.get("base_dirs").get(project_type, [])