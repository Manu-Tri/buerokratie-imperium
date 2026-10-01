#!/bin/sh
# Übernimmt die aktuelle Spielversion (../index.html und three.min.js) in die iOS-App.
cd "$(dirname "$0")" && cp ../index.html ../three.min.js BuerokratieImperium/ && echo "index.html und three.min.js in die App übernommen."
