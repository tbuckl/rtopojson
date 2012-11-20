""" topojson.py

Functions to help make GeoJSON-ish data structures from TopoJSON
(https://github.com/mbostock/topojson) data.

Author: Sean Gillies (https://github.com/sgillies)
"""

from itertools import chain
import math

def transform(arc, scale=None, translate=None):
    if scale and translate:
        a, b = 0.0, 0.0
        for ax, bx in arc:
            a += ax
            b += bx
            yield scale[0]*a + translate[0], scale[1]*b + translate[1]
    else:
        for x, y in arc:
            yield x, y

def coordinates(arcs, topology_arcs, scale=None, translate=None):
    """Returns coordinates for arcs within the entire topology."""
    # Our tolerance is the delta encoding scale if given, else a small value.
    tolerance = scale or (1.0e-15, 1.0e-15)
    if isinstance(arcs[0], int):
        # Wrap the chain of arc coordinates in a duplicate-removing
        # generator.
        def dupe_removing_chain():
            last = None
            for item in chain(*(
                    transform(topology_arcs[arc], scale, translate
                    ) for arc in arcs)):
                # If subsequent points are within 'tolerance' distance we
                # skip the duplicate.
                if last and (
                    math.fabs(last[0]-item[0]
                        ) < tolerance[0] and math.fabs(
                        last[1]-item[1]) < tolerance[1]):
                    continue
                last = item
                yield item
        return list(dupe_removing_chain())
    elif isinstance(arcs[0], (list, tuple)):
        return list(
            coordinates(arc, topology_arcs, scale, translate) for arc in arcs)
    else:
        raise ValueError("Invalid input %s", arcs)

def geometry(obj, topology_arcs, scale=None, translate=None):
    """Converts a topology object to a geometry object."""
    return {
        "type": obj['type'], 
        "coordinates": coordinates(
            obj['arcs'], topology_arcs, scale, translate )}

if __name__ == "__main__":
    
    # An example.

    import json
    import pprint

    data = """{
    "arcs": [
      [[0.0, 0.0], [1.0, 0.0]],
      [[1.0, 0.0], [0.0, 1.0]],
      [[0.0, 1.0], [0.0, 0.0]],
      [[1.0, 0.0], [1.0, 1.0]],
      [[1.0, 1.0], [0.0, 1.0]]
      ],
    "transform": {
      "scale": [0.035896033450880604, 0.005251163636665131],
      "translate": [-179.14350338367416, 18.906117143691233]
    },
    "objects": [
      {"type": "Polygon", "arcs": [[0, 1, 2]]},
      {"type": "Polygon", "arcs": [[3, 4, 1]]}
      ]
    }"""
    
    topology = json.loads(data)
    scale = topology['transform']['scale']
    translate = topology['transform']['translate']

    p = geometry({'type': "LineString", 'arcs': [0]}, topology['arcs'])
    pprint.pprint(p)
    
    q = geometry({'type': "LineString", 'arcs': [0, 1]}, topology['arcs'])
    pprint.pprint(q)

    r = geometry(topology['objects'][0], topology['arcs'])
    pprint.pprint(r)

    s = geometry(topology['objects'][1], topology['arcs'], scale, translate)
    pprint.pprint(s)

