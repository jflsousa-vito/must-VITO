#!/bin/bash
#SBATCH --job-name=run_315
#SBATCH --nodes=2 --ntasks=48
#SBATCH --cpus-per-task=1
#SBATCH --mem=0
#SBATCH --time=24:00:00

#SBATCH -o stdout.%j
#SBATCH -e stderr.%j
#SBATCH --mail-type=FAIL    
#SBATCH --account=ap_vito_ei
#SBATCH --partition=zen2

#module load OpenFOAM/6-intel-2020a

ml OpenFOAM/v2406-foss-2023a 
source $FOAM_BASH


#cd /scratch/antwerpen/grp/avito_map/UrbanAir/MUST/data/cases/case0_WT_fine_fine/run/run_315

echo "decomposing..."
#mpirun -np 4 redistributePar -decompose -parallel > log.decomposePar # this is done locally now

#decomposePar > log.decomposePar # this is done locally now
#rm -r log.snappyHexMesh

echo "running..."

#mpirun -np 48 scalarsimpleFoam -parallel > log.scalarSimpleFoam
srun simpleFoam -parallel > log.scalarSimpleFoam

echo "Reconstruncting..."
mpirun -np 4 redistributePar -reconstruct -parallel


#reconstructParMesh -constant
#reconstructPar -constant
[[ -d 6000 ]] && rm -r processor*
#options
touch RunConcluded.txt
echo "Done..."