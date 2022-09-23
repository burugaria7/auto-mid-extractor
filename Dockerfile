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

RUN pip install ffmpeg-python

ENV URL "https://www.youtube.com/watch?v=1Bf-lCXST_M"
WORKDIR /mnt/
CMD python3 /mnt/main.py ${URL}
