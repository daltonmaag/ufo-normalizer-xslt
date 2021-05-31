# Copyright 2021 Dalton Maag Ltd.

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# -*- coding: utf-8 -*-
from __future__ import print_function

import glob
import os
import pkgutil

from lxml import etree

__all__ = ["get_transform", "normalize"]

PLISTS = (
    "metainfo.plist",
    "fontinfo.plist",
    "groups.plist",
    "kerning.plist",
    "lib.plist",
    "layercontents.plist",
)
LAYERS_PLISTS = ("contents.plist", "layerinfo.plist")

FORMS = ["ufoNormalizer"]

DEFAULT_PRECISION = 10


def get_transform(path=None):
    if path is None:
        data = pkgutil.get_data(__name__, "transform.xslt")
    else:
        with open(path, "r") as fp:
            data = fp.read()
    return etree.XSLT(etree.XML(data))


def normalize(path, form=None, transform=None, float_precision=None):
    if form is None or form == "ufoNormalizer":
        transform = get_transform()
    elif form not in FORMS and transform is None:
        raise ValueError("Invalid form or transform")
    plists = glifs = []

    if float_precision is None:
        float_precision = DEFAULT_PRECISION

    if path.strip(os.sep).endswith("ufo"):
        print("Normalizing %s" % path)
        plists = glob.glob(os.path.join(path, "*.plist"))
        plists = [plist for plist in plists if plist.endswith(PLISTS)]
        layers_plists = glob.glob(os.path.join(path, "glyphs*/*.plist"))
        plists += [plist for plist in layers_plists if plist.endswith(LAYERS_PLISTS)]
        glifs = glob.glob(os.path.join(path, "glyphs*/*.glif"))
    else:
        if path.endswith("plist"):
            plists = [path]
        elif path.endswith("glif"):
            glifs = [path]
        else:
            raise ValueError("Not .plist or .glif")

    for path in plists:
        result = transform(
            etree.parse(path), **{"float-precision": str(float_precision)}
        )
        if (
            not path.endswith("metainfo.plist")
            and len(list(result.find("*").iterchildren())) == 0
        ):
            print('Removing empty "%s".' % path)
            os.remove(path)
            continue
        with open(path, "wb") as fp:
            fp.write(result)
    for path in glifs:
        result = transform(
            etree.parse(path), **{"float-precision": str(float_precision)}
        )
        with open(path, "wb") as fp:
            fp.write(result)
