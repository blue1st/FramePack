FROM nvidia/cuda:13.0.1-devel-ubuntu24.04

ENV PYTHONUNBUFFERED 1
ENV DEBIAN_FRONTEND noninteractive

RUN apt update && \
    apt install -y --no-install-recommends \
    git \
    python3-dev \
    python3-pip \
    build-essential \
    cmake \
    libglib2.0-0 \
    libgl1 && \
    rm -rf /var/lib/apt/lists/*

RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

RUN pip install --no-cache-dir \
    torch \
    torchvision \
    torchaudio \
    --index-url https://download.pytorch.org/whl/cu130 \
    --break-system-packages

RUN git clone --recursive https://github.com/facebookresearch/xformers.git /opt/xformers && \
    cd /opt/xformers && \
    pip install --no-cache-dir -v . --break-system-packages

RUN pip install --no-cache-dir packaging --break-system-packages && \
    pip install --no-cache-dir flash-attn --no-build-isolation --break-system-packages

RUN pip install sageattention==1.0.6 --break-system-packages

WORKDIR /app
ADD . /app
RUN pip install -r requirements.txt \
    --break-system-packages

CMD ["python", "demo_gradio.py", "--server=0.0.0.0", "--port=7860"]
