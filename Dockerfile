FROM continuumio/miniconda3:4.10.3
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG C.UTF-8  
ENV LC_ALL C.UTF-8

# Update and create base image
RUN apt-get update -y &&\
    apt-get install -y gcc g++ make libz-dev &&\
    apt-get clean

# Install OnTAD
RUN cd /opt && git clone https://github.com/anlin00007/OnTAD.git &&\
    cd OnTAD &&\
    git checkout 3da5d9a4569b1f316d4508e60781f22f338f68b1
RUN              cd /opt/OnTAD/src && make clean && make
ENV PATH="/opt/OnTAD/src:${PATH}"

# Install ngs_base environment
ADD gerlich_base.yml /temp/install/

# install mamba
RUN conda install mamba -n base -c conda-forge &&\
    mamba env update -n base --f /temp/install/gerlich_base.yml &&\
    mamba list > software_versions_conda.txt &&\
    # Install mirnylabtools
    # bioframe
    # githash=`git ls-remote https://github.com/mirnylab/bioframe.git | grep HEAD | cut -f 1` &&\
    # pip install git+git://github.com/mirnylab/bioframe@$githash &&\
    # echo "# pip install git+git://github.com/mirnylab/bioframe@$githash" >> software_versions_git.txt &&\
    # cooltools
    # githash=`git ls-remote https://github.com/mirnylab/cooltools.git | grep HEAD | cut -f 1` &&\
    # pip install git+git://github.com/mirnylab/cooltools@$githash &&\
    # echo "# pip install git+git://github.com/mirnylab/cooltools@$githash" >> software_versions_git.txt &&\
    # pairlib
    githash=`git ls-remote https://github.com/mirnylab/pairlib.git | grep HEAD | cut -f 1` &&\
    pip install git+git://github.com/mirnylab/pairlib@$githash &&\
    echo "# pip install git+git://github.com/mirnylab/pairlib@$githash" >> software_versions_git.txt &&\
    # Install gerlich repos and safe the latest git hash
    # ngs
    pip install git+git://github.com/gerlichlab/ngs &&\
    # cooler_ontad
    githash=`git ls-remote https://github.com/cchlanger/cooler_ontad.git | grep HEAD | cut -f 1` &&\
    pip install git+git://github.com/cchlanger/cooler_ontad@$githash &&\
    echo "# pip install git+git://github.com/cchlanger/cooler_ontad@$githash" >> software_versions_git.txt &&\
    # higlassup
    githash=`git ls-remote https://github.com/gerlichlab/higlassupload.git | grep HEAD | cut -f 1` &&\
    pip install git+git://github.com/gerlichlab/higlassupload.git@$githash &&\
    echo "# pip install git+git://github.com/gerlichlab/higlassupload.git@$githash" >> software_versions_git.txt

WORKDIR /home

#User for VBC Jupyter Hub

ENV NB_USER jovian
ENV NB_UID 1000
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

USER jovian

ENV PATH=/opt/conda/bin:${PATH}

CMD ["/bin/bash"]