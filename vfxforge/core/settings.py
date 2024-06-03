from typing import List

from abc import ABC, abstractmethod
import json

import logging
logger = logging.getLogger(__name__)


class SettingsSource(ABC):
    @abstractmethod
    def load_settings(self) -> dict:
        pass


class JSONSettingsSource(SettingsSource):
    def __init__(self, json_file: str):
        self.json_file = json_file

    def load_settings(self) -> dict:
        logger.debug(f"Retrieving settings via JSON file: {self.json_file}")

        with open(self.json_file, 'r') as file:
            return json.load(file)


class Settings:
    def __init__(self, source: SettingsSource):
        self._source = source
        self._settings = self._source.load_settings()
 
    def get_project_types(self) -> List[str]:
        return list(self._settings.get("base_dirs").keys())
    
    def get_asset_types(self) -> List[str]:
        return list(self._settings.get("asset_types"))
        
    def get_project_base_dirs(self, project_type) -> List[str]:
        return self._settings.get("base_dirs").get(project_type, [])