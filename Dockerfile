# Please consult the README if you need help in selecting a base image
FROM rpy2/base-ubuntu:latest

# Create the application working directory
WORKDIR /opt/app

# Install and updated linux packages 
RUN apt-get update \
&& apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    git \
    make \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    libgl1-mesa-glx \
&& rm -rf /var/lib/apt/lists/*

# install R packages - modify or add any additional R packages as needed
RUN R -e "install.packages('jsonlite',dependencies=TRUE, repos='http://cran.rstudio.com/')"  

# install python
ENV PYTHON_VERSION=3.9.5 \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBTYECODE=1 \
    PYENV_ROOT="/.pyenv" \
    PATH="/.pyenv/bin:/.pyenv/shims:${PATH}"
RUN git clone --depth=1 https://github.com/pyenv/pyenv.git /.pyenv && \
    pyenv install ${PYTHON_VERSION} && \
    pyenv global ${PYTHON_VERSION}

# copy application files into the container image
# NOTE: to avoid overly large container size, only copy the files actually needed by
#       explicitly specifying the needed files with the `COPY` command or adjusting
#       the `.dockerignore` file to ignore unneeded files
COPY grpc_model ./grpc_model
COPY model_lib ./model_lib
COPY asset_bundle/0.1.0 ./asset_bundle/0.1.0

# environment variable to specify model server port
ENV PSC_MODEL_PORT=45000 \
    PATH=${PATH}:/home/modzy-user/.local/bin/

ARG CIRCLE_REPOSITORY_URL
LABEL com.modzy.git.source="${CIRCLE_REPOSITORY_URL}"

# Use pip directly to install Python and gRPC dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Kick off gRPC server at runtime
CMD ["python", "-m", "grpc_model.src.model_server"]

