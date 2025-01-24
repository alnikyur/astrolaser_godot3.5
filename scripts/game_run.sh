#!/bin/bash
# PORTMASTER: mygame.zip, MyGame.sh

XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

if [ -d "/opt/system/Tools/PortMaster/" ]; then
  controlfolder="/opt/system/Tools/PortMaster"
elif [ -d "/opt/tools/PortMaster/" ]; then
  controlfolder="/opt/tools/PortMaster"
elif [ -d "$XDG_DATA_HOME/PortMaster/" ]; then
  controlfolder="$XDG_DATA_HOME/PortMaster"
else
  controlfolder="/roms/ports/PortMaster"
fi

source $controlfolder/control.txt
source $controlfolder/device_info.txt
get_controls

GAMEDIR="/userdata/roms/ports/astrolaser"

export XDG_DATA_HOME="$GAMEDIR/conf"
export XDG_CONFIG_HOME="$GAMEDIR/conf"
export LD_LIBRARY_PATH="$GAMEDIR/libs:$LD_LIBRARY_PATH"

mkdir -p "$XDG_DATA_HOME"
mkdir -p "$XDG_CONFIG_HOME"

exec > >(tee "$GAMEDIR/log.txt") 2>&1

cd $GAMEDIR

GAME_FILE="game.arm"

if [ ! -f "$GAME_FILE" ]; then
  echo "Game file not found: $GAME_FILE"
  exit 1
fi

$GPTOKEYB "game" &

# Запускаем игру
./$GAME_FILE

$ESUDO kill -9 $(pidof gptokeyb)
$ESUDO systemctl restart oga_events &

printf "\033c" > /dev/tty0