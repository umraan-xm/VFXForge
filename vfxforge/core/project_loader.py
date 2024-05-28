from abc import ABC, abstractmethod
import json


class ProjectStructureSource(ABC):
    @abstractmethod
    def load_folder_structures(self) -> dict:
        pass

class JSONProjectStructureSource(ProjectStructureSource):
    def __init__(self, json_file):
        self.json_file = json_file

    def load_folder_structures(self):
        with open(self.json_file, 'r') as file:
            return json.load(file)

class ProjectStructureLoader:
    def __init__(self, data_source: ProjectStructureSource) -> None:
        self.data_source = data_source
        self.folder_structures = self.data_source.load_folder_structures()
 
    def get_project_types(self):
        return list(self.folder_structures.keys())
        
    def get_subdirectories(self, project_type):
        return self.folder_structures.get(project_type, [])