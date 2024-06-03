# StV vast

HOR Structural Variant (StV) prediction using HOR-monomer annotation

This is experemental version which makes StV annotation for all the HORs ([original version](https://github.com/fedorrik/stv) uses only live HORs). It requires censat annotation (with coordinates of each HOR). Also this version insertes monomers of different HOR or SF monomer inside the StV name of a given HOR.

Usage: ./stv.sh <monomeric HOR track>.bed <censat anntotaion>.bed
  
Config: insert path to dir with program into stv.sh
___

Output files:

• stv.bed - resulting file which can be put in the browser
  
• stv_raw.bed - same as stv.bed but doesn't contain stv numbering, colors, the first description line

• stv_stats.tsv - contains the number of each stv in each chr/contig

• stv_stats.table - another stats format

• HOR_coords.bed - coordinates of HORs (part of censat annotation file)
___

Method:

1. Extract coordinates of all the HORs from censat annotation
2. Iterate through coordinates: take HOR annotation for given coordinates and run main script (mon2stv.py) on it
3. Squeeze huge "6/4_5" dimer stretches in the human cen1/cen5/cen19
4. Count StV stats
5. Add numbering and colors.

