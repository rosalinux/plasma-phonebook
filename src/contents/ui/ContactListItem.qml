/*
 * SPDX-FileCopyrightText: 2017-2019 Kaidan Developers and Contributors
 * SPDX-FileCopyrightText: 2019 Jonah Brüchert <jbb@kaidan.im>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtGraphicalEffects 1.0
import QtQuick 2.3
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.3
import "Utils.js" as Utils
import org.kde.kirigami 2.0 as Kirigami
import org.kde.people 1.0 as KPeople

Kirigami.AbstractListItem {
    id: listItem

    property string name
    property string phone
    property var avatarIcon

    contentItem: RowLayout {
        height: 132
        width: 620

        anchors {
            fill: parent
            top: parent
        }

        Rectangle {
            Layout.leftMargin: 25
            x: 0
            y: 0
            height: 93
            width: 93
            radius: 5.23
            color: Utils.getColorForContact(cnt.text)

            Controls.Label {
                id: cnt

                x: 15
                y: 11
                height: 63
                width: 63
                font.family: "Manrope"
                font.pixelSize: 60
                color: "white"
                text: Utils.getChar(model.display)
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
            }

        }

        Rectangle {
            Controls.Label {
                x: 145
                y: 27
                height: 30
                width: 380
                text: name
                textFormat: Text.PlainText
                maximumLineCount: 1
                Layout.fillWidth: true
                font.family: "Manrope"
                font.pixelSize: 26
                wrapMode: Text.Wrap
                elide: Text.ElideRight

                anchors {
                    top: parent
                    left: parent
                }

            }

        }

        Rectangle {
            Controls.Label {
                x: 145
                y: 75
                height: 30
                width: 160
                text: phone
                textFormat: Text.PlainText
                maximumLineCount: 1
                Layout.fillWidth: true
                font.family: "Manrope"
                font.pixelSize: 26

                anchors {
                    top: parent
                    left: parent
                }

            }

        }

    }

}
