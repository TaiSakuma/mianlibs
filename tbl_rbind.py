#!/usr/bin/env python
# Tai Sakuma <sakuma@fnal.gov>
import sys
import math
from optparse import OptionParser

##____________________________________________________________________________||
parser = OptionParser()
parser.add_option("-v", "--verbose", action="store_true", default=False)
(options, args) = parser.parse_args(sys.argv)

##____________________________________________________________________________||
inputPathList = args[1:]

##____________________________________________________________________________||
def main():

    head = open(inputPathList[0]).readline()[:-1]
    print head

    for inpath in inputPathList:
        if options.verbose: print >> sys.stderr, inpath
        infile = open(inpath)
        head_ = infile.readline()[:-1]
        if not head == head_:
            raise Exception("The header doesn't match: " + inpath)
        for line in infile:
            print line,

    return

##____________________________________________________________________________||
if __name__ == '__main__':
    main()
