cd $PBS_O_WORKDIR
folder=docked_ensemble
destination=ensemble_dock
rsync -avruph ${folder} /home/chemical/phd/chz198152/backup_may_2022/${destination}/
