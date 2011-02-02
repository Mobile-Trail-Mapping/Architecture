#!/usr/bin/env python3.1

import logging
import os.path
import pygitlog

repoNames = ["iPhone", "Architecture", "Architecture.wiki", "Android", "Server"]
commitCounts = {}

REPOS_ROOT=os.path.abspath(os.path.expanduser("~/code/Mobile-Trail-Mapping"))

for repoName in repoNames:
    # Grab the Git history
    hist = pygitlog.History(path=os.path.join(REPOS_ROOT, repoName), log=logging.INFO)
    
    for commit in hist.commits.values():
        dateStr = str(commit.commitDatetime.date())
        if not dateStr in commitCounts:
            commitCounts[dateStr] = {}
            for n in repoNames:
                commitCounts[dateStr][n] = 0
        commitCounts[dateStr][repoName] += 1
sortedKeys = sorted(commitCounts.keys())

# Markdown time! bleh
print("<table>")
print("<tr><th><i>Date</i></th>", end="")
for repoName in repoNames:
    print("<th>{0}</th>".format(repoName), end="")
print("<th>Total</th></tr>")
for dateStr in sortedKeys:
    print("<tr><td><i>{0}</i></td>".format(dateStr), end="")
    for repoName in repoNames:
        print("<td>{0}</td>".format(str(commitCounts[dateStr][repoName])), end="")
    print("<td>{0}</td>".format(str(sum(commitCounts[dateStr][r] for r in repoNames))), end="")
    print("</tr>")
print("<tr><td><i>Total</i></td>", end="")
for repoName in repoNames:
    print("<td>{0}</td>".format(str(sum(commitCounts[d][repoName] for d in commitCounts))), end="")
print("<td>{0}</td>".format(str(sum(commitCounts[d][r] for d in commitCounts for r in repoNames))), end="")
print("</tr>")
print("</table>")