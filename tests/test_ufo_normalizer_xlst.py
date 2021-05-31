from pathlib import Path

from ufo_normalizer_xslt.__main__ import main

DATA = (Path(__file__) / "../data").resolve()


def test_main():
    ufos = (DATA / "mutatorSans").glob("*.ufo")
    main([str(ufo) for ufo in ufos])
