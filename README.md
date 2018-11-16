# Manjaro dotfiles

Files in `etc/` and `usr/` are not actually located in the home folder. Follow the steps below

- Copy the following file to the specified location
	- `etc/default/grub` to `/etc/default/grub` then run `sudo update-grub`
	- `etc/ssh/sshd_config` to `/etc/ssh/sshd_config`
	- `etc/locale.conf` to `/etc/locale.conf` or just set the proper locale
        - Uncomment the locale to be generate in `/etc/locale.gen`
        - Generate with `sudo locale-gen`
	- `usr/share/X11/xorg.conf.d` to `/usr/share/X11/` or just copy the content
	- `usr/share/conky/` to `/usr/share/` (now disabled in `~/.i3/config/`)

All the other configuration files are in the home folder

- Copy `.i3/` to `~/.i3/`
- Copy `.Xresources` to `~/.Xresources/` then run `xrdb ~/.Xresources`

## Shell

- Link `.vimrc` to `~/.vimrc`
- Copy content of `.vim/` to `~/.vim/`
- Install **Oh-My-Zsh**
- Link `.zshrc` to `~/.zshrc`
- Install **terminator**
- Copy `.config/terminator` to `~/.config/terminator/`

### Vim plugins
- [vim-netranger](https://github.com/ipod825/vim-netranger)

### Additional packages
- [termtosvg](https://github.com/nbedos/termtosvg)
- [todo.txt](https://github.com/todotxt/todo.txt-cli)

## Touchscreen

- Install **touchegg**: dowload the following **AUR** packages and `makepkg -si`
	- `git clone https://aur.archlinux.org/touchegg.git` (required `geis`)
	- `git clone https://aur.archlinux.org/geis.git` (required `grail`)
	- `git clone https://aur.archlinux.org/grail.git` (required `frame`)
	- `git clone https://aur.archlinux.org/frame.git`
- Copy `touchegg.conf` to `~/.config/touchegg/`
- Create `~/.xprofile` and add `touchegg &`
- Add the following line to `~/.xinitrc`
	- `[ -f ~/.xprofile ] &&  . ~/.xprofile`

### touchegg.conf

```
<touchégg>
  <settings>
    <property name="composed_gestures_time">111</property>
  </settings>
  <application name="All">
    <gesture type="DRAG" fingers="1" direction="ALL">
      <action type="DRAG_AND_DROP">BUTTON=1</action>
    </gesture>
    <gesture type="DRAG" fingers="3" direction="UP">
      <action type="MAXIMIZE_RESTORE_WINDOW"></action>
    </gesture>
    <gesture type="DRAG" fingers="3" direction="DOWN">
      <action type="MINIMIZE_WINDOW"></action>
    </gesture>
    <gesture type="DRAG" fingers="2" direction="ALL">
      <action type="SCROLL">SPEED=7:INVERTED=true</action>
    </gesture>
    <gesture type="PINCH" fingers="2" direction="IN">
      <action type="SEND_KEYS">Control+minus</action>
    </gesture>
    <gesture type="PINCH" fingers="2" direction="OUT">
      <action type="SEND_KEYS">Control+plus</action>
    </gesture>
    <gesture type="TAP" fingers="3" direction="">
      <action type="MOUSE_CLICK">BUTTON=2</action>
    </gesture>
    <gesture type="TAP" fingers="2" direction="">
      <action type="MOUSE_CLICK">BUTTON=3</action>
    </gesture>
    <gesture type="TAP" fingers="1" direction="">
      <action type="MOUSE_CLICK">BUTTON=1</action>
    </gesture>
  </application>
</touchégg>
```

## Touchpad

- Install **xf86-input-libinput**
	- Copy `40-libinput.conf` to `/etc/X11/xorg.conf.d/`

### 40-libinput.conf

```
Section "InputClass"
        Identifier "libinput touchpad catchall"
        MatchIsTouchpad "on"
        MatchDevicePath "/dev/input/event*"
        Driver "libinput"
        Option "NaturalScrolling" "true"
        Option "AccelSpeed" "0.7"
        Option "AccelProfile" "adaptive"
        Option "Tapping" "true"
        Option "TappingButtonMap" "lrm"
EndSection
```

## Notes

### Audio

Should works with just `alsa` installed. Currently it works with the following packages
```
alsa-lib 1.1.7-1
alsa-plugins 1.1.7-3
alsa-tools 1.1.7-1
alsa-utils 1.1.7-1
zita-alsa-pcmi 0.3.2-1
```

#### Possible fixes/patches

Detect sound card with `cat /proc/asound/cards`. That gives the following output

```
 0 [HDMI           ]: HDA-Intel - HDA Intel HDMI
                      HDA Intel HDMI at 0xf0530000 irq 48
 1 [PCH            ]: HDA-Intel - HDA Intel PCH
                      HDA Intel PCH at 0xf0534000 irq 44
```

and set as default card in `/etc/asound.conf`

```
pcm.!default {
  type hw
  card PCH
}

ctl.!default {
  type hw
  card PCH
}
```

To unmute the sound use the keybind `Mod1 + XF86SoundMute` set in `.i3/config`

If the output of `pulseaudio` shows `E: [pulseaudio] main.c: pa_pid_file_create() failed.` try to add **user** to **audio** group with `sudo usermod -aG audio your_user_name`

Using both `pulseaudio` and `alsamixer`. Get default output device with `pacmd list-sinks | grep -e 'name:' -e 'index:'` 

List all available cards with `aplay -L`

```
...
pulse
    PulseAudio Sound Server
default
    Default ALSA Output (currently PulseAudio Sound Server)
...
```
and test if they are working with `speaker-test -D NAME -c 2` where the name could be, in this specific case, "pulse" or "default".

[Alsa](https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture)

[PulseAudio](https://wiki.archlinux.org/index.php/PulseAudio)

### Screen resolution

- Generate new resolution
	- `cvt 2304 1296` - Output: `Modeline "2304x1296_60.00"  251.25  2304 2464 2712 3120  1296 1299 1304 1344 -hsync +vsync`
- Create new resolution
	- `xrandr --newmode "2304x1296_60.00" 251.25 2304 2464 2712 3120 1296 1299 1304 1344 -hsync +vsync`
- Add resolution to output device
	- Find connected device `xrandr | grep " connected" | sed 's/ connected.*//'` (eDP1)
	- `xrandr --addmode eDP1 2304x1296_60.00`
- Change resolution
	- `xrandr -s 2304x1296`

### Keybinds

This might require **xbindkeys**. Now the touch-function keys are set to

- Mod1 + SoundMute: unmute the sound using amixer
- Search: launch firefox
- Explorer: launch ranger (NB: to use vim as default editor instead of nano, the only workaround was `sudo rm /usr/bin/nano; ln -s /usr/bin/vim /usr/bin/nano` keep it in mind)
- Tools: launch morc menu

