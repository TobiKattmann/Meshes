#! /bin/bash

# ---------------------------------------------------------------------------- #
# Kattmann, 02.07.2019
# This script combines a number of .su2 meshes given over the command line
# ---------------------------------------------------------------------------- #

# Read in files via command line
while getopts f:o:d: option; do
  case $option
  in
    f) FILES+=(${OPTARG});;
    o) OUTPUT=${OPTARG};;
    d) DIMENSION=${OPTARG};;
  esac
done

# ---------------------------------------------------------------------------- #

# Check if OUTPUT-filename already exists, if not create file
if [ -e $OUTPUT ]; then
  echo "Output file '$OUTPUT' already exists. Aborting."; exit 1
else
  touch $OUTPUT
fi

# Write .su2 header once
echo "NDIME= $DIMENSION" >> $OUTPUT
echo -e "NZONE= ${#FILES[@]}" >> $OUTPUT

# Loop through FILES and write to OUTPUT
for i in `seq 1 ${#FILES[@]}`; do
  echo -e "\nIZONE= $i\n" >> $OUTPUT
  cat ${FILES[$i-1]} >> $OUTPUT
done

# ---------------------------------------------------------------------------- #

# Get rid of all ^M characters if single-zone mesh file were written under windows
# This is useful if file is displayed in vim under linux
sed -i -e "s///" $OUTPUT
