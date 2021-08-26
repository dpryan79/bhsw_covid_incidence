#!/usr/bin/env python
# In R: ggplot(d, aes(x=Location, y=Incidence)) + geom_col(aes(fill=Date), position="dodge2") + coord_flip() + scale_x_discrete(limits = rev(levels(d$Location))) + xlab("")
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("fname", help="File name")
parser.add_argument("--twoWeeks", action="store_true", help="Print the last week too")
parser.add_argument("--debug", action="store_true", help="Print debugging info")
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
dateLine = 3
gemeindeStart = 6
w1astart = 70
w1bstart = 121
w2astart = 172
w2bstart = 223
for idx, line in enumerate(f):
    if args.debug:
        print([idx, line.strip()])
    if idx < dateLine:
        continue
    if idx == dateLine:
        date = line.strip()
        continue
    # Gemeinde names
    if idx >= gemeindeStart and idx < gemeindeStart + 50:
        locations.append(line.strip())
    elif idx >= w1astart and idx < w1astart + 50:
        week1A.append(int(line.strip().strip('*')))
    elif idx >= w1bstart and idx < w1bstart + 50:
        week1B.append(int(line.strip()))
    elif idx == 7:
        prevdate = line.strip()
        continue
    elif idx >= w2astart and idx < w2astart + 50:
        week2A.append(int(line.strip()))
    elif idx >= w2bstart and idx < w2bstart + 50:
        week2B.append(int(line.strip()))

if args.twoWeeks:
    print("Location\tDate\tIncidence")

for l, w1a, w1b, w2a, w2b, p in zip(locations, week1A, week1B, week2A, week2B, population):
    currentWeek = w1a - w2a
    lastWeek = w1b - currentWeek
    p100k = p / 100000.
    p100kpw1 = max(0, currentWeek/p100k)
    p100kpw2 = max(0, lastWeek/p100k)
    if args.debug:
        print("{}\t{}\t{}\t{}".format(l, date, currentWeek, p100kpw1))
    else:
        print("{}\t{}\t{}".format(l, date, p100kpw1))
    if args.twoWeeks:
        if args.debug:
            print("{}\t{}\t{}\t{}".format(l, prevdate, currentWeek, p100kpw2))
        else:
            print("{}\t{}\t{}".format(l, prevdate, p100kpw2))
