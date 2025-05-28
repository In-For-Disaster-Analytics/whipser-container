#!/bin/bash
set -xe

export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
cd ${_tapisExecSystemInputDir}
insanely-fast-whisper --file-name ${_tapisExecSystemInputDir}/audio.mp3 --diarization_model pyannote/speaker-diarization-3.1 --min-speakers $min_speakers --transcript-path $output --hf-token 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
