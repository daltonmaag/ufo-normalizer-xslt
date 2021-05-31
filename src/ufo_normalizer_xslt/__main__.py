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
import argparse
import sys

from . import normalize


def main(args=None):
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "paths", nargs="+", help="UFO or file to normalize.", metavar="INPUT"
    )
    parser.add_argument("--transform", help="Transform file.", metavar="XSLT")
    parser.add_argument(
        "--float-precision", type=int, help="Float precision.", metavar="NUM"
    )
    options = parser.parse_args(args)

    for path in options.paths:
        normalize(
            path, transform=options.transform, float_precision=options.float_precision
        )


if __name__ == "__main__":
    from timeit import default_timer as time

    start = time()
    main(sys.argv[1:])
    print("%.3fs" % (time() - start))
