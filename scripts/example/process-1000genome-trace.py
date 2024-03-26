from __future__ import annotations

import argparse
import pathlib
import pickle
import sys
from typing import Sequence

import pandas


def load(filepath: str) -> pandas.DataFrame:
    with open(filepath, 'rb') as f:
        df = pickle.load(f)

    df.insert(0, 'name', pathlib.Path(filepath).stem)

    return df


def main(argv: Sequence[str] | None = None) -> int:
    argv = argv if argv is not None else sys.argv[1:]

    parser = argparse.ArgumentParser()

    parser.add_argument(
        '--input',
        nargs='+',
        required=True,
        help='Input pickle files',
    )
    parser.add_argument('--output', required=True, help='Output CSV file')
    args = parser.parse_args(argv)

    dfs: list[pandas.DataFrame] = []
    for path in args.input:
        dfs.append(load(path))

    df = pandas.concat(dfs, ignore_index=True)

    df.to_csv(args.output, index=False)


if __name__ == '__main__':
    raise SystemExit(main())
