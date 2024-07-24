// SPDX-FileCopyrightText: 2021 - 2022 UnionTech Software Technology Co., Ltd.
//
// SPDX-License-Identifier: LGPL-3.0-or-later

import QtQuick 2.11
import QtQuick.Layouts 1.11
import org.deepin.dtk 1.0 as D
import org.deepin.dtk.style 1.0 as DS
import org.deepin.dtk.private 1.0 as P

Control {
    id: control

    default property alias buttons: btnGroup.buttons
    property alias group: btnGroup

    D.ColorSelector.hovered: false
    padding: DS.Style.buttonBox.padding

    ButtonGroup {
        id: btnGroup
    }
    contentItem: RowLayout {
        spacing: DS.Style.buttonBox.spacing
        children: control.buttons
    }

    background: BoxPanel {
        implicitWidth: DS.Style.buttonBox.width
        implicitHeight: DS.Style.buttonBox.height
        backgroundFlowsHovered: D.ColorSelector.family === D.Palette.CrystalColor
        outsideBorderColor: null
        color2: color1
    }

    ParallelAnimation {
        running:  btnGroup.checkedButton && (btnGroup.checkedButton.x !== backgroundPanel.x || btnGroup.checkedButton.y !== backgroundPanel.y)
        NumberAnimation { target: backgroundPanel; property: "x"; to: btnGroup.checkedButton.x; duration: 200 }
        NumberAnimation { target: backgroundPanel; property: "y"; to: btnGroup.checkedButton.y; duration: 200 }
        NumberAnimation { target: backgroundPanel; property: "width"; to: btnGroup.checkedButton.width; duration: 200 }
        NumberAnimation { target: backgroundPanel; property: "height"; to: btnGroup.checkedButton.height; duration: 200 }
    }

    P.ButtonPanel {
        id: backgroundPanel
        visible: btnGroup.checkedButton
        implicitWidth: btnGroup.checkedButton.width
        implicitHeight: btnGroup.checkedButton.height
        button: control
        outsideBorderColor: null
        color1: D.Palette {
            normal {
                common: Qt.rgba(0, 0, 0, 0.2)
            }
        }
        color2: color1
    }
}
