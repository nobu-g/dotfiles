# In .zshrc
# export PYTHONSTARTUP="$HOME/.config/.pythonrc.py"

import sys
import os
import re
import json
from pathlib import Path
from typing import *
from collections import defaultdict

try:
    from pyknp import *
except ImportError:
    print("pyknp not available")

print('Imported sys, os, re, json, pathlib.Path, collections.defaultdict, and all modules of typing.')
