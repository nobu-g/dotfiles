# Make sure the following line exists in your `.zshrc`
# export PYTHONSTARTUP="$HOME/.config/.pythonrc.py"

import sys
import os
import re
import json
from pathlib import Path
from typing import *
from collections import defaultdict

__msg = 'Imported sys, os, re, json, Path, defaultdict, and all modules of typing'

try:
    from rhoknp import *
    __msg += ' and rhoknp.'
except ImportError:
    print("rhoknp not available")
    __msg += '.'

print(__msg)

# https://unix.stackexchange.com/questions/630642/change-location-of-python-history
import readline
import atexit

# If no history was loaded, default to .python_history.
# The guard is necessary to avoid doubling history size at
# each interpreter exit when readline was already configured
# through a PYTHONSTARTUP hook, see:
# http://bugs.python.org/issue5845#msg198636
__hist = Path(os.environ.get('XDG_DATA_HOME') or Path.home().joinpath('.local/share')) / 'python' / 'python_history'
try:
    readline.read_history_file(__hist)
except OSError:
    pass

def write_history():
    try:
        readline.write_history_file(__hist)
    except OSError:
        # bpo-19891, bpo-41193: Home directory does not exist
        # or is not writable, or the filesystem is read-only.
        pass

atexit.register(write_history)
