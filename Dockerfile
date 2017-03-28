FROM library/ubuntu
MAINTAINER Max Rudolph <rmaxwell@pdx.edu>

RUN apt-get -y update
RUN apt-get -y install sudo apt-utils ssl-cert npm nodejs-legacy sudo ca-certificates python3-pip git wget
RUN npm install -g configurable-http-proxy

ENV PIP=pip3
ENV PYTHON=python3
RUN $PIP install --upgrade pip

RUN $PIP install --upgrade numpy scipy matplotlib ipython jupyter pandas sympy nose
RUN $PIP install --upgrade jupyterhub
#RUN yes | $PIP uninstall jupyterhub

#WORKDIR /src
#RUN git clone https://github.com/jupyterhub/jupyterhub
#WORKDIR /src/jupyterhub
#RUN $PYTHON setup.py js && $PIP install . && \
#    rm -rf $PWD ~/.cache ~/.npm

RUN $PIP install nbgrader
RUN jupyter nbextension install --sys-prefix --py nbgrader
RUN jupyter nbextension enable --sys-prefix --py nbgrader
RUN jupyter serverextension  enable --sys-prefix --py nbgrader

RUN $PIP install oauthenticator
RUN $PIP install numpy matplotlib

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
ADD hood.geology.pdx.edu.key /etc/ssl/private/private.key
ADD hood.geology.pdx.edu.crt /etc/ssl/certs/cert.crt
RUN chown -R root:root /etc/ssl/certs
RUN chown -R root:ssl-cert /etc/ssl/private
RUN chmod 644 /etc/ssl/certs/*
RUN chmod 640 /etc/ssl/private/*
RUN c_rehash
RUN update-ca-certificates

ADD jupyterhub_config.py /srv/jupyterhub_config/jupyterhub_config.py

# includes nbgrader_config.py: (now accomplished using docker volume)

# expose port for https
EXPOSE 443
# expose port for formgrader
EXPOSE 9000

WORKDIR /srv/nbgrader/g326-2017

# Enforce user numbering starting at 9000 to not conflict with host system
RUN echo "UID_MIN 9000" >> /etc/login.defs

WORKDIR /srv/nbgrader/g326-2017
ADD run_jupyterhub.sh /srv/jupyterhub_config/run_jupyterhub.sh
RUN chmod 700 /srv/jupyterhub_config/run_jupyterhub.sh

ENTRYPOINT ["/srv/jupyterhub_config/run_jupyterhub.sh"]