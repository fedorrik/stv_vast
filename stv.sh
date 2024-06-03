#!/bin/bash
# Pipeline creates StV bed file and StV stats table from monomeric AS-HOR bed file

if [[ $# -ne 2 ]]
then
    echo "usage: ./stv <monomeric track> <censat anntotaion>"
    exit 1
fi

# put here path to dir with program
path='/home/fedor/sync/bioinformatics/centromere/soft/stv_vast'

# take normal HORs from censat annotation
grep -P '\thor|active_hor' $2 | cut -f 1,2,3,4 | grep -v ',' | grep -v 'S4C20H7/8' > HOR_coords.bed

# clear stv_raw.bed if this is not 1st attempt :)
rm -f stv_raw.bed
# loop HORs
while read line; do
  # extract HOR name
  HOR=`echo $line | grep -oE 'S.+' | rev | cut -c2- | rev`
  chr=`echo $line | cut -f 1 -d ' '`
  start=`echo $line | cut -f 2 -d ' '`
  end=`echo $line | cut -f 3 -d ' '`
  echo $chr $HOR
  # get monomer annotation from region of current HOR
  awk -v chr=$chr -v start=$start -v end=$end '{if ($1==chr) {if ($2>=start && $3<=end) {print $0}}}' $1 > current_hor.bed
  # monomers to StVs
  python3 $path/scripts/mon2stv.py current_hor.bed $HOR >> stv_raw.bed
done < HOR_coords.bed

# stats files
python3 $path/scripts/bed2stat.py stv_raw.bed > stv_stats.tsv
python3 $path/scripts/stats2table.py stv_stats.tsv

# coloring
python3 $path/scripts/coloring.py stv_raw.bed > stv_colored.bed

# numbering
python3 $path/scripts/numbering.py stv_colored.bed > stv.bed

# add descriotion line
# sed -i "1 i\track name=\"ASat_StV\" description=\"ASat HORs Structural Variants\" itemRgb=\"On\" visibility=\"1\"" stv.bed

rm stv_colored.bed
rm current_hor.bed

