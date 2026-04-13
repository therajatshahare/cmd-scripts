import sys
import lyricsgenius
import subprocess
import os
import re

if len(sys.argv) < 3:
    print("Usage: lyrics.py \"Song Title\" \"flac_file_path\"")
    sys.exit(1)

title = sys.argv[1]
filepath = sys.argv[2]

# Replace with your actual Genius API token
GENIUS_TOKEN = "IUgegJz4rxlrR1a5_WXzW4amw-qR7Qf-a2NvvNbioD7rtiVHCKjXozYQVQPoxSEp"

genius = lyricsgenius.Genius(
    GENIUS_TOKEN,
    skip_non_songs=True,
    excluded_terms=["(Remix)", "(Live)"],
    remove_section_headers=False,
    timeout=15
)

song = genius.search_song(title)
if song is None or not song.lyrics:
    print(f"Lyrics not found for: {title}")
    sys.exit(1)

# Raw lyrics from Genius
lyrics = song.lyrics

# Filter out unwanted lines
filtered_lines = []
exclude_phrases = [
    "Translations", "Contributors", "Lyrics", "Romanization", "Embed",
    "Read More", "Genius", "About", "You might also like"
]

for line in lyrics.splitlines():
    clean_line = line.strip()
    if not clean_line:
        continue
    if any(p.lower() in clean_line.lower() for p in exclude_phrases):
        continue
    filtered_lines.append(clean_line)

# Join and prepare metadata
final_lyrics = "\n".join(filtered_lines).replace('"', "'").replace("\r", "")

# Save lyrics to temporary file (for ffmpeg metadata use)
with open("genius_lyrics.txt", "w", encoding="utf-8") as f:
    f.write(final_lyrics)

# Embed metadata into the audio file
subprocess.run([
    "ffmpeg", "-y",
    "-i", filepath,
    "-i", "genius_lyrics.txt",
    "-map_metadata", "0",
    "-metadata", f"lyrics={final_lyrics}",
    "-c", "copy", "temp.flac"
], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)

# Replace original file with updated one
os.replace("temp.flac", filepath)
os.remove("genius_lyrics.txt")

print(f"Lyrics embedded into {filepath}")
