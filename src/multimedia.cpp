#include <QtQuick>
#include <sailfishapp.h>
#include "AudioRecorder.h"
#include "FileApi.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<AudioRecorder>("Multimedia", 1, 0, "AudioRecorder");
    qmlRegisterType<FileApi>("Multimedia", 1, 0, "FileApi");
    return SailfishApp::main(argc, argv);
}
