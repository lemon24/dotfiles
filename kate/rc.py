#!/usr/bin/env python3

import sys


def _parse(file):
    rv = {}
    group = None

    for line in file:
        line = line.rstrip('\n')

        if line.startswith('[') and line.endswith(']'):
            group = line
            rv.setdefault(group, [])
        else:
            assert group, "must start with group"
            rv[group].append(line)

    return rv


def _dump(data):
    for group, values in data.items():
        print(group)
        for value in values:
            print(value)


IGNORE = """\
[Desktop Entry]
[Favorite Profiles]
[KTextEditor::Search]
[MainWindow]
[PluginTextFilter]
""".splitlines()

def dump(path):
    data = _parse(open(path))
    for group in IGNORE:
        data.pop(group, None)
    _dump(data)


def merge(*paths):
    data = {}
    for path in paths:
        try:
            data.update(_parse(open(path)))
        except FileNotFoundError:
            pass
    _dump(data)


if __name__ == '__main__':
    locals()[sys.argv[1]](*sys.argv[2:])

