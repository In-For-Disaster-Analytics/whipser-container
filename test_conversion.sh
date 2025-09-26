#!/bin/bash

# Source the audio conversion functions
source ./audio_conversion.sh

# Test function
test_format() {
    local test_file="$1"
    local input_extension=$(file -b --mime-type "$test_file" | cut -d'/' -f2)
    local output_file="output_${input_extension}.wav"

    echo "===================="
    echo "Testing format: $input_extension ($test_file)"
    echo "===================="

    # Create a dummy test file (you can replace with real files)
    touch "$test_file"

    # Test the conversion
    if convert_to_wav "$test_file" "$output_file"; then
        echo "✓ Conversion attempted for $format"
        echo "Return code: $?"
    else
        echo "✗ No conversion needed for $format (using file directly)"
        echo "Return code: $?"
    fi
    rm $output_file
    echo ""
}

echo "Testing all supported audio formats..."
echo ""

# Test all supported formats
test_format tests/data/door.mp3 "wav"
test_format tests/data/door.mp4 "wav"
#test_format tests/data/door.mov "mov"
#test_format tests/data/door.webm "webm"
test_format tests/data/door.flac "wav"
#test_format tests/data/door.x-m4a "m4a"
#test_format tests/data/door.mp4a-latm "m4a"
test_format tests/data/door.ogg "wav"
test_format tests/data/door.wav "wav"
#test_format tests/data/door.unknown "xyz"

echo "===================="
echo "Test complete!"
echo "===================="