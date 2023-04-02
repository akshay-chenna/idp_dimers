# Purpose: RosettaDock 4 low resolution only protocol
# Created: AKSHAY CHENNA on 14th February 2020

cd /home/chemical/phd/chz198152/scratch/rosetta/benchmarks/
module load apps/Rosetta/2020.03/intel2019

#np=80 				# Number of parallel processes
nstruct=800			# Number of decoys to be generated
name=lowres800			# Name of all generated files and folders except *.pdb
infile=in11_0001.pdb 		# Docked input for reference

######### DO NOT TAMPER BEYOND THIS POINT #############
mkdir $name'pdbs'

mpirun -np $PBS_NTASKS $ROSETTA_BIN/docking_protocol.mpi.linuxiccrelease -database $ROSETTA_DB -in:file:s $infile \
-randomize1 -randomize2 -spin \
-nstruct $nstruct \
-ensemble1 list_en -ensemble2 list_en \
-dock_pert 3 8 -dock_mcm_trans_magnitude 0.1 -dock_mcm_rot_magnitude 5.0 \
-docking_low_res_score motif_dock_score -mh:path:scores_BB_BB $ROSETTA_DB/additional_protocol_data/motif_dock/xh_16_ -mh:score:use_ss1 false -mh:score:use_ss2 false -mh:score:use_aa1 true -mh:score:use_aa2 true \
-use_input_sc \
-low_res_protocol_only \
-score:docking_interface_score 1 \
-out:file:scorefile $name'.sc'  \
-out:path:pdb ./$name'pdbs'/. \
-ignore_zero_occupancy false \
-show_accessed_options \
-protein_dielectric 8 -water_dielectric 80 \
-out:level 300 -mute protocols.docking -mpi_tracer_to_file $name'.log' >> $name'.options' \
-docking:temperature 30

grep real_seed $name'.log'* | awk '{ print $NF }' >> $name'.seed' 	# Save seeds to rerun with -jran option

mkdir $name'logs'
mv *.log_* $name'logs'/.

<< 'END'
-mute protocols.docking
-out:file:scorefile lowres.sc 
-out:show_accessed_options 
-out:level 300 
-out:file:fullatom 
-out:path:pdb ./lowrespdbs/. 
-ignore_zero_occupancy false
-mute core.util.prof
-mute all
-mute core.io.database
-set_pdb_author
-mpi_tracer_to_file run.log
-version true 
-timer true
-decoystats
-protein_dielectric 8
-water_dielectric 80
END 

