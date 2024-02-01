#!/usr/bin/env bash

url=https://zoom.us/client/latest/zoom_amd64.deb
debdir=/usr/local/zoomdebs
aptconf=/etc/apt/apt.conf.d/100update_zoom
sourcelist=/etc/apt/sources.list.d/zoomdebs.list

sudo mkdir -p $debdir
( echo 'APT::Update::Pre-Invoke {"cd '$debdir' && wget -qN '$url' && apt-ftparchive packages . > Packages && apt-ftparchive release . > Release";};' | sudo tee $aptconf
  echo 'deb [trusted=yes lang=none] file:'$debdir' ./' | sudo tee $sourcelist
) >/dev/null

sudo apt update
sudo apt install zoom