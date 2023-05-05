#!/usr/bin/env bash

set -euxo pipefail

# MODEL could be set to any of "tiny.en" "tiny" "base.en" "base" "small.en" "small" "medium.en" "medium" "large-v1" "large"
# Details at https://github.com/ggerganov/whisper.cpp/tree/master/models
MODEL="base"
LANG="${2:-auto}"


audio_file="${1}"
file_name="$(basename "${audio_file}")"
wav_file="${audio_file%.*}.wav"

media_dir="$(realpath "$(dirname "${audio_file}")")"
script_dir="$(realpath "$(dirname "${0}")")"

docker build -t whisper-${MODEL} --build-arg model=${MODEL} "${script_dir}"

# if the wav_file does not exist, create it
if [ ! -f "${wav_file}" ]; then
    echo "Converting ${audio_file} to ${wav_file}"
    ffmpeg -i "${audio_file}" -ar 16000 "${wav_file}"
# else tell us that it already exists
else
    echo "${wav_file} already exists"
fi

# Get the filename of the wav_file, without the extension
basename=$(basename "${wav_file%.*}")

echo "Running whisper..."
docker run --rm -it \
    -v "${media_dir}":/media \
    whisper-${MODEL} \
    whisper \
        --model /root/models/ggml-${MODEL}.bin \
        --language ${LANG} \
        -t 4 \
        --translate \
        --output-txt --output-vtt --output-srt -nt \
        --print-colors \
        -f "/media/$(basename "${wav_file}")" \
        -of "/media/${basename}"