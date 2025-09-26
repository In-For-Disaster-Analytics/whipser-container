#!/bin/bash
set -xe
export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
# Set up parameters, input and output directories
min_speakers=${1}
HF_TOKEN=${2}
echo "HF_TOKEN is ${HF_TOKEN}"
output="${_tapisExecSystemOutputDir}/output.json"

# Change to input directory
cd ${_tapisExecSystemInputDir}

# Check if input file exists
if [ ! -f "${_tapisExecSystemInputDir}/source.audio" ]; then
    echo "Error: source.audio file not found"
    exit 1
fi

# Source the audio conversion functions
source "$(dirname "$0")/audio_conversion.sh"

# Convert to WAV if needed
if convert_to_wav "${_tapisExecSystemInputDir}/source.audio" "${_tapisExecSystemInputDir}/audio.wav"; then
    input_file="${_tapisExecSystemInputDir}/audio.wav"
else
    input_file="${_tapisExecSystemInputDir}/source.audio"
fi

insanely-fast-whisper --file-name "${input_file}" --diarization_model pyannote/speaker-diarization-3.1 --min-speakers "${min_speakers}" --transcript-path "${output}" --hf-token "${HF_TOKEN}" --batch-size 8
