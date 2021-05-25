FROM continuumio/miniconda3:4.9.2
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8  
ENV LC_ALL C.UTF-8

# Update and create base image
RUN apt-get update -y &&\
    apt-get install -y gcc g++ make libz-dev &&\
    apt-get clean

# Install ngs_base environment
ADD ngs_base.yml /temp/install/

# install mamba
RUN conda install mamba -n base -c conda-forge &&\
    mamba env update -n base --f /temp/install/ngs_base.yml &&\
    mamba list > software_versions_conda.txt &&\
    # Install mirnylabtools
    # bioframe
    githash=`git ls-remote https://github.com/mirnylab/bioframe.git | grep HEAD | cut -f 1` &&\
    pip install git+git://github.com/mirnylab/bioframe@$githash &&\
    echo "# pip install git+git://github.com/mirnylab/bioframe@$githash" >> software_versions_git.txt &&\
    # cooltools
    githash=`git ls-remote https://github.com/mirnylab/cooltools.git | grep HEAD | cut -f 1` &&\
    pip install git+git://github.com/mirnylab/cooltools@$githash &&\
    echo "# pip install git+git://github.com/mirnylab/cooltools@$githash" >> software_versions_git.txt &&\
    # pairlib
    githash=`git ls-remote https://github.com/mirnylab/pairlib.git | grep HEAD | cut -f 1` &&\
    pip install git+git://github.com/mirnylab/pairlib@$githash &&\
    echo "# pip install git+git://github.com/mirnylab/pairlib@$githash" >> software_versions_git.txt

WORKDIR /home

CMD /bin/bash