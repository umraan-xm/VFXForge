import os
import shutil

import sys
sys.path.append('vfxforge')

import pytest
from unittest.mock import Mock

from vfxforge.core.project_builder import ProjectBuilder
from vfxforge.settings import Settings

TEST_DIR = "tests/test_project_folder"

@pytest.fixture(scope='module')
def setup_test_folder():
    os.makedirs(TEST_DIR, exist_ok=True)
    yield
    shutil.rmtree(TEST_DIR)


@pytest.fixture
def mock_settings():
    settings = Mock(spec=Settings)

    settings.get_project_base_dirs.side_effect = lambda project_type: {
        "VFX": ["asset", "sequence", "IO", "development", "pipeline", "rnd"],
        "TV EPISODIC": ["asset", "episode", "IO", "development", "pipeline", "rnd"],
        "ANIMATION": ["asset", "episode", "IO", "development", "pipeline", "rnd"]
    }.get(project_type, [])

    settings.get_asset_type_dir_name.side_effect = lambda asset_type: {
        "Character": "chr",
        "Crowd": "crd",
        "Creature": "crt",
        "Environment": "evr",
        "Prop": "prp",
        "Vehicle": "veh"
    }.get(asset_type, None)


    settings.get_version_departments.return_value = [
        "Shoot", "Concept", "Model", "Surfacing", "Rigging", "Tech Rigging", "USD"
    ]

    settings.get_version_dept_disciplines.side_effect = lambda department: {
        "Shoot": ["Data Acquisition", "Data Processing"],
        "Concept": ["Art", "Sculpt"],
        "Model": ["Geometry", "Scan", "Sculpt"],
        "Surfacing": ["Texture", "Look Development", "Groom"],
        "Rigging": ["Animation", "Mocap"],
        "Tech Rigging": ["Costume", "Groom", "Muscle"],
        "USD": ["Compound", "Package"]
    }.get(department, [])

    settings.get_version_dept_dir_name.side_effect = lambda department: {
        "Shoot": "sho",
        "Concept": "ccp",
        "Model": "mod",
        "Surfacing": "srf",
        "Rigging": "rig",
        "Tech Rigging": "trg",
        "USD": "usd"
    }.get(department, None)

    settings.get_version_dept_disc_dir_name.side_effect = lambda department, discipline: {
        ("Shoot", "Data Acquisition"): "dta",
        ("Shoot", "Data Processing"): "dtp",
        ("Concept", "Art"): "art",
        ("Concept", "Sculpt"): "scu",
        ("Model", "Geometry"): "geo",
        ("Model", "Scan"): "scn",
        ("Model", "Sculpt"): "scu",
        ("Surfacing", "Texture"): "tex",
        ("Surfacing", "Look Development"): "ldv",
        ("Surfacing", "Groom"): "grm",
        ("Rigging", "Animation"): "anm",
        ("Rigging", "Mocap"): "mcp",
        ("Tech Rigging", "Costume"): "cst",
        ("Tech Rigging", "Groom"): "grm",
        ("Tech Rigging", "Muscle"): "msc",
        ("USD", "Compound"): "cmp",
        ("USD", "Package"): "pck"
    }.get((department, discipline), None)

    return settings


@pytest.fixture
def project_builder(mock_settings):
    return ProjectBuilder("TestProject", TEST_DIR, "VFX", mock_settings)


def test_build_project(setup_test_folder, project_builder, mock_settings):
    project_builder.build_project()

    assert os.path.exists(project_builder.path)
    for folder in mock_settings.get_project_base_dirs(project_type=project_builder.project_type):
        assert os.path.exists(os.path.join(project_builder.path, folder))


def test_add_asset(setup_test_folder, project_builder, mock_settings):
    asset_name = 'TestAsset'
    asset_type = 'Character'

    project_builder.build_project()
    
    asset_path = project_builder.add_asset(name=asset_name, asset_type=asset_type)

    expected_asset_path = os.path.join(project_builder.path, ProjectBuilder.ASSET, mock_settings.get_asset_type_dir_name(asset_type), asset_name)

    assert asset_path == expected_asset_path
    assert os.path.exists(asset_path)


def test_add_asset_subtype(setup_test_folder, project_builder, mock_settings):
    asset_name = 'TestAsset'
    asset_type = 'Character'
    subtype_name = 'Body'
    variants = ['variant1', 'variant2']
    
    project_builder.build_project()
    
    asset_path = project_builder.add_asset(name=asset_name, asset_type=asset_type)
    
    project_builder.add_asset_subtype(asset_path=asset_path, name=subtype_name, variants=variants)

    for variant in variants:
        variant_path = os.path.join(asset_path, subtype_name, variant)
        assert os.path.exists(variant_path)
        assert os.path.exists(os.path.join(variant_path, ProjectBuilder.WIP))
        assert os.path.exists(os.path.join(variant_path, ProjectBuilder.VERSIONS))
        assert os.path.exists(os.path.join(variant_path, ProjectBuilder.PUBLISHED))

        versions_path = os.path.join(variant_path, ProjectBuilder.VERSIONS)

        for department in mock_settings.get_version_departments():
            department_dir = os.path.join(versions_path, mock_settings.get_version_dept_dir_name(department))
            assert os.path.exists(department_dir)
            
            for discipline in mock_settings.get_version_dept_disciplines(department):
                discipline_dir = os.path.join(department_dir, mock_settings.get_version_dept_disc_dir_name(department, discipline))
                assert os.path.exists(discipline_dir)


def test_add_sequence(setup_test_folder, project_builder):
    sequence_name = 'TestSequence'
    shots = 5
    
    project_builder.build_project()
    
    project_builder.add_sequence(name=sequence_name, shots=shots)

    sequence_path = os.path.join(project_builder.path, ProjectBuilder.SEQUENCE, sequence_name)
    assert os.path.exists(sequence_path)

    shot_names = project_builder._generate_shot_names(prefix=sequence_name, shots=shots)
    for shot_name in shot_names:
        shot_path = os.path.join(sequence_path, shot_name)
        assert os.path.exists(shot_path)
        assert os.path.exists(os.path.join(shot_path, ProjectBuilder.WIP))
        assert os.path.exists(os.path.join(shot_path, ProjectBuilder.PUBLISHED))
