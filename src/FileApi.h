#ifndef FILEAPI_H
#define FILEAPI_H

#include <QObject>
#include <QFile>
#include <QString>

class FileApi : public QObject
{
    Q_OBJECT
public:
    explicit FileApi(QObject *parent = nullptr);

    Q_INVOKABLE void remove(QString path);

signals:

public slots:
};

#endif // FILEAPI_H
