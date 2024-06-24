import os
from typing import List, Tuple

import logging
logger = logging.getLogger(__name__)

from settings import Settings

class ProjectBuilder:
    ASSET = 'asset'
    WIP = 'wip'
    PUBLISHED = 'published'
    VERSIONS = 'versions'
    IO = 'IO'
    INCOMING = 'incoming'
    OUTGOING = 'outgoing'
    SEQUENCE = 'sequence'

    def __init__(self, name: str, path: str, project_type: str, settings: Settings) -> None:
        self.name = name
        self.path = os.path.join(path, name)
        self.project_type = project_type
        self.settings = settings

    def _create_directory(self, path: str):
        logger.debug(f"Creating Directory. {path}")
        os.makedirs(path, exist_ok=True)

    def _create_io_directories(self, path):
        io_path = os.path.join(path, self.IO)
        self._create_directory(os.path.join(io_path, self.INCOMING))
        self._create_directory(os.path.join(io_path, self.OUTGOING))

    def _create_wip_directory(self, path: str):
        self._create_directory(os.path.join(path, self.WIP))

    def _create_versions_directory(self, path: str):
        path = os.path.join(path, self.VERSIONS)
        self._create_directory(path)

        departments = self.settings.get_version_departments()
        for department in departments:
            disciplines = self.settings.get_version_dept_disciplines(department)

            for discipline in disciplines:
                discipline_path = os.path.join(path, self.settings.get_version_dept_dir_name(department), self.settings.get_version_dept_disc_dir_name(department, discipline))
                self._create_directory(discipline_path)

    def _create_published_directory(self, path: str):
        self._create_directory(os.path.join(path, self.PUBLISHED))

    def _create_asset_working_folders(self, path: str):
        self._create_published_directory(path)
        self._create_versions_directory(path)
        self._create_wip_directory(path)

    def _create_shot_working_folders(self, path: str):
        self._create_published_directory(path)
        self._create_wip_directory(path)

    def _generate_shot_names(self, prefix: str, shots: int) -> List[str]:
        return [f"{prefix}{i*10:03}" for i in range(shots + 1)]

    def matches(self, name: str, path: str) -> bool:
        return self.path == os.path.join(path, name)

    def build_project(self):
        self._create_directory(self.path)

        base_dirs = self.settings.get_project_base_dirs(project_type=self.project_type)
        
        for directory in base_dirs:
            self._create_directory(os.path.join(self.path, directory))

        self._create_io_directories(self.path)

    def add_asset(self, name: str, asset_type: str) -> str:
        asset_type_dir = self.settings.get_asset_type_dir_name(asset_type=asset_type)
        asset_path = os.path.join(self.path, ProjectBuilder.ASSET, asset_type_dir, name)

        self._create_directory(asset_path)

        return asset_path

    def add_asset_subtype(self, asset_path: str, name: str, variants: List[str]=None):
        subtype_path = os.path.join(asset_path, name)

        self._create_directory(subtype_path)

        if variants:
            for variant in variants:
                variant_path = os.path.join(subtype_path, variant)

                self._create_directory(variant_path)

                self._create_asset_working_folders(variant_path)
        else:
            self._create_asset_working_folders(subtype_path)

    def add_sequence(self, name: str, shots: int):
        sequence_path = os.path.join(self.path, self.SEQUENCE, name)

        self._create_directory(sequence_path)

        shot_names = self._generate_shot_names(prefix=name, shots=shots)
        for shot_name in shot_names:
            shot_path = os.path.join(sequence_path, shot_name)
            self._create_directory(shot_path)
            self._create_shot_working_folders(shot_path)
        

