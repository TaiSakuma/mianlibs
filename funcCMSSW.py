#!/usr/bin/env python
# Tai Sakuma <sakuma@fnal.gov>
import ROOT
import sys
import json

ROOT.gROOT.SetBatch(1)

##____________________________________________________________________________||
def noEvents(inputPathList):
    if len(inputPathList) == 0: return True
    for inputPath in inputPathList:
        if getNEvents(inputPath) > 0: return False
    return True

##____________________________________________________________________________||
def getNEvents(inputPath):
    file = ROOT.TFile.Open(inputPath)
    events = file.Get('Events')
    return events.GetEntries()

##____________________________________________________________________________||
class PrintFileNameIfChange(object):
    def __init__(self, verbose = True):
        self.fileName = ""
        self.verbose = verbose

    def __call__(self, event):
        if self.fileName is not event._filenames[event.fileIndex()]:
            self.fileName = event._filenames[event.fileIndex()]
            if not self.verbose: return
            print >> sys.stderr, self.fileName

##____________________________________________________________________________||
class LuminosityBlockCertification(object):
    def __init__(self, jsonPath):
        self.json = json.load(open(jsonPath)) if jsonPath else None

    def __call__(self, event):
        if self.json is None: return True
        run = event.eventAuxiliary().run()
        lumi = event.eventAuxiliary().luminosityBlock()
        if str(run) not in self.json: return False
        if any([(l1 <= lumi <= l2) for (l1, l2) in self.json[str(run)]]): return True
        return False

##____________________________________________________________________________||
def mkInputPathList(inputPath, inputPathListFile):
    if inputPath:
        return [inputPath]
    elif inputPathListFile:
        return [l for l in open(inputPathListFile).read().splitlines()]
    else:
        return [ ]

##____________________________________________________________________________||
def loadLibraries():
    argv_org = list(sys.argv)
    sys.argv = [e for e in sys.argv if e != '-h']
    ROOT.gSystem.Load("libFWCoreFWLite")
    ROOT.AutoLibraryLoader.enable()
    ROOT.gSystem.Load("libDataFormatsFWLite")
    ROOT.gSystem.Load("libDataFormatsPatCandidates")
    sys.argv = argv_org

##____________________________________________________________________________||
if __name__ == '__main__':
    pass
