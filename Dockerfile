FROM continuumio/miniconda3:24.5.0-0

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
ENV PATH=/opt/conda/bin:$PATH

# System deps: build tools for OnTAD, git for cloning, and zlib headers
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        zlib1g-dev \
        git \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install OnTAD (pinned commit)
RUN cd /opt && git clone https://github.com/anlin00007/OnTAD.git && \
    cd OnTAD && \
    git checkout 3da5d9a4569b1f316d4508e60781f22f338f68b1
RUN cd /opt/OnTAD/src && make clean && make
ENV PATH=/opt/OnTAD/src:$PATH

# Add conda environment spec
ADD gerlich_base.yml /temp/install/

# Update the environment using conda
RUN conda env update -n base --file /temp/install/gerlich_base.yml && \
    conda list > software_versions_conda.txt

# Install Python packages from GitHub
RUN githash=$(git ls-remote https://github.com/cchlanger/cooler_ontad.git | grep HEAD | cut -f 1) && \
    pip install --no-cache-dir git+https://github.com/cchlanger/cooler_ontad@${githash} && \
    echo "# pip install git+https://github.com/cchlanger/cooler_ontad@${githash}" >> software_versions_git.txt && \
    githash=$(git ls-remote https://github.com/gerlichlab/linescan.git | grep HEAD | cut -f 1) && \
    pip install --no-cache-dir git+https://github.com/gerlichlab/linescan@${githash} && \
    echo "# pip install git+https://github.com/gerlichlab/linescan@${githash}" >> software_versions_git.txt

WORKDIR /home

# User for VBC Jupyter Hub
ENV NB_USER=jovian
ENV NB_UID=1000
ENV HOME=/home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

USER jovian

CMD ["/bin/bash"]