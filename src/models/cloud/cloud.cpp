#include "cloud.h"

#ifdef Q_OS_ANDROID
#include "fm.h"
#include "fmh.h"
#else
#include <MauiKit/fm.h>
#include <MauiKit/fmh.h>
#endif

Cloud::Cloud(QObject *parent) : BaseList (parent)
{
    this->fm = FM::getInstance();
    this->setList();

//    connect(this->fm, &FM::cloudServerContentReady, [](const FMH::MODEL_LIST &list, const QString &url)
//    {
////        Q_UNUSED(url);
////        emit this->preListChanged();
////        this->list = list;
////        emit this->postListChanged();
//    });

}

FMH::MODEL_LIST Cloud::items() const
{
    return this->list;
}

void Cloud::setAccount(const QString value)
{
    if(this->account == value)
        return;

    this->account = value;
    emit this->accountChanged();

    this->setList();
}

QString Cloud::getAccount() const
{
    return this->account;
}

void Cloud::setList()
{
    this->fm->getCloudServerContent(FMH::PATHTYPE_NAME[FMH::PATHTYPE_KEY::CLOUD_PATH]+"/"+this->account, QStringList(), 3);
}

QVariantMap Cloud::get(const int &index) const
{
    if(index >= this->list.size() || index < 0)
        return QVariantMap();

    QVariantMap res;
    const auto pic = this->list.at(index);

    for(auto key : pic.keys())
        res.insert(FMH::MODEL_NAME[key], pic[key]);

    return res;
}