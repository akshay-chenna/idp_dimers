cd $PBS_O_WORKDIR

rsync -avruph --exclude '/home/chemical/phd/chz198152/scratch/IDP/rosetta'  ~/scratch/ /home/chemical/phd/chz198152/backup_may_2022/.
