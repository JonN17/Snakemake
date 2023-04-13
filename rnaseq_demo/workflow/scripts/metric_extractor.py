# AUTHOR: Jonathan Nowacki
# INPUT: Horizontally horizontally listed metrics files (e.g. GATK)
# OUTPUT: tab delimited metrics file .TXT 
# DESCRIPTION: Extracts metrics certain files for custom calculations
# USE: python3 metric_extractor.py -i {raw_metrics.txt} -m {list of metrics} > {output}
# Example: python3 metric_extractor.py -i CollectHsMetrics.txt -m "BAIT_SET,GENOME_SIZE,BAIT_TERRITORY"

import argparse
import subprocess
import os
import re
import pandas as pd
# Input using argparse
parser = argparse.ArgumentParser(description="Extracts metrics from GATK Files")
parser.add_argument('-i','--input',required=True, action='append')
parser.add_argument('-m','--metrics',required=True)
parser.add_argument('-r','--row', nargs='?', const=1, type=int, default=7)
args=parser.parse_args()

# This specifies the row to grab [DEFAULT: 7]
# For GATK, choose 7 for FIRST_OF_PAIR, 8 for SECOND_OF_PAIR, 9 for PAIR
# The first row is indexed as 0.  Python indexing starts at 0, R starts at 1.
row = args.row

# Import the file that contains the metrics
input_file=args.input
input_file=open(str(input_file[0]))

# Metrics to be extracted stored in an array
metrics_string=args.metrics
metrics = metrics_string.split(",")

# Read the content of the file opened
content = input_file.readlines()

# Extract the important data into a data frame
header=pd.Series(content[6].strip('\n').split("\t"), name="METRICS")
data=pd.Series(content[row].strip('\n').split("\t"), name="VALUES")
df = pd.merge(header, data, right_index = True, left_index = True)
df = df.set_index('METRICS')

# Print the selected metrics to standard out
for label in metrics:
    value=str(df.loc[label].to_numpy()[0])
    print(label + "\t" +value)
