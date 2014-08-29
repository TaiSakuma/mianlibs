#!/bin/bash
# Copyright (C) 2011 Tai Sakuma <sakuma@fnal.gov>

npar=${1:-4}
commands=""
nlines=0
maxnlines=100
while read -r line; do
    if [ "$line" = wait ]; then
	echo -e $commands | tr "\n" "\0"  | xargs -t -0 -n 1 -P$npar sh -c
	wait
	commands=""
	nlines=0
    else
	commands="$commands$line\n"
	nlines=$((nlines+1))
	if (($nlines>=$maxnlines)); then
	    echo -e $commands | tr "\n" "\0"  | xargs -t -0 -n 1 -P$npar sh -c
	    commands=""
	    nlines=0
	fi
    fi
done

if [ -n "$commands" ]; then
    echo -e $commands | tr "\n" "\0"  | xargs -t -0 -n 1 -P$npar sh -c
fi
