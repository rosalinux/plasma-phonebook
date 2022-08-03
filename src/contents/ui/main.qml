/*
 * SPDX-FileCopyrightText: 2019 Linus Jahn <lnj@kaidan.im>
 * SPDX-FileCopyrightText: 2019 Jonah Brüchert <jbb@kaidan.im>
 *
 * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
 */

import QtQuick 2.1
import QtQuick.Controls 2.0 as Controls
import org.kde.kirigami 2.4 as Kirigami
import org.kde.phonebook 1.0

Kirigami.ApplicationWindow {
    id: root

    pageStack.globalToolBar.preferredHeight: 0
    width: Kirigami.Units.gridUnit * 65
    minimumWidth: Kirigami.Units.gridUnit * 15
    onClosing: ContactController.saveWindowGeometry(root)
    Component.onCompleted: {
    }

    FontLoader {
        id: webFontM

        source: "qrc:/font-manrope-medium"
    }

    ContactImporter {
        id: importer
    }

    pageStack.initialPage: ContactsPage {
    }

    contextDrawer: Kirigami.ContextDrawer {
        id: contextDrawer
    }

}
