/*
 *   SPDX-FileCopyrightText: 2019 Nicolas Fella <nicolas.fella@gmx.de>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

import Qt.labs.platform 1.1
import QtQuick 2.6
import QtQuick.Controls 2.2 as Controls
import QtQuick.Layouts 1.2
import QtQuick.Templates 2.15 as T
import "Utils.js" as Utils
import org.kde.kirigami 2.4 as Kirigami
import org.kde.kirigamiaddons.dateandtime 0.1 as KirigamiDateTime
import org.kde.people 1.0 as KPeople
import org.kde.phonebook 1.0

Kirigami.ScrollablePage {
    id: page_root

    property QtObject person
    property var addressee: ContactController.emptyAddressee()

    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    states: [
        State {
            name: "create"

            PropertyChanges {
                target: root
            }

        },
        State {
            name: "update"

            PropertyChanges {
                target: root
            }

        }
    ]

    Rectangle {
        id: root

        property var pendingPhoneNumbers: page_root.addressee.phoneNumbers
        property var pendingEmails: page_root.addressee.emails
        property var pendingImpps: page_root.addressee.impps
        property var pendingPhoto: page_root.addressee.photo

        signal save()

        width: 720
        height: 1420
        color: "#EAE9E9"
        onSave: {
            page_root.addressee.formattedName = Utils.makeFormattedName(name.text, father_name.text, sure_name.text);
            if (toAddPhone.text.length > 0) {
                var numbers = root.pendingPhoneNumbers;
                if (numbers.length == 0)
                    numbers.push(ContactController.createPhoneNumber(toAddPhone.text));
                else
                    numbers[0].number = toAddPhone.text;
                root.pendingPhoneNumbers = numbers;
                page_root.addressee.phoneNumbers = root.pendingPhoneNumbers;
            }
            if (toAddEmail.text.length > 0) {
                var emails = root.pendingEmails;
                if (emails.length == 0)
                    emails.push(ContactController.createEmail(toAddEmail.text));
                else
                    emails[0].email = toAddEmail.text;
                root.pendingEmails = emails;
                page_root.addressee.emails = root.pendingEmails;
            }
            var birth = Date.fromLocaleString(Qt.locale(), toAddBirthday.text, "d.MM.yyyy");
            page_root.addressee.note = toAddBirthday.text;
            switch (page_root.state) {
            case "create":
                if (!KPeople.PersonPluginManager.addContact({
                    "vcard": ContactController.addresseeToVCard(addressee)
                }))
                    console.warn("could not create contact");

                break;
            case "update":
                if (!page_root.person.setContactCustomProperty("vcard", ContactController.addresseeToVCard(addressee)))
                    console.warn("Could not save", addressee.url);

                break;
            }
            page_root.closeDialog();
        }
        enabled: !page_root.person || page_root.person.isEditable

        Rectangle {
            x: 96
            y: 214
            opacity: mouseAreaBack.pressed ? 0.5 : 1

            Kirigami.Icon {
                width: 90
                height: 60
                source: "qrc:/icon-arrow.png"

                MouseArea {
                    id: mouseAreaBack

                    anchors.fill: parent
                    onClicked: {
                        page_root.closeDialog();
                    }
                }

            }

        }

        Rectangle {
            x: 95
            y: 284
            width: 92
            height: 28
            color: "#EAE9E9"

            Controls.Label {
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                font.family: "Manrope"
                font.pixelSize: 20
                text: {
                    i18n("Контакты");
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        page_root.closeDialog();
                    }
                }

            }

        }

        Rectangle {
            x: 274
            y: 177
            width: 172
            height: 172
            color: "#999999"
            radius: 10

            Kirigami.Icon {
                x: 63.45
                y: 66.27
                width: 42
                height: 42
                source: "qrc:/icon-plus.png"
                color: "white"
            }

        }

        Rectangle {
            x: 265
            y: 375
            width: 190
            height: 30
            color: "#EAE9E9"

            Controls.Label {
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                font.family: "Manrope"
                font.pixelSize: 26
                text: {
                    i18n("Добавить фото");
                }
            }

        }

        Rectangle {
            x: 550
            y: 214
            opacity: mouseAreaReject.pressed ? 0.5 : 1

            Kirigami.Icon {
                width: 60
                height: 60
                source: "qrc:/icon-cross.png"

                MouseArea {
                    id: mouseAreaReject

                    anchors.fill: parent
                    onClicked: {
                        page_root.closeDialog();
                    }
                }

            }

        }

        Rectangle {
            x: 508
            y: 284
            width: 153
            height: 56
            color: "#EAE9E9"

            Controls.Label {
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                font.family: "Manrope"
                font.pixelSize: 20
                text: {
                    i18n("Закрыть\nбез сохранения");
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        page_root.closeDialog();
                    }
                }

            }

        }

        ColumnLayout {
            id: form

            y: 45
            spacing: 37

            Rectangle {
                x: 40
                y: 479

                Kirigami.Icon {
                    width: 48
                    height: 51
                    source: "qrc:/icon-person.png"
                }

            }

            Rectangle {
                x: 100
                y: 457

                Controls.TextField {
                    id: name

                    placeholderText: i18n("Имя")
                    Layout.leftMargin: 100
                    text: Utils.parseFormattedName(addressee.formattedName, 0)
                    font.family: "Manrope"
                    font.pixelSize: 26
                    width: 570
                    height: 95

                    Connections {
                        function onSave() {
                            name.accepted();
                        }

                        target: root
                    }

                }

            }

            Rectangle {
                x: 100
                y: 589

                Controls.TextField {
                    id: father_name

                    placeholderText: i18n("Отчество")
                    Layout.leftMargin: 100
                    text: Utils.parseFormattedName(addressee.formattedName, 1)
                    font.family: "Manrope"
                    font.pixelSize: 26
                    width: 570
                    height: 95

                    Connections {
                        function onSave() {
                            father_name.accepted();
                        }

                        target: root
                    }

                }

            }

            Rectangle {
                x: 100
                y: 721

                Controls.TextField {
                    id: sure_name

                    placeholderText: i18n("Фамилия")
                    Layout.leftMargin: 100
                    text: Utils.parseFormattedName(addressee.formattedName, 2)
                    font.family: "Manrope"
                    font.pixelSize: 26
                    width: 570
                    height: 95

                    Connections {
                        function onSave() {
                            sure_name.accepted();
                        }

                        target: root
                    }

                }

            }

            Rectangle {
                x: 44
                y: 883

                Kirigami.Icon {
                    width: 39
                    height: 39
                    source: "qrc:/icon-handset-call.png"
                }

            }

            Rectangle {
                x: 100
                y: 853

                Controls.TextField {
                    id: toAddPhone

                    placeholderText: i18n("Телефон")
                    inputMethodHints: Qt.ImhDialableCharactersOnly
                    font.family: "Manrope"
                    font.pixelSize: 26
                    width: 570
                    height: 95
                    text: page_root.addressee.phoneNumbers.length > 0 ? page_root.addressee.phoneNumbers[0].number : ""
                }

            }

            Rectangle {
                x: 51
                y: 1018

                Kirigami.Icon {
                    width: 28
                    height: 28
                    source: "qrc:/icon-mail.png"
                }

            }

            Rectangle {
                x: 100
                y: 985

                Controls.TextField {
                    id: toAddEmail

                    placeholderText: i18n("Адрес электронной почты")
                    inputMethodHints: Qt.ImhEmailCharactersOnly
                    font.family: "Manrope"
                    font.pixelSize: 26
                    width: 570
                    height: 95
                    text: page_root.addressee.emails.length > 0 ? page_root.addressee.emails[0].email : ""
                }

            }

            Rectangle {
                x: 42
                y: 1142

                Kirigami.Icon {
                    width: 44
                    height: 44
                    source: "qrc:/icon-hb.png"
                }

            }

            Rectangle {
                x: 100
                y: 1117

                Controls.TextField {
                    id: toAddBirthday

                    placeholderText: i18n("День рождения")
                    Layout.leftMargin: 100
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                    font.family: "Manrope"
                    font.pixelSize: 26
                    width: 570
                    height: 95
                    text: addressee.note
                }

            }

            Rectangle {
                x: 310
                y: 1270

                Kirigami.Icon {
                    width: 360
                    height: 125
                    source: mouseAreaSave.pressed ? "qrc:/btn-saveok.png" : "qrc:/btn-save.png"

                    MouseArea {
                        id: mouseAreaSave

                        anchors.fill: parent
                        onClicked: {
                            if ((name.text.trim().length != 0 || name.text.trim().length != 0 || name.text.trim().length) && toAddPhone.text.trim().length != 0)
                                root.save();

                        }
                    }

                }

            }

        }

    }

    background: Rectangle {
        color: "#EAE9E9"
    }

}
