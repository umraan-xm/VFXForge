import os
from typing import List

class ProjectBuilder:
    def __init__(self, name: str, path: str, project_type: str) -> None:
        self.name = name
        self.path = os.path.join(path, name)
        self.project_type = project_type

    def build_project(self, base_dirs: List[str]):
        os.makedirs(self.path, exist_ok=True)

        for directory in base_dirs:
            os.makedirs(os.path.join(self.path, directory), exist_ok=True)

    def add_asset():
        pass