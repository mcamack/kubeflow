FROM 763104351884.dkr.ecr.us-west-2.amazonaws.com/tensorflow-training:2.2.0-cpu-py37-ubuntu18.04
# RUN apt update && apt install -y wget

# # Create a non-root user
# ARG username=user
# ARG uid=1000
# ARG gid=100
# ENV USER $username
# ENV UID $uid
# ENV GID $gid
# ENV HOME /home/$USER
# RUN adduser --disabled-password \
#     --gecos "Non-root user" \
#     --uid $UID \
#     --gid $GID \
#     --home $HOME \
#     $USER

# # Install miniconda
# RUN cd $HOME \
#     && wget -q https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/conda_install.sh \
#     && chmod +x conda_install.sh \
#     && ~/conda_install.sh -b -p $HOME/conda \
#     && ./conda/bin/pip install tfx

# ENV PATH="/home/user/conda/bin:$PATH"

RUN pip install tfx