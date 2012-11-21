""" topojson.py

Functions to help make GeoJSON-ish data structures from TopoJSON
(https://github.com/mbostock/topojson) data.

Author: Sean Gillies (https://github.com/sgillies)
"""

from itertools import chain

def rel2abs(arc, scale=None, translate=None):
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
    if isinstance(arcs[0], int):
        coords = [
            list(
                rel2abs(
                    topology_arcs[arc >= 0 and arc or ~arc],
                    scale, 
                    translate )
                 )[i > 0:][::arc >= 0 or -1] \
            for i, arc in enumerate(arcs) ]
        return list(chain(*coords))
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

