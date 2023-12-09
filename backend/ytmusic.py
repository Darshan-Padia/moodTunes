from flask import Flask, jsonify
from flask_cors import CORS
from flask import Flask, request, jsonify
from pytube import YouTube
import os
from ytmusicapi import YTMusic

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes
yt = YTMusic('backend/oauth.json')
rs = yt.get_mood_categories()
# listing all the mood categories titles
mood_categories = {
    # title : params
}

for i in rs:
    for j in rs[i]:
        mood_categories[j['title']] = j['params']

# print(mood_categories)
@app.route('/get_music', methods=['POST'])
def get_music():
    data = request.get_json()
    search_term = data['search_term']
    data = yt.search(search_term, filter="songs")
    print(data)
    return jsonify(data)

@app.route('/get_albums', methods=['POST'])
def get_albums():
    data = request.get_json()
    search_term = data['search_term']
    print('search_term')
    print(search_term)
    data = yt.search(search_term, filter="albums")
    print(data)
    return jsonify(data)

# get songs in an album
@app.route('/get_songs_from_album', methods=['POST'])
def get_songs_from_album():
    print('\nget_songs_from_album\n')
    data = request.get_json()
    browse_id = data['browse_id']
    data = yt.get_album(browse_id)
    print(data)
    return jsonify(data)

# YTMusic.get_charts(country: str = 'ZZ')→ Dict
@app.route('/get_charts', methods=['POST'])
def get_charts():
    data = request.get_json()
    country = data['country']
    data = yt.get_charts(country)
    print(data)
    return jsonify(data)

# getting mood categories playlists get_mood_playlists
@app.route('/get_mood_playlists', methods=['POST'])
def get_mood_playlists():
    data = request.get_json()
    mood_category = data['mood_category']
    data = yt.get_mood_playlists(mood_categories[mood_category])
    print(data)
    return jsonify(data)
# YTMusic.get_album_browse_id
@app.route('/get_album_browse_id', methods=['POST'])
def get_album_browse_id():
    data = request.get_json()
    search_term = data['search_term']
    data = yt.get_album_browse_id(search_term)
    print(data)
    return jsonify(data)

# YTMusic.get_playlist(playlistId: str, limit: int = 100, related: bool = False, suggestions_limit: int = 0)→ Dict
@app.route('/get_playlist_items', methods=['POST'])
def get_playlist_items():
    data = request.get_json()
    playlist_id = data['playlist_id']
    data = yt.get_playlist(playlist_id)
    print(data)
    return jsonify(data)

@app.route('/play_song', methods=['POST'])

def play_song():
    data = request.get_json()
    song_id = data['song_id']
    yt = YouTube(video_id=song_id)
    audio = yt.streams.filter(only_audio = True).first()
    out_file = audio.download(output_path = '/home/darshan/Downloads/mood_tunes/backend')
    
    return jsonify('success')

# Add more endpoints as needed

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
