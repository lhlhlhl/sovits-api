FROM python:3.9-slim-buster

WORKDIR /app

COPY . /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential libmariadb-dev-compat libmariadb-dev gcc && \
    pip install --no-cache-dir -r requirements.txt

EXPOSE $MODEL_PORT

# 测试环境
# ENV CONFIG_NAME testing

CMD python api2.py -a $MODEL_HOST -p $MODEL_PORT ${MODEL_S:+-s} $MODEL_S ${MODEL_G:+-g} $MODEL_G ${MODEL_G:+-dr} $MODEL_DR ${MODEL_G:+-dt} $MODEL_DT$ {MODEL_G:+-dl} $MODEL_DL