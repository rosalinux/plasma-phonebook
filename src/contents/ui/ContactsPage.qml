/*
 * SPDX-FileCopyrightText: 2015 Martin Klapetek <mklapetek@kde.org>
 * SPDX-FileCopyrightText: 2019 Linus Jahn <lnj@kaidan.im>
 * SPDX-FileCopyrightText: 2019 Jonah Brüchert <jbb@kaidan.im>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.15
import QtQuick.Controls 2.0 as Controls
import QtQuick.Layouts 1.7
import "Utils.js" as Utils
import org.kde.kirigami 2.12 as Kirigami
import org.kde.people 1.0 as KPeople
import org.kde.phonebook 1.0

Kirigami.ScrollablePage {
    id: page

    function calculateHeight() {
        return footerRectangle.y - (allLabel.y + allLabel.height + 2 * contactsList.spacing);
    }

    width: 720
    height: 1600
    leftPadding: 0
    rightPadding: 0
    topPadding: 0

    Rectangle {
        color: "#C4C4C4"

        Rectangle {
            id: searchArea

            x: 50
            y: 129
            radius: 10
            width: 620
            height: 96
            color: "#CFCFCF"

            Rectangle {
                id: searchIcon

                signal clicked()

                x: 22
                y: 25
                opacity: mouseArea.pressed ? 0.2 : 1
                onClicked: {
                    filterModel.setFilterFixedString(searchField.text);
                }

                Kirigami.Icon {
                    width: 46
                    height: 46
                    source: "qrc:/icon-search.png"

                    MouseArea {
                        id: mouseArea

                        anchors.fill: parent
                        onClicked: {
                            searchIcon.clicked();
                        }
                    }

                }

            }

            Controls.TextField {
                id: searchField

                onTextChanged: filterModel.setFilterFixedString(text)
                color: "#444444"
                placeholderText: i18n("Поиск контактов")
                text: ""
                font.family: "Manrope"
                font.pixelSize: 26
                x: 144
                y: 25
                width: 340
                onAccepted: {
                    addressee.formattedName = text;
                }

                Connections {
                    function onSave() {
                        name.accepted();
                    }

                    target: root
                }

                background: Rectangle {
                    color: "#CFCFCF"
                }

            }

            Rectangle {
                x: 555
                y: 25

                Kirigami.Icon {
                    width: 46
                    height: 46
                    source: "qrc:/icon-dots.png"
                }

            }

        }

        Rectangle {
            id: allLabel

            width: 183
            height: 28
            color: "#EAE9E9"
            anchors.top: searchArea.bottom
            anchors.left: searchArea.left
            anchors.topMargin: 5

            Controls.Label {
                color: "#444444"
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                font.family: "Manrope"
                font.pixelSize: 20
                text: {
                    i18n("Всего ") + contactsList.count + i18n(" контакт") + Utils.getSuffix(contactsList.count);
                }
            }

        }

        ListView {
            id: contactsList

            property bool delegateSelected: false
            property string numberToCall

            parent: footerRectangle
            anchors.topMargin: 25
            anchors.bottom: parent.top
            x: 0
            spacing: 20
            width: 720
            height: calculateHeight()
            reuseItems: true
            currentIndex: -1
            clip: true

            Kirigami.PlaceholderMessage {
                anchors.centerIn: parent
                text: i18n("Нет данных")
                visible: contactsList.count === 0
            }

            model: KPeople.PersonsSortFilterProxyModel {
                id: filterModel

                filterRole: Qt.DisplayRole
                sortRole: Qt.DisplayRole
                filterCaseSensitivity: Qt.CaseInsensitive
                Component.onCompleted: {
                    pageStack.globalToolBar.preferredHeight = 0;
                    sort(0);
                }

                sourceModel: KPeople.PersonsModel {
                    id: contactsModel
                }

            }

            delegate: ContactListItem {
                x: 50
                height: 132
                width: 620
                name: model && model.display
                phone: model && model.phoneNumber
                avatarIcon: model && model.decoration
                padding: 10
                onClicked: {
                    pageStack.push("qrc:/DetailPage.qml", {
                        "personUri": model.personUri
                    });
                    ContactController.lastPersonUri = model.personUri;
                }

                background: Rectangle {
                    width: parent.width
                    height: parent.height
                    radius: 10
                    implicitWidth: page.width
                    implicitHeight: 40
                }

            }

        }

        Rectangle {
            parent: footerRectangle
            anchors.bottom: parent.top
            anchors.bottomMargin: 198
            anchors.left: parent.left
            anchors.leftMargin: 499
            z: 1

            Kirigami.Icon {
                width: 187
                height: 164
                source: mouseAreaAddBtn.pressed ? "qrc:/btn-contact-plusgr.png" : "qrc:/btn-contact-plus.png"

                MouseArea {
                    id: mouseAreaAddBtn

                    anchors.fill: parent
                    onClicked: {
                        pageStack.pushDialogLayer(Qt.resolvedUrl("AddContactPage.qml"), {
                            "state": "create"
                        });
                    }
                }

            }

        }

    }

    footer: Rectangle {
        id: footerRectangle

        x: 0
        width: 720
        height: 187
        color: "#437431"

        Rectangle {
            x: 70
            y: 21

            Kirigami.Icon {
                width: 220
                height: 150
                source: "qrc:/btn-contrecent.png"
                color: "white"
            }

        }

        Rectangle {
            x: 431
            y: 21

            Kirigami.Icon {
                width: 220
                height: 150
                source: "qrc:/btn-contgr.png"
                color: "white"
            }

        }

    }

}
