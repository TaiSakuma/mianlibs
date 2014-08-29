#!/bin/bash
# Copyright (C) 2011 Tai Sakuma <sakuma@fnal.gov>

npar=${1:-4}
commands=""
while read -r line; do
    if [ "$line" = wait ]; then
	echo -e $commands | tr "\n" "\0"  | xargs -t -0 -n 1 -P$npar sh -c
	wait
	commands=""
    else
	commands="$commands$line\n"
    fi
done

if [ -n "$commands" ]; then
    echo -e $commands | tr "\n" "\0"  | xargs -t -0 -n 1 -P$npar sh -c
fi
