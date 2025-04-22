FROM python:3.10

WORKDIR /app

ADD . /app

RUN apt -y update \
  && apt -y install libopencv-dev\
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && pip install --upgrade pip \
  && pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu126 \
  && pip install -r requirements.txt 

CMD ["python", "demo_gradio.py", "--server=0.0.0.0", "--port=7860"]
