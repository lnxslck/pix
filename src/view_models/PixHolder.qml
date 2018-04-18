import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Item
{
    property string emoji
    property string message
    clip: true
    property color foregroundColor : textColor
    focus: true
    anchors.fill: parent

    GridLayout
    {
        id:placeHolder
        anchors.fill: parent

        columns: 1
        rows: 2

        Rectangle
        {

            anchors.fill: parent

            Layout.row: 1
            color: "transparent"

            Image
            {
                id: imageHolder

                anchors.centerIn: parent
                width: iconSizes.large
                height: iconSizes.large
                source: emoji? emoji : "qrc:/../assets/face.png"
                horizontalAlignment: Qt.AlignHCenter

                fillMode: Image.PreserveAspectFit
            }

            HueSaturation
            {
                anchors.fill: imageHolder
                source: imageHolder
                saturation: -1
                lightness: 0.3
            }

            Label
            {
                id: textHolder
                width: parent.width
                anchors.top: imageHolder.bottom
                opacity: 0.3
                text: message ? qsTr(message) : qsTr("Nothing here...")
                font.pointSize: fontSizes.small

                padding: space.medium
                font.bold: true
                textFormat: Text.RichText
                horizontalAlignment: Qt.AlignHCenter
                elide: Text.ElideRight
                color: foregroundColor
            }
        }
    }
}
