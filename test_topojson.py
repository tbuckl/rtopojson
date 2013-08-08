
import json
from unittest import TestCase
import pprint
from topojson import coordinates, geometry, rel2abs

data = """{
"arcs":
[[[3028, 4277],
  [-1, -2],
  [0, 1],
  [0, 1],
  [-1, 3],
  [0, 2],
  [0, 2],
  [1, 3],
  [0, 2],
  [1, -3],
  [0, -6],
  [0, -3]],
 [[3014, 4287],
  [0, -2],
  [0, 1],
  [0, 1],
  [0, 2],
  [1, 0],
  [0, 1],
  [1, 0],
  [0, 2],
  [0, -1],
  [0, -1],
  [0, -1],
  [0, -2],
  [-1, 0],
  [-1, 0]]],
"transform": {
  "scale": [0.035896033450880604, 0.005251163636665131],
  "translate": [-179.14350338367416, 18.906117143691233]
}
}"""

topology = json.loads(data)
topology_arcs = topology['arcs']
scale = topology['transform']['scale']
translate = topology['transform']['translate']

coords = coordinates([0], topology_arcs, scale, translate)

pprint.pprint(coords)

def test_rel2abs_noscale():
    arc = [[0, 0], [1, 1]]
    coords = list(rel2abs(arc, None, None))
    assert coords[0] == (0, 0)
    assert coords[1] == (1, 1)

def test_rel2abs():
    arc = [[0, 0], [1, 1]]
    coords = list(rel2abs(arc, (2.0, 2.0), (100.0, 100.0)))
    assert coords[0] == (100.0, 100.0)
    assert coords[1] == (102.0, 102.0)

class CoordinatesTest(TestCase):
    def failUnlessCoordsAlmostEqual(self, a, b):
        self.failUnlessAlmostEqual(a[0], b[0])
        self.failUnlessAlmostEqual(a[1], b[1])
    def test_one(self):
        coords = coordinates([0], topology_arcs, scale, translate)
        self.failUnlessEqual(len(coords), 12)
        self.failUnlessCoordsAlmostEqual(
            coords[0], 
            (-70.45031409440769, 41.365344017708) )
    def test_one_rev(self):
        coords = coordinates([-1], topology_arcs, scale, translate)
        self.failUnlessEqual(len(coords), 12)
        self.failUnlessCoordsAlmostEqual(
            coords[-1], 
            (-70.45031409440769, 41.365344017708) )
    def test_two(self):
        coords = coordinates([0, 1], topology_arcs, scale, translate)
        self.failUnlessEqual(len(coords), 26)
        self.failUnlessCoordsAlmostEqual(
            coords[0], 
            (-70.45031409440769, 41.365344017708) )
    def test_two_rev(self):
        coords = coordinates([-2, -1], topology_arcs, scale, translate)
        self.failUnlessEqual(len(coords), 26)
        self.failUnlessCoordsAlmostEqual(
            coords[-1], 
            (-70.45031409440769, 41.365344017708) )
    def test_ring(self):
        coords = coordinates([[0, 1]], topology_arcs, scale, translate)
        self.failUnlessEqual(len(coords), 1)
        self.failUnlessEqual(len(coords[0]), 26)
        self.failUnlessCoordsAlmostEqual(
            coords[0][0], 
            (-70.45031409440769, 41.365344017708) )

def test_geometry():
    geom = geometry(
        {'type': "LineString", 'arcs': [0, 1]}, 
        topology_arcs, 
        scale, translate )
    assert geom['type'] == "LineString"
    assert len(geom['coordinates']) == 26


