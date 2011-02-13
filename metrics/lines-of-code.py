#!/usr/bin/env python3.1

import os
import os.path
import subprocess
import sys

def which(command):
    """
    Returns the full path of an executable given that executable's name,
    if that executable exists in the system's PATH.
    """
    for d in os.getenv("PATH").split(":"):
        name = os.path.join(d, command)
        if os.path.isfile(name):
            return name
    return ""

if which("cloc") == "":
    print("Requires the `cloc` command from http://cloc.sourceforge.net/")
    quit()

if not len(sys.argv) == 2 and not len(sys.argv) == 3:
    print("Usage: {0} <repositories root> [exclude directories]".format(sys.argv[0]))
    quit()

basePath = os.path.abspath(os.path.expanduser(sys.argv[1]))
ignoreList = sys.argv[2]

keys = ["android", "architecture", "architecture.wiki", "server", "iphone", "builds"]
subdirs = { "android":"Android",
            "architecture":"Architecture", 
            "architecture.wiki":"Architecture.wiki",
            "server":"Server",
            "iphone":"iPhone",
            "builds":"Builds" }
stats = {}

# Generate statistics for all repos
for key in keys:
    path = os.path.join(basePath, subdirs[key])
    
    # Get and preprocess output
    cmdString = "cloc {0}".format(path)
    if len(sys.argv) == 3:
        cmdString = cmdString + " --exclude-dir={0}".format(ignoreList)
    clocLines = subprocess.getoutput(cmdString).split("\n")
    sepCount = 0
    clocOutput = []
    for line in clocLines:
        if len(line) > 0 and line[0] == "-":
            sepCount += 1
        elif sepCount == 2 or sepCount == 3:
            clocOutput.append(line)
    
    # Set up the stats dictionary for this repo
    stats[key] = {}
    
    # Start processing actual stats
    for line in clocOutput:
        parts = line.split(' ')
        parts = list(filter((lambda x : not x == ""), parts))
        
        # Figure out language for this line
        language = []
        while not parts[0].isnumeric():
            language.append(parts.pop(0))
        language = " ".join(language)
        if language == "SUM:":
            continue
        
        # Record stats
        stats[key][language] = {}
        stats[key][language]['files'] = int(parts[0])
        stats[key][language]['comment'] = int(parts[2])
        stats[key][language]['code'] = int(parts[3])

# Get a common languages list
allLanguages = set([])
for key in keys:
    for lang in stats[key]:
        if lang not in allLanguages:
            allLanguages.add(lang)

# Generate files table
print("### Files per language")
print("<table>")
print("<tr><th><i>Repo</i></th>", end="")
for lang in allLanguages:
    print("<th>{0}</th>".format(lang), end="")
print("<th>Total</th></tr>")
for key in keys:
    print("<tr><td><i>{0}</i></td>".format(subdirs[key]), end="")
    for lang in allLanguages:
        print("<td>{0}</td>".format(stats[key][lang]['files'] if lang in stats[key] else 0), end="")
    print("<td>{0}</td>".format(sum((stats[key][l]['files'] if l in stats[key] else 0) for l in allLanguages)), end="")
    print("</tr>")
print("<tr><td><i>Total</i></td>", end="")
for lang in allLanguages:
    print("<td>{0}</td>".format(sum((stats[k][lang]['files'] if lang in stats[k] else 0) for k in keys)), end="")
print("<td>{0}</td>".format(sum((stats[k][l]['files'] if l in stats[k] else 0) for k in keys for l in allLanguages)), end="")
print("</tr>")
print("</table>")
print()

# Generate lines table
print("### LOC per language")
print("<table>")
print("<tr><th><i>Repo</i></th>", end="")
for lang in allLanguages:
    print("<th>{0}</th>".format(lang), end="")
print("<th>Total</th></tr>")
for key in keys:
    print("<tr><td><i>{0}</i></td>".format(subdirs[key]), end="")
    for lang in allLanguages:
        print("<td>{0}</td>".format(stats[key][lang]['code'] if lang in stats[key] else 0), end="")
    print("<td>{0}</td>".format(sum((stats[key][l]['code'] if l in stats[key] else 0) for l in allLanguages)), end="")
    print("</tr>")
print("<tr><td><i>Total</i></td>", end="")
for lang in allLanguages:
    print("<td>{0}</td>".format(sum((stats[k][lang]['code'] if lang in stats[k] else 0) for k in keys)), end="")
print("<td>{0}</td>".format(sum((stats[k][l]['code'] if l in stats[k] else 0) for k in keys for l in allLanguages)), end="")
print("</tr>")
print("</table>")
print()