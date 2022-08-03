/*
 *   SPDX-FileCopyrightText: 2018 Fabian Riethmayer
 *   SPDX-FileCopyrightText: 2021 Nicolas Fella <nicolas.fella@gmx.de>
 *
 *   SPDX-License-Identifier: LGPL-2.0-or-later
 */

import QtQuick 2.6
import QtQuick.Controls 2.13 as Controls
import QtQuick.Layouts 1.2
import "Utils.js" as Utils
import org.kde.kirigami 2.10 as Kirigami
import org.kde.people 1.0 as KPeople
import org.kde.phonebook 1.0

Kirigami.ScrollablePage {
    id: page

    property string personUri
    property var addressee: ContactController.addresseeFromVCard(personData.person.contactCustomProperty("vcard"))

    function callNumber(number) {
        Qt.openUrlExternally("tel:" + number);
    }

    function sendSms(number) {
        Qt.openUrlExternally("sms:" + number);
    }

    function getName() {
        phone_lbl.text = personData.person.contactCustomProperty("phoneNumber");
        birthday_lbl.text = addressee.note;
        return personData.person.name;
    }

    function openEditor() {
        pageStack.pushDialogLayer(Qt.resolvedUrl("AddContactPage.qml"), {
            "state": "update",
            "person": personData.person,
            "addressee": page.addressee
        });
    }

    Component.onCompleted: {
        pageStack.globalToolBar.preferredHeight = 0;
    }
    width: 720
    height: 1600
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    Kirigami.Theme.colorSet: Kirigami.Theme.View

    KPeople.PersonData {
        id: personData

        personUri: page.personUri
    }

    KPeople.PersonActions {
        id: personActions

        personUri: page.personUri
    }

    Component {
        id: callPopup

        PhoneNumberDialog {
        }

    }

    Rectangle {
        color: "#EAE9E9"

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
                        pageStack.pop();
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
                        pageStack.pop();
                    }
                }

            }

        }

        Rectangle {
            x: 274
            y: 177
            width: 172
            height: 172
            color: Utils.getColorForContact(personData.person.name)
            radius: 10

            Controls.Label {
                x: 28
                y: 22
                width: 115
                height: 118
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                font.family: "Manrope"
                font.pixelSize: 120
                color: "white"
                text: {
                    Utils.getChar(personData.person.name);
                }
            }

        }

        Rectangle {
            x: 563
            y: 225
            opacity: mouseAreaEdit.pressed ? 0.5 : 1

            Kirigami.Icon {
                width: 35
                height: 35
                source: "qrc:/edit.png"

                MouseArea {
                    id: mouseAreaEdit

                    anchors.fill: parent
                    onClicked: {
                        openEditor();
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
                    i18n("Редактировать");
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        openEditor();
                    }
                }

            }

        }

        Rectangle {
            id: info

            x: 50
            y: 475
            width: 620
            height: 120
            color: "#EAE9E9"

            Controls.Label {
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                font.family: "Manrope"
                font.pixelSize: 48
                color: "#444444"
                maximumLineCount: 3
                anchors.horizontalCenter: info.horizontalCenter
                text: getName()
                clip: true
                width: parent.width
                wrapMode: Text.Wrap
                elide: Text.ElideRight
            }

        }

        Rectangle {
            id: phone

            x: 50
            y: 677
            width: 620
            height: 39
            color: "#EAE9E9"

            Controls.Label {
                id: phone_lbl

                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                font.family: "Manrope"
                font.pixelSize: 56
                color: "#444444"
                maximumLineCount: 1
                anchors.horizontalCenter: phone.horizontalCenter
            }

        }

        Rectangle {
            x: 246
            y: 1135

            Kirigami.Icon {
                width: 25.45
                height: 31.09
                source: birthday_lbl.text.length > 0 ? "qrc:/icon-hb.png" : ""
            }

        }

        Rectangle {
            id: birthday

            x: 298
            y: 1140
            width: 181
            height: 30
            color: "#EAE9E9"

            Controls.Label {
                id: birthday_lbl

                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                font.family: "Manrope"
                font.pixelSize: 26
                color: "#444444"
                maximumLineCount: 1
                anchors.horizontalCenter: info.horizontalCenter
            }

        }

        Rectangle {
            x: 158
            y: 1266

            Kirigami.Icon {
                width: 404
                height: 164
                source: mouseAreaCallBtn.pressed ? "qrc:/btn-callgr.png" : "qrc:/btn-call.png"

                MouseArea {
                    id: mouseAreaCallBtn

                    anchors.fill: parent
                    onClicked: {
                        if (phone_lbl.text.length > 0)
                            callNumber(phone_lbl.text);
                        else
                            console.log("WARNING: phone is empty");
                    }
                }

            }

        }

    }

    background: Rectangle {
        color: "#EAE9E9"
    }

}
