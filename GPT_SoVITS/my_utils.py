import logging
import os
from io import BytesIO
import boto3
import ffmpeg
import numpy as np
from botocore.exceptions import NoCredentialsError
AWS_ACCESS_KEY_ID = os.environ['AWS_ACCESS_KEY_ID']
AWS_SECRET_ACCESS_KEY = os.environ['AWS_SECRET_ACCESS_KEY']
def get_audio_from_s3(bucket_name, s3_key):
    s3 = boto3.client('s3', aws_access_key_id=AWS_ACCESS_KEY_ID,
                      aws_secret_access_key=AWS_SECRET_ACCESS_KEY)
    try:
        obj = s3.get_object(Bucket=bucket_name, Key=s3_key)
    except NoCredentialsError:
        logging.warning("No AWS credentials were found.")
        return None
    except FileNotFoundError:
        logging.warning(f"The file {s3_key} was not found")
        return None
    audio_data = obj['Body'].read()
    audio_file = BytesIO(audio_data)
    return audio_file

def load_audio(file, sr):

    try:
        # file = get_audio_from_s3('oz-cloud-bucket', file)
        print("=========")
        print(type(file))
        print("=========")
        # out, _ = (
        #     ffmpeg.input(file, threads=0)
        #     .output("-", format="f32le", acodec="pcm_f32le", ac=1, ar=sr)
        #     .run(cmd=["ffmpeg", "-nostdin"], capture_stdout=True, capture_stderr=True)
        # )
        file.seek(0)
        out, _ = (
            ffmpeg.input('pipe:0', threads=0)
            .output('-', format='f32le', acodec='pcm_f32le', ac=1, ar=sr)
            .run(input=file.read(), cmd=['ffmpeg', '-nostdin'], capture_stdout=True, capture_stderr=True)
        )
    except Exception as e:
        print(file)
        raise RuntimeError(f"Failed to load audio: {e}")

    return np.frombuffer(out, np.float32).flatten()
