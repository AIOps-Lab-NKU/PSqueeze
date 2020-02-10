#!/usr/bin/env bash
# **********************************************************************
# * Description   : docker relevant script
# * Last change   : 10:23:47 2020-02-10
# * Author        : Yihao Chen
# * Email         : chenyiha17@mails.tsinghua.edu.cn
# * License       : none
# **********************************************************************

echo -e "PSqueeze script: docker manager..."

SCRIPT_DIR=`dirname "$0"`
SCRIPT_DIR=`cd $SCRIPT_DIR; pwd`
MAIN_DIR=`cd ${SCRIPT_DIR}/../; pwd`

run_image()
{
    name=$1
    sudo docker run --rm -it \
        --name "$name" \
        --mount type=bind,source=$MAIN_DIR,target=/psqueeze \
        --workdir /psqueeze \
        "psqueeze-env:0.2" \
        bash
}

build_image()
{
    sudo docker build -t "psqueeze-env:0.2" \
        --build-arg USER_ID=$(id -u) \
        --build-arg GROUP_ID=$(id -g) $MAIN_DIR
}

load_image()
{
    sudo docker load --input "$1"
}

help_info()
{
    echo -e "USAGE: docker_script.sh {TASK} {DATASET} {SETTING} [NUM_WORKER]"
}


case "$1" in
    run)
        run_image ${2:-psqueeze-tmp}
        ;;
    build)
        build_image
        ;;
    load)
        load_image "$2"
        ;;
    *)
        help_info
        ;;
esac
