FROM python:3.7-slim-bullseye
LABEL maintainer="Re"
USER root

#
# install packages
#
RUN apt update && apt install -y \
    build-essential \
    libsndfile1 \
    libasound2-dev \
    libjack-dev \
    portaudio19-dev \
    ca-certificates \
    curl \
    unzip \
    git && \
    rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip

# insatll yt-dlp
RUN python3 -m pip install -U yt-dlp
RUN python3 -m pip install -U pydub

RUN curl -LJO http://johnvansickle.com/ffmpeg/releases/ffmpeg-release-arm64-static.tar.xz \
    && tar xvf ffmpeg-release-arm64-static.tar.xz --strip-components 1 \
    && cp ffmpeg /usr/local/bin \
    && cp ffprobe /usr/local/bin

# RUN tar xvf ffmpeg-release-arm64-static.tar.xz
# RUN cp ffmpeg-4.3-arm64-static/ffmpeg /usr/local/bin
# RUN cp ffmpeg-4.3-arm64-static/ffprobe /usr/local/bin

RUN python3 -m pip install -U ffmpeg-python

ENV URL "https://www.youtube.com/watch?v=1Bf-lCXST_M"
WORKDIR /mnt/
# COPY ./mnt/main.py /mnt/
# RUN python3 /mnt/main.py ${URL}

##########################################################################################


# FROM python:3.7-slim-bullseye

# WORKDIR /mnt/

#
# install & setup megenta

RUN python3 -m pip install -U magenta

# RUN git clone https://github.com/tensorflow/magenta.git /opt/magenta && \
#     cd /opt/magenta && \
#     pip install -e .

# RUN if [ -d /opt/magenta ] && [ ! -f /opt/magenta/* ]; then \
#     git clone https://github.com/tensorflow/magenta.git /opt/magenta \
#     pip install -e .

#
# setup magenta.sh
#
RUN echo '#!/usr/bin/env bash' > /magenta.sh && \
    echo 'if [ -d /opt/magenta ] && [ ! -f /opt/magenta/* ]; then' >> /magenta.sh && \
    echo 'git clone https://github.com/tensorflow/magenta.git /opt/magenta' >> /magenta.sh && \
    echo 'fi' >> /magenta.sh && \
    echo 'python3 -m pip install -e /opt/magenta/' >> /magenta.sh && \
    echo 'python3 /mnt/main.py ${URL}' >> /magenta.sh && \
    echo 'cd /opt/magenta' >> /magenta.sh && \
    echo 'python3 magenta/models/onsets_frames_transcription/onsets_frames_transcription_transcribe.py --model_dir="/mnt/maestro_checkpoint/train" /mnt/*.wav' >> /magenta.sh && \
    chmod +x /magenta.sh

# RUN ./magenta.sh /mnt/*wav

# CMD cp /mnt/*mid /test/

ENTRYPOINT [ "/magenta.sh" ]
CMD ["/mnt/*.wav"]