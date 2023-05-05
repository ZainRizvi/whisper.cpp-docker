@echo on
setlocal

rem MODEL could be set to any of "tiny.en" "tiny" "base.en" "base" "small.en" "small" "medium.en" "medium" "large-v1" "large"
rem Details at https://github.com/ggerganov/whisper.cpp/tree/master/models
set MODEL=base

IF "%2"=="" (  
    set LANG=auto
) ELSE (
  set LANG=%2
)

set audio_file=%1
set file_name=%~n1
set wav_file=%~dp1%~n1.wav
set wav_input=%~n1.wav

for %%I in ("%~dp1.") do set "media_dir=%%~fI"
set "script_dir=%~dp0"

rem Get the path of wav_file relative to script_dir

echo "Building docker"

docker build -t whisper-%MODEL% --build-arg model=%MODEL% %script_dir%

if not exist "%wav_file%" (
    echo Converting %audio_file% to %wav_file%
    ffmpeg -i "%audio_file%" -ar 16000 "%wav_file%"
) else (
    echo %wav_file% already exists
)

set "basename=%~n1"

echo "Running whisper..."

echo "Using: whisper --model /root/models/ggml-%MODEL%.bin --language %LANG% -t 2 --output-txt -nt -f '/media/%wav_input%' -of '/media/%basename%'"

docker run --rm -it ^
    -v "%media_dir%":/media ^
    whisper-%MODEL% ^
    whisper ^
        --model /root/models/ggml-%MODEL%.bin ^
        --language %LANG% ^
        -t 4 ^
        --translate ^
        --output-txt  --output-vtt --output-srt -nt ^
        --print-colors ^
        -f "/media/%wav_input%" ^
        -of "/media/%basename%"