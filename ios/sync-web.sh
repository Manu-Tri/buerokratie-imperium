#!/bin/sh
# Übernimmt die aktuelle Spielversion (../index.html) in die iOS-App.
cd "$(dirname "$0")" && cp ../index.html BuerokratieImperium/index.html && echo "index.html in die App übernommen."
