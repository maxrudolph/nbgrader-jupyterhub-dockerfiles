#FROM mambaorg/micromamba
FROM condaforge/mambaforge
MAINTAINER Max Rudolph <maxrudolph@ucdavis.edu>
USER root
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update
RUN apt-get -y install apt-utils
RUN apt-get -y upgrade
RUN apt-get -y install sudo ssl-cert npm sudo ca-certificates python3-pip git wget ffmpeg nano less htop
RUN apt-get -y install python3-gdal libgeos-dev libgeos++-dev libproj-dev
RUN npm install -g configurable-http-proxy
RUN apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata
#RUN conda update conda
RUN conda install -c conda-forge mamba
#RUN conda update -n base -c defaults conda
#RUN conda install -c conda-forge mamba
ENV PIP=mamba
ENV PYTHON=python3
#RUN $PIP install python==3.8.11
#RUN conda update conda
#RUN $PIP install --upgrade pip
#RUN conda install -c conda-forge julia==1.7.1 "openlibm<0.8.0" "libcurl==7.80"
#RUN $PIP install -c conda-forge jinja2==3.0.3
#RUN $PIP install -c conda-forge jupyter_client==6.1.12 nbconvert==5.6.1 
#RUN $PIP install -c conda-forge jupyterhub==1.5.0 
#RUN $PIP install -c conda-forge tornado 
#RUN $PIP install -c conda-forge traitlets==4.3.3 
RUN $PIP install jupyter 
RUN $PIP install -c conda-forge nbgrader
RUN $PIP install -c conda-forge numpy scipy matplotlib ipython pandas sympy 
RUN $PIP install -c conda-forge nose 
RUN $PIP install -c conda-forge cartopy 
RUN $PIP install -c conda-forge cython 
RUN $PIP install -c conda-forge rasterio 
RUN $PIP install -c conda-forge opencv
RUN $PIP install -c conda-forge scikit-image 
RUN $PIP install -c conda-forge scikit-learn 
RUN $PIP install -c conda-forge pyproj utm geopy tqdm xlrd libcomcat multiprocess tabulate obspy
RUN $PIP install -c conda-forge rasterio
WORKDIR /opt
RUN wget https://julialang-s3.julialang.org/bin/linux/x64/1.9/julia-1.9.3-linux-x86_64.tar.gz
RUN tar xvzf julia-1.9.3-linux-x86_64.tar.gz
ENV PATH="/opt/julia-1.9.3/bin:${PATH}"
RUN julia -e "using Pkg; Pkg.add(\"IPython\")"
RUN julia -e "using Pkg; Pkg.build(\"IPython\")"
RUN $PIP install -c conda-forge jupyterhub
#==1.5.0
RUN $PIP install nest-asyncio
RUN apt-get -y install python3-opencv
RUN apt-get -y install libspatialindex-dev
RUN $PIP install -c conda-forge librosa
# Uncomment to get a development version of nbgrader (BAD idea for an actual class!)
#RUN pip install git+git://github.com/jupyter/nbgrader.git
#git://github.com/jupyter/nbgrader.git
RUN jupyter nbextension install --sys-prefix --py nbgrader --overwrite
RUN jupyter nbextension enable --sys-prefix --py nbgrader
RUN jupyter serverextension  enable --sys-prefix --py nbgrader

#RUN $PIP install oauthenticator
RUN $PIP install -c conda-forge oauthenticator

# make directories for nbgrader and jupyterhub files
RUN mkdir /srv/jupyterhub_config
RUN mkdir /srv/nbgrader
RUN mkdir /srv/nbgrader/exchange
RUN chmod 777 /srv/nbgrader/exchange

# make directory for user home directories
RUN mkdir /srv/home

# OAUTH STUFF
RUN mkdir /srv/oauthenticator
WORKDIR /srv/oauthenticator
ADD userlist /srv/oauthenticator/userlist
RUN chmod 700 /srv/oauthenticator
ADD addusers.py /srv/oauthenticator/addusers.py

# SSL STUFF
ADD privkey.pem /etc/ssl/private/private.key
ADD fullchain.pem /etc/ssl/certs/cert.crt
RUN chown -R root:root /etc/ssl/certs
RUN chown -R root:ssl-cert /etc/ssl/private
RUN chmod 644 /etc/ssl/certs/*
RUN chmod 640 /etc/ssl/private/*
RUN c_rehash
RUN update-ca-certificates

# Add config files for jupyterhub
ADD jupyterhub_config.py /srv/jupyterhub_config/jupyterhub_config.py
ADD global_nbgrader_config.py /etc/jupyter/nbgrader_config.py
ADD grader_nbgrader_config.py /srv/jupyterhub_config/grader_nbgrader_config.py

# Add config file to enable julia kernel for each user
ADD install_ijulia.jl /srv/install_ijulia.jl

# expose port for https
EXPOSE 443
# expose port for formgrader
#EXPOSE 9999

WORKDIR /srv/nbgrader/GEL240-Winter2023

# Enforce user numbering starting at 9000 to not conflict with host system
RUN echo "UID_MIN 9000" >> /etc/login.defs

ADD run_jupyterhub.sh /srv/jupyterhub_config/run_jupyterhub.sh
RUN chmod 700 /srv/jupyterhub_config/run_jupyterhub.sh

ENTRYPOINT ["/srv/jupyterhub_config/run_jupyterhub.sh"]
