#!/bin/bash
#This is a file to determine number of hbonds per water molecule
#To run this file in parallel do: seq 0 256127 | parallel ./run_hbond_parallel.sh
#To allow this script to run in parallel, a separate PDB file AB_*.pdb was made for each frame in the trajectory.
PDB_DIR= #set directory containing PDB files
d=0.4 #distance for defining shell

i=$1
#make general index file for all "usual" groups
echo 'q' | gmx_mpi make_ndx -f ${PDB_DIR}/G5_${i}.pdb -o index_general_${i}.ndx

#first get index with all waters within shell. NOTE: here shell is around protein or WATER
gmx_mpi select -s topol0.tpr -f ${PDB_DIR}/G5_${i}.pdb -os no.water_${i}.xvg -select 'resname SOL and within 0.4 of group "Prsotein" or resname SOL and within 0.4 of group "liga"' -n index_general_${i}.ndx -on no.water_${i}.ndx

#combine output of ndx file with other index file, make a new group for bulk
(echo '14&!17'; echo 'q') | gmx_mpi make_ndx -f ${PDB_DIR}/G5_${i}.pdb -n index_general_${i}.ndx no.water_${i}.ndx -o combo_${i}.ndx

#calculate protein-shell hbonds
echo 1 17 | gmx_mpi hbond -f ${PDB_DIR}/G5_${i}.pdb -s hbond.tpr -n combo_${i}.ndx -num pro_shell_${i}.xvg
proshell=$(awk 'END {print $2}' pro_shell_${i}.xvg)

#calculate shell-shell hbonds
echo 17 17 | gmx_mpi hbond -f ${PDB_DIR}/G5_${i}.pdb -s hbond.tpr -n combo_${i}.ndx -num shell_shell_${i}.xvg
shellshell=$(awk 'END {print $2}' shell_shell_${i}.xvg)

#calculate shell-bulk hbonds 
echo 17 18 | gmx_mpi hbond -f ${PDB_DIR}/G5_${i}.pdb -s hbond.tpr -n combo_${i}.ndx -num shell_bulk_${i}.xvg
shellbulk=$(awk 'END {print $2}' shell_bulk_${i}.xvg)

#calculate shell-drug hbonds
echo 17 13 | gmx_mpi hbond -f ${PDB_DIR}/G5_${i}.pdb -s hbond.tpr -n combo_${i}.ndx -num shell_drug_${i}.xvg
shelldrug=$(awk 'END {print $2}' shell_drug_${i}.xvg)

#calculate bulk-bulk hbonds  
echo 18 18 | gmx_mpi hbond -f ${PDB_DIR}/G5_${i}.pdb -s hbond.tpr -n combo_${i}.ndx -num bulk_bulk_${i}.xvg
bulkbulk=$(awk 'END {print $2}' bulk_bulk_${i}.xvg)

#calculate bulk-drug hbonds  
echo 18 13 | gmx_mpi hbond -f ${PDB_DIR}/G5_${i}.pdb -s hbond.tpr -n combo_${i}.ndx -num bulk_drug_${i}.xvg
bulkdrug=$(awk 'END {print $2}' bulk_drug_${i}.xvg)

#make file to parse for atom numbers for shell and bulk groups
echo 'q' | gmx_mpi make_ndx -n combo_${i}.ndx -o index_${i}.ndx > atoms_nums_${i}.out

#get total number of atoms for shell
shelltotat=$(awk -F ' ' 'NR==21{print $3}' atoms_nums_${i}.out)

#get total number of atoms for bulk
bulktotat=$(awk -F ' ' 'NR==22{print $3}' atoms_nums_${i}.out)
shellhbonds=$((${proshell} + 2*${shellshell} + ${shellbulk} + ${shelldrug}))
bulkhbonds=$((2*${bulkbulk} + ${shellbulk} + ${bulkdrug}))
echo ${i} ${shellhbonds} ${shelltotat} ${bulkhbonds} ${bulktotat} >> hbond_${i}.out

#remove files
rm index_general_${i}.ndx combo_${i}.ndx no.water_${i}.xvg no.water_${i}.ndx pro_shell_${i}.xvg shell_shell_${i}.xvg shell_bulk_${i}.xvg bulk_bulk_${i}.xvg atoms_nums_${i}.out index_${i}.ndx bulk_drug_${i}.xvg shell_drug_${i}.xvg
#done


	
