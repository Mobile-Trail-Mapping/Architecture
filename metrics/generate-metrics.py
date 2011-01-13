#!/usr/bin/env python3.1

import logging
import pygitlog

hist = pygitlog.History(path="~/code/Mobile-Trail-Mapping/Android/", log=logging.INFO)

for author in hist.authors.values():
    print("{0} has {1} commits".format(author.name, len(author.commits)))