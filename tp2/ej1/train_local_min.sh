#!/bin/bash

DATASETS=datasets/
DATASET_NAME=dos_elipses
EXEC_BP=../bp


## Busco crear los netfile iterando el momentum y el learning rate
## para cada valor voy a crear 10 conjuntos y de ahí promediaré
function net_file {
    # ITER=$1
    MOMENTUM=$1
    LR=$2 #Learning rate

    echo "Generate net file for lr=$LR and momentum=$MOMENTUM."
    # PREFIX=${DATASETS}${DATASET_NAME}_${ITER}_${MOMENTUM}_${LR}
    PREFIX=${DATASETS}${DATASET_NAME}_${MOMENTUM}_${LR}

    rm -f $PREFIX.net

    for a in 2 6 1 500 400 2000 40000 $LR $MOMENTUM 400 0 0 0
    do
        echo $a >> $PREFIX.net
    done

}

function train {
    MOMENTUM=$1
    LR=$2
    echo "Training for lr=$LR and momentum=$MOMENTUM."

    PREFIX=${DATASETS}${DATASET_NAME}_${MOMENTUM}_${LR}
    ln -f ${DATASETS}${DATASET_NAME}.data $PREFIX.data
    ln -f ${DATASETS}${DATASET_NAME}.test $PREFIX.test

    $EXEC_BP $PREFIX &> $PREFIX.output
    echo "Finish training lr=$LR and momentum=$MOMENTUM."
}

## MAIN
rm -f datasets/*.net
# Itero y creo los .net files
for LR in $(seq 0.001 0.005 0.1)
do
    for MOMENTUM in $(seq 0 0.05 0.9)
    do
        # for i in {1..10}
        # do
            net_file $MOMENTUM $LR
            train $MOMENTUM $LR

        # done
    done
done