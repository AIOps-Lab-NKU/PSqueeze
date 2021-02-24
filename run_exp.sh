#!/usr/bin/env bash

echo_and_run() {
  echo "$@"
  "$@"
}

run_setting() {
  DATA_ROOT=Psqueeze-dataset
  DATASET=${1:-B5}
  N_ELE=${2:-1}
  LAYER=${3:-1}
  ALGORITHM=${4:PSQ}
  DERIVED=""
  JOBS=${JOBS:-$(nproc)}
  EVAL_ONLY=${EVAL_ONLY:-false}
  if [[ $DATASET == A* ]]; then
    NAME=A_week_12_cuboid_layer_${LAYER}_n_ele_${N_ELE}
  elif [[ $DATASET == B* ]]; then
    NAME=B_cuboid_layer_${LAYER}_n_ele_${N_ELE}
  elif [[ $DATASET == D* ]]; then
    NAME=B_cuboid_layer_${LAYER}_n_ele_${N_ELE}
    DERIVED="--derived"
  fi
  mkdir output/${ALGORITHM}/${DATASET}/${NAME} -p
  if [ "${EVAL_ONLY}" == false ]; then
    echo_and_run python run_algorithm.py \
      --name ${NAME} \
      --input-path ${DATA_ROOT}/${DATASET} \
      --output-path output/${ALGORITHM}/${DATASET}/${NAME} \
      --algorithm ${ALGORITHM} \
      ${DERIVED} \
      -j ${JOBS} | tee output/${ALGORITHM}/${DATASET}/${NAME}/runtime.log
  fi
  echo_and_run python run_evaluation.py \
    -i ${DATA_ROOT}/${DATASET}/${NAME}/injection_info.csv \
    -p output/${ALGORITHM}/${DATASET}/${NAME}/${NAME}.json \
    -o output/${ALGORITHM}/${DATASET}/${NAME}/${NAME}.result.csv \
    -c ${DATA_ROOT}/${DATASET}/config.json \
    -g ${DATA_ROOT}/${DATASET}/${NAME} \
    ${DERIVED} \
    -v
}

run_setting B6 3 3 PSQ
#for alg in PSQ SQ ADT RAD APR HS MID; do
#  for dataset in A B5 B6 B7 B8 D; do
#    for n_ele in 1 2 3; do
#      for cuboid_layer in 1 2 3; do
#        echo_and_run run_setting ${dataset} ${n_ele} ${cuboid_layer} ${alg}
#      done
#    done
#  done
#done
