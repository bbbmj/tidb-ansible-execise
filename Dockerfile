FROM python:3.7-slim AS build

# Install tools required to build the project
# We need to run `docker build --no-cache .` to update those dependencies
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple pipenv

# These layers are only re-built when pip files are updated
COPY Pipfile.lock Pipfile /tidb-ansible/
WORKDIR /tidb-ansible/

# Install library dependencies
RUN PIPENV_VENV_IN_PROJECT=true pipenv install --pypi-mirror https://pypi.tuna.tsinghua.edu.cn/simple

# Copy all project and build it
# This layer is rebuilt when ever a file has changed in the project directory
COPY . /tidb-ansible/

# This results in a single layer image
FROM python:3.7-slim
COPY --from=build /tidb-ansible /tidb-ansible

# Install tools ansible needs
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y openssh-client sshpass iputils-ping vim --no-install-recommends && \
  rm -rf /var/lib/apt/lists/*

ENV PATH /tidb-ansible/.venv/bin:$PATH
WORKDIR /tidb-ansible/
