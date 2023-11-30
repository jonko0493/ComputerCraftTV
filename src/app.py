from flask import Flask, send_file
from apscheduler.schedulers.background import BackgroundScheduler
import os

app = Flask(__name__)

channels = {}
dirs = [d for d in os.listdir("channels") if not os.path.isfile(os.path.join("channels", d))]
for dir in dirs:
    nfo = open(os.path.join("channels", dir, "channel.nfo"))
    channel = {}
    channel['title'] = nfo.readline()
    channel['episode'] = nfo.readline()
    channel['timer'] = 1
    channel['max_ticks'] = int(os.path.splitext(os.listdir(os.path.join("channels", dir, "img256"))[-1])[0])
    channels[dir] = channel

def channel_tick():
    for channel in channels:
        channels[channel]['timer'] += 1
        if channels[channel]['timer'] > channels[channel]['max_ticks']:
            channels[channel]['timer'] = 1

sched = BackgroundScheduler(daemon=True)
sched.add_job(channel_tick,'interval',seconds=0.2)
sched.start()

@app.route("/")
def tv_guide():
    page = ""
    for channel in channels:
        page += f"{channel}: {channels[channel]['title']} - {channels[channel]['episode']}\n"
    return page

@app.route("/channel/<channel>/256")
def channel_img_256(channel):
    image = os.path.join("channels", channel, "img256", f"{channels[channel]['timer']:05d}.png")
    return send_file(image, mimetype='image/png')

@app.route("/channel/<channel>/512")
def channel_img_512(channel):
    image = os.path.join("channels", channel, "img512", f"{channels[channel]['timer']:05d}.png")
    return send_file(image, mimetype='image/png')

@app.route("/channel/<channel>/audio")
def channel_audio(channel):
    audio = os.path.join("channels", channel, "audio", f"{channels[channel]['timer'] - 1:05d}.wav.dfpwm")
    return send_file(audio, mimetype='binary')

if __name__ == "__main__":
    app.run()