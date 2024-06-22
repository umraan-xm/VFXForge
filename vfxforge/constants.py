import os

BASE_DIR = "vfxforge"

UI_DIR = os.path.join(BASE_DIR, "ui")

DATABASE_DIR = os.path.join(BASE_DIR, "database")

JSON_SETTINGS_FILEPATH = os.path.join(DATABASE_DIR, "settings.json")

MAIN_QML_FILEPATH = os.path.join(UI_DIR, "main.qml")