# dotfiles

## TODO

Write a script to automatically setup the environment

- Download repo
- Install dependencies (identify deps first)
- Copy, move, create, link all required files

Also, the script to setup dotfiles should account for different OSes

<details>
<summary><b>Basic setup</b></summary>

Create basic folder structure

- `for dir in archive classes downloads media/{music,pictures} projects workspace; do mkdir $dir; done`

Files in `etc/` and `usr/` are not actually located in the home folder. Clone the repo, then `cd dotfiles` and then follow these steps

- `sudo pacman -Syu`
- `sudo pacman -S yay zsh termite firefox polybar`
- `sudo chsh; chsh`
- `yay -S polybar code megasync touchegg xbindkeys`

- `sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"`
- `git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions`
- `git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k`

- `cp etc/default/grub /etc/default/grub; sudo update-grub`
- `cp etc/ssh/sshd_config /etc/ssh/sshd_config`
- `cp etc/locale.conf /etc/locale.conf` or just set the proper locale
  - Uncomment the locale to be generate (`en_US.UTF-8 UTF-8`) in `/etc/locale.gen`
  - Generate with `sudo locale-gen`
- `cp -r usr/share/X11/xorg.conf.d /usr/share/X11/` or just copy the content
- `cp -r usr/share/conky /usr/share/` (now disabled in `~/.config/i3/config/`)

All the other configuration files are in the home folder

- YET TO TEST `for file in .dotfiles/.config/*; do ln -s $file .$(basename $file); done`
- `cp .Xresources ~/; xrdb ~/.Xresources`
- `echo "[ -f ~/.xprofile ] && . ~/.xprofile" >> ~/.xinitrc`
- `ln -s .xprofile ~/.xprofile` if necessary (`rm -rf ~/.xprofile`)
- `ln -s ~/.dotfiles/.dmenurc ~/.dmenurc`

Some stuff to install

- `sudo pacman -S unzip docker docker-compose go davfs2 yarn npm transmission-cli openvpn gdb colordiff ifconfig zathura dpkg httpie openssh`
- `yay -S dpkg`
  </details>

## Shell

<details>
<summary><b>Configuration</b></summary>

Install **zsh** (and also **Oh-My-Zsh**), **vim**, **terminator/termite** if necessary, then

- `cp -r .vim ~/.vim/`
- `ln -s .vimrc ~/.vimrc`
- `ln -s .zshrc ~/.zshrc`

### Binaries

Symlink user binaries

- `for f in $(find bin -type f); do cp "$f" "${HOME}/.local/$f"; done`

### Install fonts

- `git clone https://github.com/powerline/fonts.git --depth=1`
- `./fonts/install.sh && rm -rf fonts`

#### Vim plugins

