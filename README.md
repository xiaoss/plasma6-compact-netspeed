# Compact NetSpeed for Plasma 6 (实时网络流量小部件)

A minimalist, compact network speed monitor widget designed for KDE Plasma 6 top bars and panels.

专为 KDE Plasma 6 顶栏/任务栏打造的极简上下箭头文字网速小部件。

## Features (特性)

- **Vertical Stacked (上下叠加)**: 上行显示上传（`↑`），下行显示下载（`↓`），紧凑垂直居中。
- **No Line Chart / Minimalist (极简无图表)**: 替代原生臃肿的折线图，纯文字箭头展示。
- **Monospace Alignment (等宽对齐)**: 采用等宽数字字体分列排版，数值跳动时不产生任何横向抖动。
- **Zero Configuration (即插即用)**: 原生接入 KDE 6 官方传感器系统（`org.kde.ksysguard.sensors`），零额外依赖，极低系统资源占用。
- **System Monitor Integration (系统监视器联动)**: 悬停显示详细 ToolTip，单击即可唤起系统监视器。

## Installation (安装)

### Method 1: Using kpackagetool6 (命令行安装)
```bash
kpackagetool6 -t Plasma/Applet -i compactnetspeed.plasmoid
# 如果已有旧版需要升级：
kpackagetool6 -t Plasma/Applet -u compactnetspeed.plasmoid
```

### Method 2: Manual copy (手动安装)
将整个目录克隆或解压至：
`~/.local/share/plasma/plasmoids/org.kde.plasma.compactnetspeed/`

然后刷新 Plasma 缓存：
```bash
kbuildsycoca6
systemctl --user restart plasma-plasmashell
```

## License
GPL-2.0+
