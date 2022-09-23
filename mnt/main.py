import glob
import pydub
from yt_dlp import YoutubeDL
import sys


def url_to_mp3():
    # dl_setting
    ydl = YoutubeDL({'outtmpl': '%(title)s%(ext)s.mp3',
                     'postprocessors': [{
                         'key': 'FFmpegExtractAudio',
                         'preferredcodec': 'mp3',
                         'preferredquality': '192',
                     }]
                     })
    args = sys.argv
    MOVIE_URL = args[1]
    try:
        # 動画情報をダウンロードする
        with ydl:
            result = ydl.extract_info(
                MOVIE_URL,
                download=True
            )
        print("[INFO] ::: we can get mp3 !!")
    except:
        print("ERROR:: " + MOVIE_URL)
    return


def mp3_to_wav():
    # -*- coding: utf-8 -*-
    files = glob.glob("./*.mp3")
    for file in files:
        print(file)
        sound = pydub.AudioSegment.from_mp3(file)
        sound.export("./" + file + ".wav", format="wav")

    print("[INFO] ::: converted to wav !!")


if __name__ == "__main__":
    url_to_mp3()
    mp3_to_wav()
