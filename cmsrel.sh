#!/bin/bash
# Tai Sakuma <sakuma@fnal.gov>

##____________________________________________________________________________||
function cmsrel
{
    pwd=$(pwd)
    pwd=${pwd/ /\\ }

    relpwd=${pwd/$loctop/}
    remdir="${remtop}${relpwd}/"

    command="\
export SCRAM_ARCH=${scram_arch}; \
mkdir -p ${remdir}; \
cd ${remdir}; \
scramv1 project -n ${new_dir} CMSSW ${cmssw_version}; \
"

if [ $remhos = "localhost" ]; then
    echo "${command}"
    echo "mkdir -p ${new_dir}/src"
    echo "echo \"\n==== to be in the environment ====\nsource ~/cmsenv.sh ${remdir}${new_dir}/src\n\""
else
    echo "ssh -n ${remhos} '${command}'"
    echo "mkdir -p ${new_dir}/src"
    echo "echo \"\n==== to be in the environment ====\nslogin -v -X -Y -a ${remhos}\nsource ./cmsenv.sh ${remdir}${new_dir}/src\n\""
fi

}

##____________________________________________________________________________||
