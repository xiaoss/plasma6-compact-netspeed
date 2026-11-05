import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.kirigami as Kirigami
import org.kde.ksysguard.sensors as Sensors

PlasmoidItem {
    id: root

    Kirigami.Theme.colorSet: Kirigami.Theme.Window
    Kirigami.Theme.inherit: true

    implicitWidth: 62
    implicitHeight: 20

    Layout.minimumWidth: 58
    Layout.preferredWidth: 62
    Layout.fillHeight: true

    Plasmoid.backgroundHints: PlasmaCore.Types.DefaultBackground

    Plasma5Support.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: function(source, data) {
            disconnectSource(source)
        }
    }

    function openSystemMonitor() {
        executable.connectSource("plasma-systemmonitor")
    }

    Sensors.Sensor {
        id: upSensor
        sensorId: "network/all/upload"
        updateRateLimit: 1000
    }

    Sensors.Sensor {
        id: downSensor
        sensorId: "network/all/download"
        updateRateLimit: 1000
    }

    property real upSpeed: 0
    property real downSpeed: 0

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            root.upSpeed = (upSensor.value !== undefined && !isNaN(upSensor.value) && upSensor.value > 0) ? upSensor.value : 0;
            root.downSpeed = (downSensor.value !== undefined && !isNaN(downSensor.value) && downSensor.value > 0) ? downSensor.value : 0;
        }
    }

    function formatVal(bytes) {
        if (!bytes || bytes <= 0) return "0.0";
        if (bytes < 1024) return Math.round(bytes).toString();
        if (bytes < 1024 * 1024) {
            let kb = bytes / 1024;
            return kb >= 100 ? kb.toFixed(0) : kb.toFixed(1);
        }
        if (bytes < 1024 * 1024 * 1024) {
            let mb = bytes / (1024 * 1024);
            return mb >= 100 ? mb.toFixed(0) : mb.toFixed(1);
        }
        let gb = bytes / (1024 * 1024 * 1024);
        return gb.toFixed(1);
    }

    function formatUnit(bytes) {
        if (!bytes || bytes <= 0) return "KB/s";
        if (bytes < 1024) return "B/s";
        if (bytes < 1024 * 1024) return "KB/s";
        if (bytes < 1024 * 1024 * 1024) return "MB/s";
        return "GB/s";
    }

    readonly property string upValStr: formatVal(upSpeed)
    readonly property string upUnitStr: formatUnit(upSpeed)
    readonly property string downValStr: formatVal(downSpeed)
    readonly property string downUnitStr: formatUnit(downSpeed)

    component SpeedView: Item {
        id: viewRoot
        anchors.fill: parent

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0

            // 上传行（↑）
            RowLayout {
                spacing: 2
                Layout.fillHeight: false
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                implicitHeight: 9

                PlasmaComponents.Label {
                    text: "↑"
                    font.pixelSize: 8
                    font.bold: true
                    color: Kirigami.Theme.textColor
                    opacity: 0.9
                    lineHeight: 1.0
                    verticalAlignment: Text.AlignVCenter
                }

                PlasmaComponents.Label {
                    text: root.upValStr
                    font.pixelSize: 8
                    font.family: "Noto Sans Mono, DejaVu Sans Mono, monospace"
                    font.features: { "tnum": 1 }
                    color: Kirigami.Theme.textColor
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    lineHeight: 1.0
                    Layout.preferredWidth: 20
                }

                PlasmaComponents.Label {
                    text: root.upUnitStr
                    font.pixelSize: 7
                    font.family: "Noto Sans Mono, DejaVu Sans Mono, monospace"
                    color: Kirigami.Theme.textColor
                    opacity: 0.8
                    verticalAlignment: Text.AlignVCenter
                    lineHeight: 1.0
                    Layout.preferredWidth: 24
                }
            }

            // 下载行（↓）
            RowLayout {
                spacing: 2
                Layout.fillHeight: false
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                implicitHeight: 9

                PlasmaComponents.Label {
                    text: "↓"
                    font.pixelSize: 8
                    font.bold: true
                    color: Kirigami.Theme.textColor
                    opacity: 0.9
                    lineHeight: 1.0
                    verticalAlignment: Text.AlignVCenter
                }

                PlasmaComponents.Label {
                    text: root.downValStr
                    font.pixelSize: 8
                    font.family: "Noto Sans Mono, DejaVu Sans Mono, monospace"
                    font.features: { "tnum": 1 }
                    color: Kirigami.Theme.textColor
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    lineHeight: 1.0
                    Layout.preferredWidth: 20
                }

                PlasmaComponents.Label {
                    text: root.downUnitStr
                    font.pixelSize: 7
                    font.family: "Noto Sans Mono, DejaVu Sans Mono, monospace"
                    color: Kirigami.Theme.textColor
                    opacity: 0.8
                    verticalAlignment: Text.AlignVCenter
                    lineHeight: 1.0
                    Layout.preferredWidth: 24
                }
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton
            onClicked: {
                root.openSystemMonitor()
            }
            ToolTip.visible: containsMouse
            ToolTip.delay: 300
            ToolTip.text: "实时网络流量\n↑ 上传: " + root.upValStr + " " + root.upUnitStr + "\n↓ 下载: " + root.downValStr + " " + root.downUnitStr
        }
    }

    SpeedView {}
    compactRepresentation: SpeedView {}
}
