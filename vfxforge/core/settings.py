from typing import List

from abc import ABC, abstractmethod
import json


class SettingsSource(ABC):
    @abstractmethod
    def load_settings(self) -> dict:
        pass


class JSONSettingsSource(SettingsSource):
    def __init__(self, json_file: str):
        self.json_file = json_file

    def load_settings(self) -> dict:
        with open(self.json_file, 'r') as file:
            return json.load(file)


class Settings:
    def __init__(self, source: SettingsSource):
        self._source = source
        self._settings = self._source.load_settings()
 
    def get_project_types(self) -> List[str]:
        return list(self._settings["base_dirs"].keys())
        
    def get_project_base_dirs(self, project_type) -> List[str]:
        return self._settings["base_dirs"].get(project_type, [])