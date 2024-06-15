from typing import List

from abc import ABC, abstractmethod
import json

import logging
logger = logging.getLogger(__name__)


class Settings(ABC):
    @abstractmethod
    def get_project_base_dirs(self, project_type: str) -> List[str]:
        pass

    @abstractmethod
    def get_project_types(self) -> List[str]:
        pass

    @abstractmethod
    def get_asset_types(self) -> List[str]:
        pass

    @abstractmethod
    def get_asset_type_dir_name(self, asset_type: str) -> str:
        pass

    @abstractmethod
    def get_default_asset_subtypes(self, asset_type: str) -> List[str]:
        pass

    @abstractmethod
    def get_version_departments(self) -> List[str]:
        pass

    @abstractmethod
    def get_version_dept_dir_name(self, department: str):
        pass

    @abstractmethod
    def get_version_dept_disciplines(self, department: str) -> List[str]:
        pass

    @abstractmethod
    def get_version_dept_disc_dir_name(self, department: str, discipline: str) -> str:
        pass


class JSONSettings(Settings):
    def __init__(self, filepath: str):
        self._json_file = filepath
        self._settings = self._load_settings()

    def _load_settings(self):
        logger.debug(f"Retrieving settings via JSON file: {self._json_file}")

        with open(self._json_file, 'r') as file:
            return json.load(file)
        
    def get_project_base_dirs(self, project_type: str) -> List[str]:
        return self._settings.get("base_dirs").get(project_type, [])
 
    def get_project_types(self) -> List[str]:
        return list(self._settings.get("base_dirs"))
    
    def get_asset_types(self) -> List[str]:
        return list(self._settings.get("asset_types"))
    
    def get_asset_type_dir_name(self, asset_type: str) -> str:
        return self._settings.get("asset_types").get(asset_type).get("dir_name")
    
    def get_default_asset_subtypes(self, asset_type: str) -> List[str]:
        return self._settings.get("asset_types").get(asset_type).get("subtypes")
    
    def get_version_departments(self) -> List[str]:
        return list(self._settings.get("versions_dirs"))
    
    def get_version_dept_dir_name(self, department: str):
        return self._settings.get("versions_dirs").get(department).get("dir_name")
    
    def get_version_dept_disciplines(self, department: str) -> List[str]:
        return list(self._settings.get("versions_dirs").get(department).get("disciplines"))
    
    def get_version_dept_disc_dir_name(self, department: str, discipline: str) -> str:
        return self._settings.get("versions_dirs").get(department).get("disciplines").get(discipline).get("dir_name")
    