#ifndef PIX_H
#define PIX_H


#include <QString>
#include <QDebug>
#include <QStandardPaths>
#include <QFileInfo>
#include <QImage>
#include <QTime>
#include <QSettings>
#include <QDirIterator>
#include <QVariantList>


using namespace std;


class CollectionDB;
class FileLoader;
class QFileSystemWatcher;

class Pix : public QObject
{
    Q_OBJECT

public:
    explicit Pix(QObject* parent = nullptr);
    ~Pix();

    Q_INVOKABLE QVariantList getList(const QStringList &urls);
    Q_INVOKABLE QVariantList get(const QString &queryTxt);
    Q_INVOKABLE bool run(const QString &query);


    Q_INVOKABLE static QString backgroundColor();
    Q_INVOKABLE static QString foregroundColor();
    Q_INVOKABLE static QString hightlightColor();
    Q_INVOKABLE static QString midColor();
    Q_INVOKABLE static QString altColor();
    Q_INVOKABLE static QString pixColor();

    Q_INVOKABLE static bool isMobile();
    Q_INVOKABLE static int screenGeometry(QString &side);
    Q_INVOKABLE static int cursorPos(QString &axis);

    Q_INVOKABLE static QString homeDir();

    Q_INVOKABLE static QVariantList getDirs(const QString &pathUrl);
    Q_INVOKABLE static QVariantMap getParentDir(const QString &path);


private:
    CollectionDB *con;
    FileLoader *fileLoader;
    QStringList dirs;
    QFileSystemWatcher *watcher;

    void populateDB(const QString &path);
    void collectionWatcher();
    void addToWatcher(QStringList paths);
    void handleDirectoryChanged(const QString &dir);    

signals:
    void refreshTables(QVariantMap tables);
    void populate(QString path);

};



#endif // PIX_H
