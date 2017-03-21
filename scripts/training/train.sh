#!/bin/bash

#$ -S /bin/bash -V -cwd
#$ -j y -o logs/
#$ -l h_rt=168:00:00

maxiters=9999
if [[ ! -z $1 ]]; then
    maxiters=$1
fi

echo "Running for at most $maxiters iterations..."

iter=1
[[ ! -d logs ]] && mkdir logs
while true; do
    echo "ITERATION $iter / $maxiters"

    # Run an iteration of training lasting at most two hours. Make sure that
    # saveFreq is set low enough in config.py to save within that amount of time
    # (1000 should be sufficient though it is relatively often)
    qsub -sync y -cwd -l gpu=1 -l h_rt=2:00:00 -S /bin/bash -V -j y -o logs/ train-iter.sh

    if [[ $iter -ge $maxiters ]]; then
        echo "Quitting."
        break
    fi

    let iter=iter+1
done
