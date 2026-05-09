#!/bin/bash

# Ręcznie budujemy listę z folderów binarnych
# 1. Pobieramy pliki z /usr/bin, /bin itd.
# 2. Usuwamy duplikaty
# 3. Wybieramy przez fzf
cmd=$(ls /usr/bin /bin /usr/local/bin 2>/dev/null | sort -u | fzf --height 40% --reverse --border --prompt="Search: ")

if [ -n "$cmd" ]; then
    # Sprawdzamy czy to aplikacja GUI (np. chrome) czy terminalowa
    # Uruchamiamy w tle
    nohup "$cmd" >/dev/null 2>&1 &
    disown
    clear
    echo "Running"
    sleep 1
    clear
fi

