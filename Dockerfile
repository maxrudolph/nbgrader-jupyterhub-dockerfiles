FROM continuumio/miniconda3
MAINTAINER Max Rudolph <maxrudolph@ucdavis.edu>

RUN apt-get -y update
RUN apt-get -y install apt-utils
RUN apt-get -y upgrade
RUN apt-get -y install sudo ssl-cert npm sudo ca-certificates python3-pip git wget ffmpeg
RUN apt-get -y install python3-gdal libgeos-dev libgeos++-dev libproj-dev
RUN npm install -g configurable-http-proxy
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y tzdata
RUN ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata
RUN apt-get -y install python3-opencv
RUN apt-get -y install libspatialindex-dev

ENV PIP=conda
ENV PYTHON=python3
RUN $PIP install python==3.8.11
#RUN $PIP install --upgrade pip
RUN $PIP install -c conda-forge jupyter_client==6.1.12 nbconvert==5.6.1 jupyterhub tornado traitlets==4.3.3 jupyter nbgrader
RUN $PIP install -c conda-forge numpy scipy matplotlib ipython pandas sympy nose cartopy cython rasterio scikit-image scikit-learn pyproj utm geopy tqdm xlrd libcomcat multiprocess tabulate obspy
#RUN conda create -n comcat --channel conda-forge python=3
#RUN conda activate comcat
#RUN conda config --add channels conda-forge
#RUN $PIP install nbgrader
#RUN pip install git+git://github.com/jupyter/nbgrader.git
#git://github.com/jupyter/nbgrader.git
RUN jupyter nbextension install --sys-prefix --py nbgrader --overwrite
RUN jupyter nbextension enable --sys-prefix --py nbgrader
RUN jupyter serverextension  enable --sys-prefix --py nbgrader

#RUN $PIP install oauthenticator
RUN conda install -c conda-forge oauthenticator

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
ADD distribute_file.py /srv/nbgrader/GEL240-Fall2021/distribute_file.py
ADD archive_home_directories.py /srv/nbgrader/GEL240-Fall2021/archive_home_directories.py
# expose port for https
EXPOSE 443
# expose port for formgrader
#EXPOSE 9999

WORKDIR /srv/nbgrader/GEL240-Fall2021

# Enforce user numbering starting at 9000 to not conflict with host system
RUN echo "UID_MIN 9000" >> /etc/login.defs

WORKDIR /srv/nbgrader/GEL240-Fall2021
#ADD nbgrader_config.py /srv/nbgrader/GEL160-Fall2019
ADD run_jupyterhub.sh /srv/jupyterhub_config/run_jupyterhub.sh
RUN chmod 700 /srv/jupyterhub_config/run_jupyterhub.sh

ENTRYPOINT ["/srv/jupyterhub_config/run_jupyterhub.sh"]
