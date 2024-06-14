import os
from typing import List, Tuple

import logging
logger = logging.getLogger(__name__)

class ProjectBuilder:
    ASSET = 'asset'
    WIP = 'wip'
    PUBLISHED = 'published'
    VERSIONS = 'versions'

    def __init__(self, name: str, path: str, project_type: str) -> None:
        self.name = name
        self.path = os.path.join(path, name)
        self.project_type = project_type

    def _create_directory(self, path: str, log_message: str=""):
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

    def build_project(self, base_dirs: List[str]):
        self._create_directory(self.path)
        
        for directory in base_dirs:
            self._create_directory(os.path.join(self.path, directory))

    def add_asset(self, name: str, asset_type_dir: str, subtypes: List[Tuple[str, List[str]]]=None):
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