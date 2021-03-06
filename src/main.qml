/***
Pix  Copyright (C) 2018  Camilo Higuita
This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
This is free software, and you are welcome to redistribute it
under certain conditions; type `show c' for details.

 This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
***/


import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1

import org.kde.kirigami 2.0 as Kirigami
import org.kde.mauikit 1.0 as Maui

import "widgets"
import "widgets/views/Albums"
import "widgets/views/Folders"
import "widgets/views/Gallery"
import "widgets/views/Settings"
import "widgets/views/Tags"
import "widgets/views/Viewer"
import "widgets/views/Search"
import "widgets/views/Cloud"
import "widgets/views/Store"

import "view_models"
import "widgets/dialogs/Albums"
import "widgets/dialogs/Tags"

import "widgets/views/Pix.js" as PIX
import "widgets/views/Viewer/Viewer.js" as VIEWER
import "db/Query.js" as Q

import PixModel 1.0
import AlbumsList 1.0

import TagsModel 1.0
import TagsList 1.0

import SyncingModel 1.0
import SyncingList 1.0

import FMList 1.0
import StoreList 1.0

Maui.ApplicationWindow
{
    id: root
    title: qsTr("Pix")
    showAccounts: false
    //    visibility: fullScreen ? ApplicationWindow.FullScreen : ApplicationWindow.Windowed
    //    altToolBars: true
    about.appDescription: qsTr("Pix is an image gallery manager made for Maui. Pix is a convergent and multiplatform app that works under Android and GNU Linux distros.")
    about.appIcon: "qrc:/img/assets/pix.svg"

    property alias dialog : dialogLoader.item
    /*READONLY PROPS*/
    readonly property var views : ({
                                       viewer: 0,
                                       gallery: 1,
                                       folders: 2,
                                       albums: 3,
                                       tags: 4,
//                                       cloud: 5,
//                                       store: 6,
                                       search: 5
                                   })
    /*PROPS*/

    property int currentView : views.gallery
    property bool fullScreen : false

    property bool selectionMode : false

    /***************************************************/
    /******************** UI COLORS *******************/
    /*************************************************/

    highlightColor : "#00abaa"
    altColor : "#2e2f30" // "#545c6e"
    accentColor: altColor
    altColorText: "#fafafa"

    colorSchemeName: "pix"
    bgColor: backgroundColor
    headBar.drawBorder: false
    headBar.implicitHeight: toolBarHeight * 1.5
    headBarBGColor: backgroundColor
    headBarFGColor: currentView === views.viewer ? altColorText : Maui.Style.textColor
    backgroundColor:  currentView === views.viewer ? "#3c3e3f" : viewBackgroundColor
    viewBackgroundColor: currentView === views.viewer ? backgroundColor : Maui.Style.viewBackgroundColor
    textColor: headBarFGColor

    /***************************************************/
    /**************************************************/
    /*************************************************/

    onSearchButtonClicked: currentView =  views.search

    //    menuDrawer.bannerImageSource: "qrc:/img/assets/banner.png"
    mainMenu: [

//        Maui.MenuItem
//        {
//            id: _storeButton
//            text: qsTr("Store")
//            onTriggered: currentView = views.store
//            icon.name: "nx-software-center"
//        },

//        Maui.MenuItem
//        {
//            id: _cloudButton
//            text: qsTr("Cloud")
//            onTriggered: currentView = views.cloud
//            icon.name: "folder-cloud"
//        },

        Maui.MenuItem
        {
            id: _tagsButton
            text: qsTr("Tags")
            onTriggered: currentView = views.tags
            icon.name: "tag"
        },

        MenuSeparator {},

        Maui.MenuItem
        {
            text: "Sources"
            icon.name: "folder-add"
            onTriggered:
            {
                dialogLoader.sourceComponent= fmDialogComponent
                dialog.mode= dialog.modes.OPEN
                dialog.onlyDirs= true
                dialog.show(function(paths)
                {
                    pix.addSources(paths)
                })
            }
        },

        Maui.MenuItem
        {
            text: "Open..."
            onTriggered:
            {
                dialogLoader.sourceComponent= fmDialogComponent
                dialog.mode = dialog.modes.OPEN
                dialog.filterType= FMList.IMAGE
                dialog.onlyDirs= false
                dialog.show(function(paths)
                {
                    pix.openPics(paths)

                });
            }
        }
    ]

    headBar.visible: !fullScreen

    headBar.middleContent: [
        Maui.ToolButton
        {
            text: qsTr("Viewer")
            visible: !pixViewer.holder.visible
            iconColor: currentView === views.viewer ? highlightColor : headBarFGColor
            iconName: "image"
            onClicked: currentView = views.viewer
        },

        Maui.ToolButton
        {
            text: qsTr("Gallery")
            iconColor: currentView === views.gallery? highlightColor : headBarFGColor
            iconName: "image-multiple"
            onClicked: currentView = views.gallery
        },

        Maui.ToolButton
        {
            text: qsTr("Folders")
            iconColor: currentView === views.folders? highlightColor : headBarFGColor
            iconName: "image-folder-view"
            onClicked: currentView = views.folders
        },

        Maui.ToolButton
        {
            text: qsTr("Albums")
            iconColor: currentView === views.albums? highlightColor : headBarFGColor
            iconName: "image-frames"
            onClicked: currentView = views.albums
        }
    ]

    content: Item
    {
        anchors.fill: parent

        Rectangle
        {
            anchors.fill: parent
            color: bgColor
        }

        ColumnLayout
        {
            anchors.fill: parent



            SwipeView
            {
                id: swipeView
                Layout.fillHeight: true
                Layout.fillWidth: true
                interactive: isMobile
                currentIndex: currentView

                onCurrentIndexChanged: currentView = currentIndex

                PixViewer
                {
                    id: pixViewer
                }

                GalleryView
                {
                    id: galleryView
                }

                FoldersView
                {
                    id: foldersView
                }

                AlbumsView
                {
                    id: albumsView
                }

                TagsView
                {
                    id: tagsView
                }


//                Loader
//                {
//                    id: cloudViewLoader
//                }

//                Loader
//                {
//                    id: storeViewLoader
//                }

                SearchView
                {
                    id: searchView
                }

            }

            SelectionBar
            {
                id: selectionBox
                Layout.fillWidth : true
                Layout.leftMargin: space.big
                Layout.rightMargin: space.big
                Layout.bottomMargin: space.big
                Layout.topMargin: space.small
            }
        }
    }

    /*** Components ***/

//    Component
//    {
//        id: _cloudViewComponent
//        CloudView
//        {
//            anchors.fill : parent
//        }
//    }

//    Component
//    {
//        id: _storeViewComponent

//        Maui.Store
//        {
//            anchors.fill : parent
//            detailsView: true
//            list.category: StoreList.WALLPAPERS
//            list.provider: StoreList.KDELOOK
//        }
//    }

    Component
    {
        id: shareDialogComponent
        Maui.ShareDialog
        {
            id: shareDialog
        }
    }

    Component
    {
        id: albumsDialogComponent
        AlbumsDialog
        {
            id: albumsDialog
        }
    }

    Component
    {
        id: tagsDialogComponent
        TagsDialog
        {
            id: tagsDialog
            forAlbum: false
            onTagsAdded: addTagsToPic(urls, tags)
        }
    }

    Component
    {
        id: fmDialogComponent
        Maui.FileDialog
        {
            id: fmDialog
            onlyDirs: false
            mode: modes.SAVE
            filterType: FMList.IMAGE
        }
    }

    Loader
    {
        id: dialogLoader
    }

    /***MODELS****/
    PixModel
    {
        id: albumsModel
        list: albumsList
    }

    AlbumsList
    {
        id: albumsList
        query: Q.Query.allAlbums
    }

    TagsModel
    {
        id: tagsModel
        list: tagsList
    }

    TagsList
    {
        id: tagsList
    }

    Connections
    {
        target: pix
        onRefreshViews: PIX.refreshViews()
        onViewPics: VIEWER.openExternalPics(pics, 0)
    }

//    Component.onCompleted:
//    {
//        cloudViewLoader.sourceComponent = _cloudViewComponent
//        storeViewLoader.sourceComponent= _storeViewComponent
//    }
}
