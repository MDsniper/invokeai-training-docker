# Use NVIDIA CUDA base image
FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/opt/conda/bin:$PATH"
ENV CONDA_PREFIX="/opt/conda"
ENV CONDA_DEFAULT_ENV="invoke-training"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /miniconda.sh && \
    bash /miniconda.sh -b -p /opt/conda && \
    rm /miniconda.sh

# Initialize conda in bash
RUN conda init bash && \
    echo "conda activate invoke-training" >> ~/.bashrc

# Create conda environment and install packages
RUN conda create -n invoke-training python=3.10 -y && \
    /opt/conda/envs/invoke-training/bin/python -m pip install --upgrade pip && \
    /opt/conda/envs/invoke-training/bin/pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# Set working directory
WORKDIR /app

# Clone and install invoke-training using the full path to pip
RUN git clone https://github.com/invoke-ai/invoke-training.git && \
    cd invoke-training && \
    /opt/conda/envs/invoke-training/bin/pip install -e ".[test]" --extra-index-url https://download.pytorch.org/whl/cu121

# Create directories for data and output
RUN mkdir -p /data /output

# Create the entrypoint script
RUN echo '#!/bin/bash' > /entrypoint.sh && \
    echo 'source /opt/conda/etc/profile.d/conda.sh' >> /entrypoint.sh && \
    echo 'conda activate invoke-training' >> /entrypoint.sh && \
    echo 'cd /app/invoke-training' >> /entrypoint.sh && \
    echo 'exec "$@"' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

WORKDIR /app/invoke-training

# Use explicit path for entrypoint
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
CMD ["invoke-train-ui", "--host", "0.0.0.0", "--port", "1234"]
