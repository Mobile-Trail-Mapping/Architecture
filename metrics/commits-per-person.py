#!/usr/bin/env python3.1

import logging
import pygitlog

repoNames = ["iPhone", "Architecture", "Architecture.wiki", "Android", "Server"]
authorNames = { "lithium3141":"Tim Ekl",
                "fernferret":"Eric Stokes",
                "davidpick":"David Pick",
                "brousalis":"Pete Brousalis" }
commitCounts = {}
for username in authorNames:
    commitCounts[username] = 0

# Markdown header
print("<table>")
print("<tr><th>Repo</th><th>{0}</th></tr>".format("</th><th>".join(authorNames.values())))

for repoName in repoNames:
    # Markdown row beginning
    print("<tr><td><i>{0}</i></td>".format(repoName),end="")
    
    # Grab the Git history
    hist = pygitlog.History(path="~/code/Mobile-Trail-Mapping/{0}/".format(repoName), log=logging.INFO)
    
    # Print out commit counts
    for username in authorNames:
        author1 = hist.authorWithName(username)
        author2 = hist.authorWithName(authorNames[username])
        commitCount = 0
        if author1:
            commitCount += len(author1.commits)
        if author2:
            commitCount += len(author2.commits)
        print("<td>{0}</td>".format(commitCount),end="")
        commitCounts[username] += commitCount
    
    # Markdown row ending
    print("</tr>")

# Markdown totals
print("<tr><td><i>Total (%)</i></td>", end="")
for username in authorNames:
    print("<td>{0} ({1:.0f}%)".format(str(commitCounts[username]), 100 * commitCounts[username] / sum(commitCounts[u] for u in authorNames)), end="")
print("</tr>")

# Markdown footer
print("</table>")