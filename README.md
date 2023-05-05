Transcribe video and audio files on your local machine!
This lets you use [whisper.cpp](https://github.com/ggerganov/whisper.cpp) without having to install or build a line of code.

# Requirements
You need Docker pre-installed on your machine with Docker Hub running, with you logged into a Docker account (free accounts are fine).

You do _not_ need to know how to use Docker

# Instructions
To transcribe a video:
1. Clone this repository locally
2. Create a `media` folder in this repository.
3. Store the video/audio file you want transcribed in the media folder.
4. Run `transcribe.sh path/to/your/media.mp4` (any audio/video file will work)
5. Your output transcript files will be stored next to the input file, in txt, vtt, and srv formats.

# Acknowledgements
[Whisper.cpp](https://github.com/ggerganov/whisper.cpp) created by @ggerganov. 

Dockerfile and transcibe files in this repo are based on [this gist](https://gist.github.com/reitzig/6582edd485a5d0a8b68600dab3b0861b) made by @reitzig

# Interesting potential follow ups
[Get multi-lingual transcription](https://huggingface.co/spaces/openai/whisper/discussions/81)