#!/usr/bin/env python
# Tai Sakuma <sakuma@fnal.gov>
import unittest

##____________________________________________________________________________||
class Binning(object):
    def __init__(self, boundaries, labels = None):
        self.boundaries = boundaries
        if labels is None:
            self.labels = [i for i in xrange(len(boundaries) + 1)]
        else:
            self.labels = labels

    def __call__(self, val):
        for b in range(0, (len(self.boundaries))):
            if val < self.boundaries[b]: return self.labels[b]
        else: return self.labels[b + 1]

    def getLowEdgeForLabel(self, label):
        idx = self.labels.index(label)
        if idx <= 0: return 'NA'
        return self.boundaries[self.labels.index(label) - 1]

    def getUpEdgeForLabel(self, label):
        idx = self.labels.index(label)
        if idx >= len(self.boundaries): return 'NA'
        return self.boundaries[self.labels.index(label)]

    def getCenterForLabel(self, label):
        low = self.getLowEdgeForLabel(label)
        if low == 'NA': return 'NA'
        up = self.getUpEdgeForLabel(label)
        if up == 'NA': return 'NA'
        return (up + low)/2.0

##____________________________________________________________________________||
class TestSequenceFunctions(unittest.TestCase):
    def test_basic(self):
        binning = Binning(boundaries = (0, 1, 2))
        self.assertEqual(binning(0.3), 1)
        self.assertEqual(binning(1.1), 2)

    def test_out_of_range(self):
        binning = Binning(boundaries = (0, 1, 2))
        self.assertEqual(binning(-0.1), 0)
        self.assertEqual(binning(2.1), 3)
    
    def test_on_boundaries(self):
        binning = Binning(boundaries = (0, 1, 2))
        self.assertEqual(binning(0), 1)
        self.assertEqual(binning(1), 2)
        self.assertEqual(binning(2), 3)
    
    def test_show_boundaries(self):
        binning = Binning(boundaries = (0, 1, 2))
        self.assertEqual(binning.getLowEdgeForLabel(0), 'NA')
        self.assertEqual(binning.getLowEdgeForLabel(1), 0)
        self.assertEqual(binning.getLowEdgeForLabel(2), 1)
        self.assertEqual(binning.getLowEdgeForLabel(3), 2)
    
        self.assertEqual(binning.getUpEdgeForLabel(0), 0)
        self.assertEqual(binning.getUpEdgeForLabel(1), 1)
        self.assertEqual(binning.getUpEdgeForLabel(2), 2)
        self.assertEqual(binning.getUpEdgeForLabel(3), 'NA')

    def test_show_centers(self):
        binning = Binning(boundaries = (0, 1, 2))
        self.assertEqual(binning.getCenterForLabel(0), 'NA')
        self.assertEqual(binning.getCenterForLabel(1), 0.5)
        self.assertEqual(binning.getCenterForLabel(2), 1.5)
        self.assertEqual(binning.getCenterForLabel(3), 'NA')

##____________________________________________________________________________||
if __name__ == '__main__':
    unittest.main()
