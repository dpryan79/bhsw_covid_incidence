#!/usr/bin/env python
# In R: ggplot(d, aes(x=Location, y=Incidence)) + geom_col(aes(fill=Date), position="dodge2") + coord_flip() + scale_x_discrete(limits = rev(levels(d$Location))) + xlab("")
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("fname", help="File name")
parser.add_argument("--twoWeeks", action="store_true", help="Print the last week too")
#parser.add_argument("--noHeader", action="store_true", help="Don't print a header")
args = parser.parse_args()

f = open(args.fname)
inWeek = 0
locations = []
week1A = []
week1B = []
week2A = []
week2B = []
population = [1480, 2796, 20377, 4432, 2440, 2338, 5331, 15488, 1751, 3129, 4387, 2867, 7501, 3632, 2131, 2491, 1862, 2007, 3167, 2912, 11683, 4768, 6354, 1141, 2631, 1166, 6152, 9743, 5064, 7617, 9279, 2582, 5288, 19077, 5072, 12273, 2892, 2589, 6351, 2508, 1275, 1863, 2626, 8187, 4511, 2817, 12197, 5763, 6097, 1516]
date = None
prevdate = None
nextChunk = 0
offset = -1
for idx, line in enumerate(f):
    print([idx, line.strip()])
    if idx < 4:
        continue
    if idx == 4:
        date = line.strip()
        continue
    if idx > 5 and idx < 56:
        locations.append(line.strip())
    elif idx > 61 and idx < 112:
        week1A.append(int(line.strip()))
    elif idx > 118 and idx < 169:
        week1B.append(int(line.strip()))
    elif idx == 173:
        prevdate = line.strip()
        continue
    elif idx > 177 and idx < 228:
        week2A.append(int(line.strip()))
    elif idx > 234 and idx < 285:
        week2B.append(int(line.strip()))

if args.twoWeeks:
    print("Location\tDate\tIncidence")

for l, w1a, w1b, w2a, w2b, p in zip(locations, week1A, week1B, week2A, week2B, population):
    currentWeek = w1a - w2a
    lastWeek = w1b - currentWeek
    p100k = p / 100000
    p100kpw1 = currentWeek/p100k
    p100kpw2 = max(0, lastWeek/p100k)
    print("{}\t{}\t{}".format(l, date, p100kpw1))
    if args.twoWeeks:
        print("{}\t{}\t{}".format(l, prevdate, p100kpw2))
