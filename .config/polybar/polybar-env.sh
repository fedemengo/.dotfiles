#export THEME_COLOR="#ff33ff" 00ff00
export THEME_COLOR=${THEME_COLOR:-"#00ff00"}

export POLYBAR_DATE="%a %{F$THEME_COLOR}%m.%d%{F-}"

export POLYBAR_NETWORK="%{F$THEME_COLOR}⇣%{F-} %downspeed:7% %{F$THEME_COLOR}⇡%{F-} %upspeed:7% | %{F$THEME_COLOR}@%{F-} %local_ip%"

export POLYBAR_FS="%{F$THEME_COLOR}%mountpoint%%{F-}: %free%"
