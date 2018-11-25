#include <QtQuick>
#include <sailfishapp.h>
#include "AudioRecorder.h"

int main(int argc, char *argv[])
{
    qmlRegisterType<AudioRecorder>("Multimedia", 1, 0, "AudioRecorder");
    return SailfishApp::main(argc, argv);
}
