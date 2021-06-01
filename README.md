# Gerlich Jupyter
Our base container with all internally used NGS and image analysis tools preinstalled.

# Running the notebook
For your convenience, you can then start a notebook server with all the necessary libraries installed with:
```docker-compose up``` from the command line in the repo directory.
Then just open up a browser and navigate to http://localhost:9999 or http://localhost:9999/lab for the jupyter lab interface. 
This will prompt you for a password, which was disclosed in the python club lecture.

If you use this setup more regularly, please change the password in the jupyter_notebook_config.py

# VBC JupterHub

You can use this container on ```https://jupyterhub.vbc.ac.at/```. A more detailed description will follow soon.

# Connecting the notebook to VSCode 
A brief description by Michael can be found [here](https://github.com/gerlichlab/python_club_seq_formats_I).

# Versions

This repo will, in the future, contain versioned containers and alternative builds.
Currently, we only keep the latest build.
