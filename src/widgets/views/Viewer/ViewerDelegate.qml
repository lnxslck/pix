import QtQuick 2.0
import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
import org.kde.kirigami 2.4 as Kirigami

Flickable
{
    id: flick

    property int itemWidth : parent.width
    property int itemHeight : parent.height

    property alias status : image.status


    readonly property string currentImageSource: "file://"+model.url

    property alias image: image

    signal rightClicked();
    signal pressAndHold();

    width: itemWidth
    height: itemHeight

    contentWidth: itemWidth
    contentHeight: itemHeight

    interactive: contentWidth > width || contentHeight > height
    onInteractiveChanged: viewerList.interactive = !interactive;
    clip: true
    z: index == viewerList.currentIndex ? 1000 : 0

    ScrollBar.vertical: ScrollBar {}
    ScrollBar.horizontal: ScrollBar {}

    PinchArea
    {
        width: Math.max(flick.contentWidth, flick.width)
        height: Math.max(flick.contentHeight, flick.height)

        property real initialWidth
        property real initialHeight

        onPinchStarted:
        {
            initialWidth = flick.contentWidth
            initialHeight = flick.contentHeight
        }

        onPinchUpdated:
        {
            // adjust content pos due to drag
            flick.contentX += pinch.previousCenter.x - pinch.center.x
            flick.contentY += pinch.previousCenter.y - pinch.center.y

            // resize content
            flick.resizeContent(Math.max(itemWidth*0.7, initialWidth * pinch.scale), Math.max(itemHeight*0.7, initialHeight * pinch.scale), pinch.center)
        }

        onPinchFinished:
        {
            // Move its content within bounds.
            if (flick.contentWidth < itemWidth || flick.contentHeight < itemHeight)
            {
                zoomAnim.x = 0;
                zoomAnim.y = 0;
                zoomAnim.width = itemWidth;
                zoomAnim.height = itemHeight;
                zoomAnim.running = true;
            } else {
                flick.returnToBounds();
            }
        }

        ParallelAnimation
        {
            id: zoomAnim
            property real x: 0
            property real y: 0
            property real width: itemWidth
            property real height: itemHeight

            NumberAnimation
            {
                target: flick
                property: "contentWidth"
                from: flick.contentWidth
                to: zoomAnim.width
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }

            NumberAnimation
            {
                target: flick
                property: "contentHeight"
                from: flick.contentHeight
                to: zoomAnim.height
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }

            NumberAnimation
            {
                target: flick
                property: "contentY"
                from: flick.contentY
                to: zoomAnim.y
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }

            NumberAnimation
            {
                target: flick
                property: "contentX"
                from: flick.contentX
                to: zoomAnim.x
                duration: Kirigami.Units.longDuration
                easing.type: Easing.InOutQuad
            }
        }

        Image
        {
            id: image
            width: flick.contentWidth
            height: flick.contentHeight
            fillMode: Image.PreserveAspectFit
            source: currentImageSource
            autoTransform: true
            asynchronous: true


            MouseArea
            {
                anchors.fill: parent

                acceptedButtons:  Qt.RightButton | Qt.LeftButton
                onClicked:  if(!isMobile && mouse.button === Qt.RightButton)
                                rightClicked()

                onPressAndHold: flick.pressAndHold()

                onDoubleClicked:
                {
                    if (flick.interactive) {
                        zoomAnim.x = 0;
                        zoomAnim.y = 0;
                        zoomAnim.width = itemWidth;
                        zoomAnim.height = itemHeight;
                        zoomAnim.running = true;
                    } else {
                        zoomAnim.x = mouse.x * 2;
                        zoomAnim.y = mouse.y *2;
                        zoomAnim.width = itemWidth * 3;
                        zoomAnim.height = itemHeight * 3;
                        zoomAnim.running = true;
                    }
                }

                onWheel:
                {
                    if (wheel.modifiers & Qt.ControlModifier)
                    {
                        if (wheel.angleDelta.y != 0) {
                            var factor = 1 + wheel.angleDelta.y / 600;
                            zoomAnim.running = false;

                            zoomAnim.width = Math.min(Math.max(itemWidth, zoomAnim.width * factor), itemWidth * 4);
                            zoomAnim.height = Math.min(Math.max(itemHeight, zoomAnim.height * factor), itemHeight * 4);

                            //actual factors, may be less than factor
                            var xFactor = zoomAnim.width / flick.contentWidth;
                            var yFactor = zoomAnim.height / flick.contentHeight;

                            zoomAnim.x = flick.contentX * xFactor + (((wheel.x - flick.contentX) * xFactor) - (wheel.x - flick.contentX))
                            zoomAnim.y = flick.contentY * yFactor + (((wheel.y - flick.contentY) * yFactor) - (wheel.y - flick.contentY))
                            zoomAnim.running = true;

                        } else if (wheel.pixelDelta.y != 0) {
                            flick.resizeContent(Math.min(Math.max(itemWidth, flick.contentWidth + wheel.pixelDelta.y), itemWidth * 4),
                                                Math.min(Math.max(itemHeight, flick.contentHeight + wheel.pixelDelta.y), itemHeight * 4),
                                                wheel);
                        }
                    }
                }
            }
        }
    }

    function zoomIn()
    {
        image.width = image.width + 50
    }

    function zoomOut()
    {
        image.width = image.width - 50 > 100 ? image.width - 50 :
                                               image.width
    }

    function fit()
    {
        image.width = image.sourceSize.width
    }

    function fill()
    {
        image.width = parent.width
    }

    function rotateLeft()
    {
        image.rotation = image.rotation - 90
    }

    function rotateRight()
    {
        image.rotation = image.rotation + 90
    }
}
