#!/bin/bash
if [ -f "$HOME/.forcelogout" ]; then
    rm "$HOME/.forcelogout";
    pkill -9 -u "$USER"
fi