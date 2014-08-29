#!/bin/bash
# Tai Sakuma <sakuma@fnal.gov>

##____________________________________________________________________________||
function create_backUpFile_path
{
    local outfile=$1
    local timenow=$(date '+%y%m%d_%H%M')
    local i=1
    local ext=${outfile##*.}
    local backUpFile=${outfile%.*}_${timenow}_${i}.${ext}
    while [ -s ${backUpFile} ]
    do
    	local i=$((i+1))
    	local backUpFile=${outfile%.*}_${timenow}_${i}.${ext}
    done
    echo ${backUpFile}
    
}

##____________________________________________________________________________||
function mv_with_timestamp
{
    local outfile=$1
    if [ -s ${outfile} ]; then
	local backUpFile=$(create_backUpFile_path ${outfile})
	echo "mv -f ${outfile} ${backUpFile}"
	echo "wait"
    fi
}

##____________________________________________________________________________||
function cp_with_timestamp
{
    local outfile=$1
    if [ -s ${outfile} ]; then
	local backUpFile=$(create_backUpFile_path ${outfile})
	echo "cp -a ${outfile} ${backUpFile}"
	echo "wait"
    fi
}

##____________________________________________________________________________||
