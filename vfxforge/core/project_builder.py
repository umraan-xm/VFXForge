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

    def __init__(self, name: str, path: str, project_type: str, settings: Settings) -> None:
        self.name = name
        self.path = os.path.join(path, name)
        self.project_type = project_type
        self.settings = settings

    def _create_directory(self, path: str):
        logger.debug(f"Creating Directory. {path}")
        os.makedirs(path, exist_ok=True)

    def _create_wip_directory(self, path: str):
        self._create_directory(os.path.join(path, self.WIP))

    def _create_versions_directory(self, path: str):
        self._create_directory(os.path.join(path, self.VERSIONS))

    def _create_published_directory(self, path: str):
        self._create_directory(os.path.join(path, self.PUBLISHED))

    def matches(self, name: str, path: str) -> bool:
        return self.path == os.path.join(path, name)

    def build_project(self, project_type: str):
        self._create_directory(self.path)

        base_dirs = self.settings.get_project_base_dirs(project_type=project_type)
        
        for directory in base_dirs:
            self._create_directory(os.path.join(self.path, directory))

    def add_asset(self, name: str, asset_type: str, subtypes: List[Tuple[str, List[str]]]=None):
        asset_type_dir = self.settings.get_asset_type_dir_name(asset_type=asset_type)
        asset_path = os.path.join(self.path, ProjectBuilder.ASSET, asset_type_dir, name)

        self._create_directory(asset_path)

        if subtypes:
            for subtype, variants in subtypes:
                subtype_path = os.path.join(asset_path, subtype)

                self._create_directory(subtype_path)

                for variant in variants:
                    variant_path = os.path.join(subtype_path, variant)

                    self._create_directory(variant_path)

                    self._create_published_directory(variant_path)
                    self._create_versions_directory(variant_path)
                    self._create_wip_directory(variant_path)