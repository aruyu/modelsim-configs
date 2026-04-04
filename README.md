# ModemSim Configs

## ModelSim configs & installation scripts for Linux

* vsim (ModelSim)

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/aruyu/modelsim-configs/master/tools/install_vsim.sh)"
```

## Issues

> [!TIP]
> If you are running vsim on **Gnome Wayland with *HiDPI display***,
> your GUI would be too small to see. *(older GTK2 does not support HiDPI)*
>
> Check default value from 'org.gnome.mutter experimental-features',
> and remove **'xwayland-native-scaling'** field.

```bash
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
```
