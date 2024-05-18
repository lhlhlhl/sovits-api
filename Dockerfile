FROM python:3.9-slim-buster

WORKDIR /app

COPY . /app
# RUN if [ -f /app/SoVITS_weights/xxx_e12_s96.pth ]; then echo "/app/SoVITS_weights/xxx_e12_s96.pth exists"; else echo "/app/SoVITS_weights/xxx_e12_s96.pth does not exist"; exit 1; fi
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential libmariadb-dev-compat libmariadb-dev gcc ffmpeg && \
    pip install --no-cache-dir -r requirements.txt && \
    python -m nltk.downloader averaged_perceptron_tagger cmudict


EXPOSE $MODEL_PORT

# 测试环境
# ENV CONFIG_NAME testing
CMD echo "python api2.py -a $MODEL_HOST -p $MODEL_PORT ${MODEL_S:+-s} $MODEL_S ${MODEL_G:+-g} $MODEL_G ${MODEL_DR:+-dr} $MODEL_DR ${MODEL_DT:+-dt} $MODEL_DT ${MODEL_DL:+-dl} $MODEL_DL"
CMD python api2.py -a $MODEL_HOST -p $MODEL_PORT ${MODEL_S:+-s} $MODEL_S ${MODEL_G:+-g} $MODEL_G ${MODEL_DR:+-dr} $MODEL_DR ${MODEL_DT:+-dt} $MODEL_DT ${MODEL_DL:+-dl} $MODEL_DL