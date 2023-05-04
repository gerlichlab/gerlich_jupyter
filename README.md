# Gerlich Jupyter
**Gerlich Jupyter** This is the the Gerlich group base container for [JupyterHub](https://jupyterhub.vbc.ac.at/), with all internally used NGS and image analysis tools preinstalled.

# Startup on VBC JupyterHub

You can run use this container on [JupyterHub](https://jupyterhub.vbc.ac.at/).
To set it up, use the following settings.
 - After authenticating on JupyterHub and clicking "Add New Server" on the hub homepage, select `JupyterLab based on custom Singularity image (EXPERIMENTAL)`
 - Type in the link to the image location, you can find a link in the [changelog](./changelog.md)
 - **Attention:** You do not need to contact IT. We set everything up for you!


![JupyterHub Settings](images/settings.png)


You change the version by changing the image URL past the double colon:
`.../gerlichlab/jupyter-gerlich:YOUR_FAVORITE_VERSION`

or <span style="color:red">**copy and past the link from the version subsection bellow.**<span>
 
**Please for now use the chached location!**

Once the server is started, do not choose a specific kernel. Rather, choose the basic Python3 kernel.


![Python Kernel](images/kernel.png)


It will contain everything installed in the container.

# Running the notebook locally (OPTIONAL)
For your convenience, you can then start a notebook server with all the necessary libraries installed with:
`docker-compose up` from the command line in the directory of this rpository.
Then open up a browser and navigate to http://localhost:9999 or http://localhost:9999/lab for the jupyter lab interface. 
This will prompt you for a password, which we disclosed in the python club lecture.

If you use this setup more regularly, please change the password in the jupyter_notebook_config.py

# Connecting the local notebook to VSCode 
A brief description by Michael can be found [here](https://github.com/gerlichlab/python_club_seq_formats_I).

# How do I get a custom version?
 
1. Fork the repository
1. Create a new branch
1. Modify the [gerlich_base.yml](./gerlich_base.yml) (e.g., add all your missing libraries or change the version of the libraries)
1. Test your build by running: `docker-compose -f docker-dev.yml up`
1. Test your notebook in the browser: `http://localhost:9999`
1. Pushing your branch will create a pull request. Add a description for your version, including what is different from the base version and why it was created. The description can be extended and modified on the GitHub homepage.
1. Contact Christoph or Michael. We will give it a new version number and make it available on JupyterHub, at `jupyterhub.vbc.ac.at`
