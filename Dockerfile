#FROM jupyterhub/jupyterhub

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
#RUN $PIP install os

RUN mkdir /srv/jupyterhub_config
RUN mkdir /srv/nbgrader
RUN mkdir /srv/nbgrader/exchange
RUN chmod 777 /srv/nbgrader/exchange

# OAUTH STUFF
RUN mkdir /srv/oauthenticator
WORKDIR /srv/oauthenticator
ADD userlist /srv/oauthenticator/userlist
RUN chmod 700 /srv/oauthenticator

ADD hood.geology.pdx.edu.key /etc/ssl/private/private.key
ADD hood.geology.pdx.edu.crt /etc/ssl/certs/cert.crt
RUN chown -R root:root /etc/ssl/certs
RUN chown -R root:ssl-cert /etc/ssl/private
RUN chmod 644 /etc/ssl/certs/*
RUN chmod 640 /etc/ssl/private/*
RUN c_rehash
RUN update-ca-certificates

ADD jupyterhub_config.py /srv/jupyterhub_config/jupyterhub_config.py
#ADD nbgrader_config.py /srv/nbgrader/nbgrader_config.py

# includes nbgrader_config.py:
ADD g326-2017 /srv/nbgrader/g326-2017


# expose port for https
EXPOSE 443
# expose port for formgrader
EXPOSE 9000
EXPOSE 5000

WORKDIR /srv/nbgrader
#RUN nbgrader quickstart g326-2017
WORKDIR /srv/nbgrader/g326-2017

RUN nbgrader assign ps1
RUN nbgrader release ps1

ADD addusers.sh /srv/oauthenticator/addusers.sh
RUN ["sh","/srv/oauthenticator/addusers.sh","/srv/oauthenticator/userlist"]

WORKDIR /srv/nbgrader/g326-2017
#ENTRYPOINT ["pwd"]
ENTRYPOINT ["jupyterhub","-f","/srv/jupyterhub_config/jupyterhub_config.py", "--debug"]
