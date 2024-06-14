import os
import shutil

import pytest

from vfxforge.core.project_builder import ProjectBuilder

TEST_DIR = "tests/test_project_folder"

@pytest.fixture(scope='module')
def setup_test_folder():
    os.makedirs(TEST_DIR, exist_ok=True)
    yield
    shutil.rmtree(TEST_DIR)


def test_build_project(setup_test_folder):
    project_name = 'TestProject'
    base_path = TEST_DIR
    project_type = 'vfx'

    builder = ProjectBuilder(project_name, base_path, project_type)

    base_dirs = ["asset", "io", "scripts"]

    builder.build_project(base_dirs=base_dirs)

    assert os.path.exists(builder.path)
    for folder in base_dirs:
        assert os.path.exists(os.path.join(builder.path, folder))
