#!/bin/bash

declare -a urls=(

# Rom URLs
'http://bigota.d.miui.com/9.3.22/miui_CEPHEUS_9.3.22_c63654cc2f_9.0.zip'

)

EU_VER=9.3.21

declare -a eu_urls=(

# EU Rom URLs
'https://jaist.dl.sourceforge.net/project/xiaomi-eu-multilang-miui-roms/xiaomi.eu/MIUI-WEEKLY-RELEASES/9.3.21/xiaomi.eu_multi_MI9_9.3.21_v10-9.zip'

)

command -v dirname >/dev/null 2>&1 && cd "$(dirname "$0")"
if [[ "$1" == "rom" ]]; then
    set -e
    base_dir=/sdcard/TWRP
    [ -z "$2" ] && VER="$EU_VER" || VER=$2
    [ -d "$base_dir" ] || base_dir=.
    aria2c_opts="--check-certificate=false --file-allocation=trunc -s10 -x10 -j10 -c"
    aria2c="aria2c $aria2c_opts -d $base_dir/$VER"
    for i in "${eu_urls[@]}"
    do
        $aria2c ${i//$EU_VER/$VER}
    done
    base_url="https://github.com/maboloshi/mipay-extract/releases/download/$VER"
    $aria2c $base_url/eufix-CEPHEUS-$VER.zip
    $aria2c $base_url/mipay-CEPHEUS-$VER.zip
    $aria2c $base_url/eufix-appvault-CEPHEUS-$VER.zip
    exit 0
fi
for i in "${urls[@]}"
do
   bash extract.sh --appvault "$i" || exit 1
done
[[ "$1" == "keep"  ]] || rm -rf miui-*/ miui_*.zip
for i in "${eu_urls[@]}"
do
   bash cleaner-fix.sh --trafficfix --nofbe "$i" || exit 1
done
exit 0
