#!/bin/bash
#SBATCH --cpus-per-task=6
#SBATCH --exclusive
#SBATCH -N 1


# Customize these parameters for your filesystem
# Path to your config file (also in this repo)
CROMWELLCONFIG=.../crom.config

# Database Details for a mySQL database
CROMWELLDBPORT=...
CROMWELLDBNAME=...
CROMWELLDBUSERNAME=...
CROMWELLDBPASSWORD=...

# Path to scratch space, or where you want the task working directories to be saved.
# This for us is something like a 90-day delete, no backup system, and then users
# can use workflow options to copy ONLY the designated final output files to their
# preferred long term storage space. 
SCRATCH=.../cromwell-executions

# Where you want all the workflow logs to be saved
WORKFLOWLOGDIR=.../cromwell-workflow-logs

# What port to use for the API/Swagger interface
PORT=2020


##########
# This is custom to Fred Hutch.  We use Easybuild modules for software on our SLURM cluster
# You will want to customize this to specify the path/access method to your Cromwell jar. 
source /app/Lmod/lmod/lmod/init/bash
module use /app/easybuild/modules/all
module purge

# Load the Cromwell Module you'd like
module load cromwell/49-Java-1.8
##########

# Run your server!
java -Xms4g \
    -Dconfig.file=${CROMWELLCONFIG} \
    -DLOG_MODE=pretty \
    -DLOG_LEVEL=INFO \
    -Dbackend.providers.SLURM.config.root=${SCRATCHSPACE} \
    -Ddatabase.db.url=jdbc:mysql://mydb:${CROMWELLDBPORT}/${CROMWELLDBNAME}?rewriteBatchedStatements=true \
    -Ddatabase.db.user=${CROMWELLDBUSERNAME} \
    -Ddatabase.db.password=${CROMWELLDBPASSWORD} \
    -Dworkflow-options.workflow-log-dir=${WORKFLOWLOGDIR} \
    -Dwebservice.port=${PORT} \
    -jar $EBROOTCROMWELL/cromwell-49.jar \
    server