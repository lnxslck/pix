import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick 2.9

import org.kde.kirigami 2.0 as Kirigami
import org.kde.mauikit 1.0 as Maui

import "../Viewer/Viewer.js" as VIEWER
import "../Pix.js" as PIX
import "../../"

import StoreModel 1.0
import StoreList 1.0

import "../../../view_models"

Maui.Page
{
    id: control
    /*props*/
    property int itemSize : isMobile ? iconSizes.huge * 1.5 : iconSizes.enormous
    property int itemSpacing: isMobile ? space.medium : space.big
    property int itemRadius : unit * 6
    property bool showLabels : true
    property bool fitPreviews : false

    property alias grid: grid
    property alias holder: holder
    property alias list : _storeList
    property alias model: _storeModel

    /*signals*/
    floatingBar: false
    footBarOverlap: false
    footBar.drawBorder: false
    headBar.drawBorder: false
    altToolBars: false
    headBarExit: false
    headBar.visible: !holder.visible

    StoreModel
    {
        id: _storeModel
        list: _storeList
    }

    StoreList
    {
        id: _storeList
        limit : 50
        category: StoreList.WALLPAPERS
    }

    footBar.middleContent: [
        Maui.ToolButton
        {
            id: _previousPageButton
            iconName: "go-previous"
            tooltipText: qsTr("Previous")
            enabled: !holder.visible
            onClicked:
            {
                _storeList.page = _storeList.page === 0 ? 0 : _storeList.page-1
            }
        },

        Label
        {
            color: control.colorScheme.textColor
            text: _storeList.page
            font.bold: true
            font.weight: Font.Bold
            font.pointSize: fontSizes.big
            enabled: !holder.visible

            anchors.verticalCenter: _previousPageButton.verticalCenter
        },

        Maui.ToolButton
        {
            id: _nextPageButton
            iconName: "go-next"
            tooltipText: qsTr("Next")
            enabled: !holder.visible

            onClicked:
            {
                _storeList.page = _storeList.page+1
            }
        }
    ]

    headBar.middleContent: Maui.TextField
    {
        width: headBar.middleLayout.width * 0.8
        placeholderText: qsTr("Search...")
        onAccepted: _storeList.query = text
    }

    footBar.leftContent: [
        Maui.ToolButton
        {
            id:_filterButton
            iconName: "view-filter"
            iconColor: _filterDrawer.visible ? colorScheme.highlightColor : colorScheme.textColor
            onClicked: _filterDrawer.visible ? _filterDrawer.close() : _filterDrawer.open()
        }
    ]

    footBar.rightContent: [

        Maui.ToolButton
        {
            id:_sortButton
            iconName: "view-sort"
        }
    ]


    Maui.Holder
    {
        id: holder
        visible: grid.count === 0

        emojiSize: iconSizes.huge
        emoji: if(!_storeList.contentReady)
                   "qrc:/assets/animat-diamond-color.gif"
               else
                   "qrc:/assets/ElectricPlug.png"

        isGif: !_storeList.contentReady
        isMask: false
        title : if(!_storeList.contentReady)
                    qsTr("Loading content!")
                else
                    qsTr("Nothing here")

        body: if(!_storeList.contentReady)
                  qsTr("Almost ready!")
              else
                  qsTr("Make sure you're online and your cloud account is working")
    }

    Component
    {
        id: gridDelegate

        PixPic
        {
            id: delegate
            picSize : control.itemSize
            picRadius : control.itemRadius
            fit: control.fitPreviews
            showLabel: control.showLabels
            height: grid.cellHeight * 0.9
            width: grid.cellWidth * 0.8
            source: model.thumbnail
            label: model.label
        }
    }

    Maui.GridView
    {
        id: grid
        height: parent.height
        width: parent.width
        adaptContent: true
        itemSize: control.itemSize
        spacing: control.itemSpacing
        cellWidth: control.itemSize
        cellHeight: control.itemSize

        model: _storeModel
        delegate: gridDelegate
    }

    Maui.Popup
    {
        id: _filterDrawer
        parent: control
        height: unit * 500
        width: 200
        x: _filterButton.x
        y: _filterButton.y
        ListView
        {
            id: _filterList
            anchors.fill: parent
            anchors.margins: space.medium
            model: ListModel{id: _filterModel}
            delegate: Maui.ListDelegate
            {
                id: delegate
                radius: radiusV

                Connections
                {
                    target: delegate
                    onClicked:
                    {
                        _filterList.currentIndex = index
                    }
                }
            }

            focus: true
            interactive: true
            highlightFollowsCurrentItem: true
            highlightMoveDuration: 0
        }
    }

    Component.onCompleted:
    {
        var list = _storeList.getCategoryList()

        for(var i in list)
            _filterModel.append(list[i])

        for(var i = 0; i < 10 ; i++)
            _pageListModel.append({page : "a"})
    }
}
