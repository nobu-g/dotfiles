# In .zshrc
# export PYTHONSTARTUP="$HOME/.config/.pythonrc.py"

import sys
import os
import re
import json
from pathlib import Path
from typing import *
from collections import defaultdict

msg = 'Imported sys, os, re, json, Path, defaultdict, and all modules of typing'

try:
    from pyknp import *
    msg += ' and pyknp.'
except ImportError:
    print("pyknp not available")
    msg += '.'

print(msg)
