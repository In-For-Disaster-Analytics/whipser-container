#!/bin/bash

# Function to convert audio file to WAV format
convert_to_wav() {
    local source_file="$1"
    local output_file="$2"
    local file_extension=$(file -b --mime-type "$source_file" | cut -d'/' -f2)
    echo $file_extension

    case "$file_extension" in
        "mpeg"|"mp3")
            echo "Converting MP3 to WAV..."
            ffmpeg -i "$source_file" "$output_file"
            return 0
            ;;
        "mp4"|"quicktime")
            echo "Converting MP4/MOV to WAV..."
            ffmpeg -i "$source_file" -vn -acodec pcm_s16le -ar 16000 "$output_file"
            return 0
            ;;
        "webm")
            echo "Converting WebM to WAV..."
            ffmpeg -i "$source_file" -vn -acodec pcm_s16le -ar 16000 "$output_file"
            return 0
            ;;
        "x-flac"|"flac")
            echo "Converting FLAC to WAV..."
            ffmpeg -i "$source_file" "$output_file"
            return 0
            ;;
        "x-m4a"|"mp4a-latm")
            echo "Converting M4A to WAV..."
            ffmpeg -i "$source_file" "$output_file"
            return 0
            ;;
        "ogg")
            echo "Converting OGG to WAV..."
            ffmpeg -i "$source_file" "$output_file"
            return 0
            ;;
        *)
            echo "Using source file directly (format: $file_extension)"
            return 1
            ;;
    esac
}