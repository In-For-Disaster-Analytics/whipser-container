#!/bin/bash
set -xe
export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
# Set up parameters, input and output directories
min_speakers=${1}
output="${_tapisExecSystemOutputDir}/output.json"

# Change to input directory
cd ${_tapisExecSystemInputDir}

# Check if input file exists
if [ ! -f "${_tapisExecSystemInputDir}/source.audio" ]; then
    echo "Error: source.audio file not found"
    exit 1
fi

# Get file extension
file_extension=$(file -b --mime-type "${_tapisExecSystemInputDir}/source.audio" | cut -d'/' -f2)

# If it's an MP3, convert to WAV
if [ "$file_extension" = "mpeg" ]; then
    echo "Converting MP3 to WAV..."
    ffmpeg -i "${_tapisExecSystemInputDir}/source.audio" "${_tapisExecSystemInputDir}/audio.wav"
    input_file="${_tapisExecSystemInputDir}/audio.wav"
else
    # For WAV and OGG, use the file directly
    input_file="${_tapisExecSystemInputDir}/source.audio"
fi

insanely-fast-whisper --file-name "${input_file}" --diarization_model pyannote/speaker-diarization-3.1 --min-speakers "${min_speakers}" --transcript-path "${output}" --hf-token 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 --batch-size 8
