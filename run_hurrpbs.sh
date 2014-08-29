#!/bin/bash
# Copyright (C) 2011 Tai Sakuma <sakuma@fnal.gov>

##____________________________________________________________________________||
jobDir=${1:-./tmp_hurrpbs}

##____________________________________________________________________________||
submittedDir=$(pwd)

##____________________________________________________________________________||
mkdir -p ${jobDir}
cd ${jobDir}

##____________________________________________________________________________||
logDir="log"
mkdir -p ${logDir}

##____________________________________________________________________________||
let iProcess=0
while read -r line; do
    let iProcess=iProcess+1
    pbsPath=$(printf "job_%04d.pbs" ${iProcess})
    cat > $pbsPath <<EOF
#PBS -l nodes=1:ppn=1
#PBS -l walltime=08:00:00
#PBS -q general
source ./cmsenv.sh ${submittedDir}
$line
exit 0
EOF
    cd ${logDir}
    qsub ../${pbsPath}
    cd ..
done

##____________________________________________________________________________||
