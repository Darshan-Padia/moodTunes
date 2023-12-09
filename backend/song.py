from pytube import YouTube
import os
yt = YouTube(str(input("Enter the URL of the video you want to download: \n")))

audio = yt.streams.filter(only_audio = True).first()

# print("Enter the destination (leave blank for current directory)")

# now saving the mp3 file locally
out_file = audio.download(output_path = '/home/darshan/Downloads/mood_tunes/backend')
base, ext = os.path.splitext(out_file)
new_file = base + '.mp3'
os.rename(out_file, new_file)
print(yt.title + " has been successfully downloaded.")

