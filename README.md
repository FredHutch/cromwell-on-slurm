# cromwell-on-slurm
Info related to running a Cromwell server on a SLURM cluster.

This repo contains the basics of a Cromwell config setup that has been tested and works on the Fred Hutch SLURM cluster.  Your results may vary.  


```
sbatch runMe.sh
```


## Structure of This

Our setup involves sbatch'ing the server job to a node on our cluster.  Then using the API to deploy individual workflows.  The "head node"/server node then does all of the metadata management and workflow coordination, call caching, etc, and sends off to the SLURM queue, each individual task in the workflows sent to it.

[We have a range of node types available to us](https://sciwiki.fredhutch.org/scicomputing/compute_platforms/#gizmo) via our SLURM cluster called GIZMO.  This allows us to procure a single node for the server coordination tasks and then request task-specific resources as needed (so CPU/memory is tailored to each task instead of a blanket request and working inside that allocation).  This, for us, allows us to not battle with the priority scoring aspects of our shared SLURM cluster.  This means we can get more through, more efficiently, thus reducing delays for any given workflow and reducing the need to burst into cloud computing.  

## Software
We have an [Easybuild](https://fredhutch.github.io/easybuild-life-sciences/) setup to provide software modules on our SLURM cluster.  Thus, I have added a parameter to the runtime block called `modules` which is a space separated string of modules you want loaded for each individual task.  Also in the `submit` portion of the SLURM backend you'll see that modules are purged, then the desired modules are loaded before the task is sent.  


## Singularity
For our users, we'd like the same workflow to be deployable to the cloud as it is on premise.  For that we are working through the challenges of working with Singularity.  For now, the `submit-docker` portion of the config seems to work ok at least and not unnecessarily convert docker to sif when the sif already exists.  This is not well tested though, and so this portion likely will change/be updated. 
