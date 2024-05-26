from PyQt6 import QtCore as qtc
from PyQt6 import QtGui as qtg
from PyQt6 import QtQml as qml
import sys


def main():
    app = qtg.QGuiApplication(sys.argv)
    engine = qml.QQmlApplicationEngine()

    engine.load(qtc.QUrl.fromLocalFile("ui/main.qml"))

    if not engine.rootObjects():
        return -1

    return app.exec()


if __name__ == '__main__':
    main()
