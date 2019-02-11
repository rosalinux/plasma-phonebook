/*
 *   Copyright 2018 Fabian Riethmayer
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU Library General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.2
import org.kde.kirigami 2.4 as Kirigami
import QtGraphicalEffects 1.0
import org.kde.people 1.0 as KPeople

import "lib" as HIG


Flickable  {
    id: root
    property string personUri;
    signal editClicked()


    KPeople.PersonData {
        id: personData
        personUri: root.personUri
    }

    HIG.Header {
        id: header
        content.anchors.leftMargin: root.width > 400 ? 100 : Kirigami.Units.largeSpacing
        content.anchors.topMargin: Kirigami.Units.largeSpacing
        content.anchors.bottomMargin: Kirigami.Units.largeSpacing
        //status: root.contentY == 0 ? 1 : Math.min(1, Math.max(2 / 11, 1 - root.contentY / Kirigami.Units.gridUnit))
        source: personData.person.photo

        stripContent: Row {
            anchors.fill: parent
            spacing: (header.width - 3 * Kirigami.Units.iconSizes.medium) / 4
            anchors.leftMargin: spacing

            Kirigami.Icon {
                source: "favorite"
                width: Kirigami.Units.iconSizes.smallMedium
                height: width
                anchors.verticalCenter: parent.verticalCenter
            }
            Kirigami.Icon {
                source: "document-share"
                width: Kirigami.Units.iconSizes.smallMedium
                height: width
                anchors.verticalCenter: parent.verticalCenter
            }
            Kirigami.Icon {
                source: "document-edit"
                width: Kirigami.Units.iconSizes.smallMedium
                height: width
                anchors.verticalCenter: parent.verticalCenter
                MouseArea {
                    onClicked: root.editClicked()
                    anchors.fill: parent
                }
            }
        }

        Kirigami.Heading {
            text: personData.person.name
            color: "#fcfcfc"
            level: 1
        }
    }

    Column {
        id: comm
        anchors.top: header.bottom
        anchors.topMargin: 2 * Kirigami.Units.largeSpacing
        width: parent.width


        DetailListItem {
            icon: "call-start"
            communication: personData.person.contactCustomProperty("phoneNumber")
            description: "Mobile private"
        }
        DetailListItem {
            icon: "mail-message-new"
            communication: personData.person.contactCustomProperty("phoneNumber")
        }
    }
}
