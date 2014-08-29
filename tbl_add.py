#!/usr/bin/env python
# Tai Sakuma <sakuma@fnal.gov>
import sys
import math

##____________________________________________________________________________||
inputPathList = sys.argv[1:]

##____________________________________________________________________________||
def main():

    head = open(inputPathList[0]).readline()[:-1]
    print head

    counter = { }
    for inpath in inputPathList:
        infile = open(inpath)
        head_ = infile.readline()[:-1]
        if not head == head_:
            raise Exception("The header doesn't match: " + inpath)
        for line in infile:
            line = line[:-1]
            key = line[:line.rfind(' ')]
            idxEndKey = [i for i in range(len(key)) if key[i] != ' '][-1] + 1
            key = key[:idxEndKey]
            n = int(line[line.rfind(' ') + 1:])
            if key not in counter:
                counter[key] = 0
            counter[key] += n

    keys = counter.keys()

    try:
        keys.sort(key=float)
    except ValueError:
        keys.sort()

    for k in keys:
        print k,
        print '%7d' % counter[k],
        print 

    return

##____________________________________________________________________________||
if __name__ == '__main__':
    main()
