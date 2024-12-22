#!/bin/bash

if [ $# -eq 0 ]; then
    # No arguments, open welcome screen
    hx ~/.config/helix/runtime/welcome.txt
else
    # Arguments provided, open them
    hx "$@"
fi
