#######################
#### BUILDER IMAGE ####
#######################

FROM ubuntu:18.04 as builder

# set work directory
WORKDIR /usr/src/app
COPY ./requirements.txt .

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install system dependenices
RUN apt update && apt install -y wget

# install dependencies
RUN cd $HOME \
    && wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/conda_install.sh \
    && chmod +x conda_install.sh \
    && ~/conda_install.sh -b -p $HOME/conda \
    && rm conda_install.sh 
    # \
    # && ./conda/bin/pip install tfx

RUN ls -al $HOME/conda/bin
ENV PATH="/home/root/conda/bin:$PATH"

# install python dependencies
RUN $HOME/conda/bin/pip wheel --no-cache-dir --wheel-dir /usr/src/app/wheels -r requirements.txt

#####################
#### FINAL IMAGE ####
#####################

FROM ubuntu:18.04

# Create a non-root user
ARG username=app
ARG uid=1000
ARG gid=100
ENV USER $username
ENV UID $uid
ENV GID $gid
ENV HOME /home/$USER
RUN adduser --disabled-password \
    --gecos "Non-root user" \
    --uid $UID \
    --gid $GID \
    --home $HOME \
    $USER

# # chown all the files to the app user
# RUN chown -R app:app $HOME
# RUN chown -R app:app /home/root/conda

# install dependencies
# install system dependenices
RUN apt update \
    && apt install -y wget \
    && cd $HOME \
    && wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/conda_install.sh \
    && chmod +x conda_install.sh \
    && ~/conda_install.sh -b -p $HOME/conda \
    && rm conda_install.sh 

# install python dependencies
COPY --from=builder /usr/src/app/wheels /wheels
COPY --from=builder /usr/src/app/requirements.txt .
RUN $HOME/conda/bin/pip install --upgrade pip
RUN $HOME/conda/bin/pip install --no-cache /wheels/*

# run container as non-root
USER app
ENV PATH="/home/app/conda/bin:$PATH"