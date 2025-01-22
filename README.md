# InvokeAI Training Docker Environment

A containerized environment for training custom AI models with InvokeAI, specifically designed for machine learning enthusiasts and researchers using NVIDIA GPUs.

## Overview

This Docker setup provides a reproducible and isolated environment for training Stable Diffusion models using the InvokeAI training framework. It simplifies the complex process of setting up dependencies and ensures consistent performance across different systems.

## Prerequisites

Before getting started, ensure your system meets the following requirements:

### Hardware
- NVIDIA GPU (Recommended: RTX 3090 or equivalent)
- Minimum 16GB RAM
- Sufficient storage for model training (recommended 50GB+)

### Software
- Docker Engine (latest version)
- NVIDIA Container Toolkit
- Docker Compose
- CUDA-compatible NVIDIA GPU drivers

## Quick Start Guide

### 1. Clone the Repository
```bash
git clone https://github.com/MDsniper/invokeai-training-docker.git
cd invokeai-training-docker
