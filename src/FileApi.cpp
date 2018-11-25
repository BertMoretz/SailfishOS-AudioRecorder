#include "FileApi.h"

FileApi::FileApi(QObject *parent) : QObject(parent)
{
}

void FileApi::remove(QString path) {
    if (QFile::exists(path)){
        QFile(path).remove();
    }
}
