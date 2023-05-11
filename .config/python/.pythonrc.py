# Make sure the following line exists in your `.zshrc`
# export PYTHONSTARTUP="$HOME/.config/.pythonrc.py"

import sys, os, re, json  # noqa
from pathlib import Path
from collections import defaultdict # noqa
from typing import * # noqa

print('Imported sys, os, re, json, Path, defaultdict, and all types from typing.')

try:
    from rhoknp import * # noqa
    print('Imported all modules etc. from rhoknp.')
except ImportError:
    print("rhoknp not available")

try:
    from transformers import AutoConfig, AutoModel, AutoTokenizer # noqa
    print('Imported AutoConfig, AutoModel, and AutoTokenizer from transformers.')
except ImportError:
    pass

# https://unix.stackexchange.com/questions/630642/change-location-of-python-history
import readline, atexit # noqa

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
    import readline
    try:
        readline.write_history_file(__hist)
    except OSError:
        # bpo-19891, bpo-41193: Home directory does not exist
        # or is not writable, or the filesystem is read-only.
        pass


atexit.register(write_history)
