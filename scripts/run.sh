#!/usr/bin/env bash
# **********************************************************************
# * Description   : run experiment script
# * Last change   : 20:58:38 2019-10-15
# * Author        : Yihao Chen
# * Email         : chenyiha17@mails.tsinghua.edu.cn
# * License       : none
# **********************************************************************

echo -e "PSqueeze script: run experiment..."

SCRIPT_DIR=`dirname "$0"`
SCRIPT_DIR=`cd $SCRIPT_DIR; pwd`
MAIN_DIR=`cd ${SCRIPT_DIR}/../; pwd`
DATA_DIR=`cd ${MAIN_DIR}/data/; pwd`
RESULT_DIR=${MAIN_DIR}/result/

[ ! -d "$RESULT_DIR" ] && mkdir "$RESULT_DIR"
RESULT_DIR=`cd ${RESULT_DIR}; pwd`
cd $MAIN_DIR

run_algorithm()
{
    DATASET=$1
    SETTING=$2
    NUM_WORKER=$3
    ./run_algorithm.py \
        --name ${SETTING} \
        --input-path ${DATA_DIR}/${DATASET} \
        --output-path ${RESULT_DIR}/${DATASET}/ \
        --num-workers ${NUM_WORKER}
}

run_evaluation()
{
    DATASET=$1
    SETTING=$2
    ./run_evaluation.py \ 
        -i ${DATA_DIR}/${DATASET}/${SETTING}/injection_info.csv \ 
        -p ${RESULT_DIR}/${DATASET}/${SETTING}.json \
        -c ${DATA_DIR}/${DATASET}/config.json
}

help_info()
{
    echo -e "USAGE: run.sh {TASK} {DATASET} {SETTING} [NUM_WORKER]"
}

TASK=$1
DATASET=$2
SETTING=$3
NUM_WORKER=${4:-1}

#TODO
case "$TASK" in
    run)
        run_algorithm "$DATASET" "$SETTING" "$NUM_WORKER"
        ;;
    eval)
        run_evaluation "$DATASET" "$SETTING"
        ;;
    test)
        run_algorithm B0 B_cuboid_layer_1_n_ele_1 "$NUM_WORKER"
        ;;
    *)
        help_info
        ;;
esac
