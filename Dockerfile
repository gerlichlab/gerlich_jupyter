FROM mambaorg/micromamba:1.5.8

# Use root + plain bash for system packages to avoid privilege drop
USER root
SHELL ["/bin/bash", "-lc"]

# System deps
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        zlib1g-dev \
        git \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Build OnTAD as root (writes under /opt)
RUN git clone https://github.com/anlin00007/OnTAD.git /opt/OnTAD && \
    cd /opt/OnTAD && \
    git checkout 3da5d9a4569b1f316d4508e60781f22f338f68b1 && \
    make -C src clean && make -C src
ENV PATH=/opt/OnTAD/src:$PATH

# Hand env file to the unprivileged user
ARG MAMBA_USER=mambauser
COPY --chown=${MAMBA_USER}:${MAMBA_USER} gerlich_base.yml /tmp/gerlich_base.yml

# Switch back to the micromamba wrapper shell for conda-style activation
SHELL ["/usr/local/bin/_dockerfile_shell.sh"]
USER ${MAMBA_USER}

# Create a named env (don’t touch base)
RUN micromamba env create -y -n gerlich -f /tmp/gerlich_base.yml && \
    micromamba clean -a -y

# Snapshot the environment (pre-pip)
RUN micromamba list -n gerlich > /home/software_versions_conda_pre_pip.txt && \
    micromamba env export -n gerlich > /home/environment_pre_pip.lock.yml 

# Ensure the env’s bin comes first at runtime
ENV PATH=/opt/conda/envs/gerlich/bin:$PATH

# Do pip installs INTO that env
# Use micromamba run -n <env> to guarantee the right Python/pip is used
RUN githash=$(git ls-remote https://github.com/cchlanger/cooler_ontad.git | grep HEAD | cut -f 1) && \
    micromamba run -n gerlich pip install --no-cache-dir "git+https://github.com/cchlanger/cooler_ontad@${githash}" && \
    echo "# pip install git+https://github.com/cchlanger/cooler_ontad@${githash}" >> software_versions_git.txt && \
    githash=$(git ls-remote https://github.com/gerlichlab/linescan.git | grep HEAD | cut -f 1) && \
    micromamba run -n gerlich pip install --no-cache-dir "git+https://github.com/gerlichlab/linescan@${githash}" && \
    echo "# pip install git+https://github.com/gerlichlab/linescan@${githash}" >> software_versions_git.txt

# If you need a specific runtime user:
# Note: micromamba image already has mambauser with UID 1000.
# If you must use 'jovian', pick a different UID to avoid collision.
# USER root
# RUN useradd -m -u 1001 -s /bin/bash jovian && \
#     usermod -aG users jovian
# USER jovian

WORKDIR /home
CMD ["/bin/bash"]