- [vim-netranger](https://github.com/ipod825/vim-netranger)

#### Additional packages

- [termtosvg](https://github.com/nbedos/termtosvg)
- [todo.txt](https://github.com/todotxt/todo.txt-cli)
- **downgrade** - `sudo pacman -Syu downgrade`
- **xbacklight** - `pacman -Syu xorg-xbacklight`
  </details>

## Touchscreen

<details>
<summary><b>Configuration</b></summary>

#### [EDIT 05/11/2020]

`touchegg-1.1.1.1` is not available anymore and the new version doesn't support DRAG (2 fingers gestures). So it's necessary to downgrade to 1.1.1.1 to keep the old configuration

- Add **arcanis** repo to `/etc/pacman.conf`

```
[arcanisrepo]
Server = http://repo.arcanis.me/repo/$arch
```
- Update packages database `pacman -Syyu`
- Install using pacman `pacman -S touchegg`
- Remove **arcanis** and update again

#### [BEFORE 27/09/2020]

- `yay -Syu touchegg`
- Double check that `~/.config/touchegg/touchegg.conf` exists, or `ln -s ~/.dotfiles/.config/touchegg ~/.config/`
- Load **touchegg** with `echo "touchegg &" >> ~/.xprofile` or just load`~/.xprofile` from `~/.xinitrc`

### `touchegg.conf`

<details>
<summary><b>More</b></summary>

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

</details>
</details>

## Fingerprint

<details>
<summary><b>Configuration</b></summary>

Currenlty using `fingerprint-gui` with `libfprint` (only v. 0.8.2-1 works). In case of upgrade just downgrade with `DOWNGRADE_FROM_ALA=1 downgrade libfprint`

</details>

## Touchpad

<details>
<summary><b>Configuration</b></summary>

- Install **xf86-input-libinput**
- `cp 40-libinput.conf /etc/X11/xorg.conf.d/`

### `40-libinput.conf`

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

</details>

## Audio

<details>
<summary><b>Configuration</b></summary>

- `sudo usermod -aG audio $(whoami)`
- `sudo install_pulse`
- `sudo pacman -S pavucontrol`
- Add `options snd_hda_intel index=1` to `/etc/modprobe.d/alsa-base.conf`
- Set default input/output for pulse audio [here](https://wiki.archlinux.org/index.php/PulseAudio/Examples#Set_the_defaulting_output_source)
- Make sure only one instance of `pulseaudio` is running
  - Assuming `/usr/lib/systemd/user/pulseaudio.service` is enabled with
  - `systemctl --user enable pulseaudio`
  - `systemctl --user start pulseaudio`
  - Keep `exec --no-startup-id pulseaudio` commented out

No need for `/etc/asound.conf` or put the following configuration

```
# Use PulseAudio by default
pcm.!default {
  type pulse
  fallback "sysdefault"
  hint {
    show on
    description "Default ALSA Output (currently PulseAudio Sound Server)"
  }
}

ctl.!default {
  type pulse
  fallback "sysdefault"
}

# vim:set ft=alsaconf:
```

### Audio keybinds

- `xbindkeys -d > ~/.xbindkeysrc`

Add mute/unmute bind

```
echo "# Mute volume
"pactl set-sink-mute @DEFAULT_SINK@ toggle"
   XF86AudioMute
" >> ~/.xbindkeysrc

```

</details>

## Firefox

<details>
<summary><b>Configuration</b></summary>

- Edit `about:config`
  - `layout.css.devPixelsPerPx` to `1.4`
  - `toolkit.legacyUserProfileCustomizations.stylesheets` to `true`
- `ln -s .dotfiles/.mozilla/firefox ~/.mozilla/firefox/`

</details>




## Notes

<details>
<summary><b>Audio</b></summary>

Should works with both `pulseaudio` and `alsa` installed

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

and set as default card in `/etc/asound.conf` **NOT WORKING ANYMORE**

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

To unmute the sound use the keybind

- ~`Mod1 + XF86SoundMute` set in `.config/i3/config`~
- `"pactl set-sink-mute @DEFAULT_SINK@ toggle"
   XF86AudioMute`


If the output of `pulseaudio` shows `E: [pulseaudio] main.c: pa_pid_file_create() failed.` try adding **user** to **audio** group with `sudo usermod -aG audio $(whoami)`

Using both `pulseaudio` and `alsamixer`.

- Get default output device with `pacmd list-sinks | grep -e 'name:' -e 'index:'`
- Get default input device with `pacmd list-sources | grep -e 'name:' -e 'index:'`

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

- [Alsa](https://wiki.archlinux.org/index.php/Advanced_Linux_Sound_Architecture)
- [PulseAudio](https://wiki.archlinux.org/index.php/PulseAudio)

</details>

<details>
<summary><b>Screen resolution</b></summary>

- Generate and create new resolution - `xrand --newmode $(cvt 2304 1296 | sed '2 !d;s/Modeline\s//g')`
- Add resolution to output device - Find connected device `xrandr | sed -n -e '/\sconnected/p' | awk -F' ' '{print $1}'` (in my case **eDP1**) - `xrandr --addmode eDP1 2304x1296_60.00`
- Change resolution - `xrandr -s 2304x1296`

</details>

<details>
<summary><b>Keybinds</b></summary>

This might require **xbindkeys**. Now the touch-function keys are set to

- `Search`: launch firefox
- `Explorer`: launch ranger
- `Tools`: launch morc menu
- `Display`: toogle display brightness

</details>

<details>
<summary><b>Misc</b></summary>

- [Arch on X1 carbon](<https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_2)>)
- Install **Postman**
  - Download the executable and place it in `${HOME}/.app/`
  - Create link `sudo ln -s ${HOME}/.dotfiles/.script/postman /usr/bin/postman`

</details>
