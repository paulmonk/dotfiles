import datetime as dt
import json
import logging
import os
import sys
import time
from decimal import Decimal
from pprint import pprint as pp

# Default all logging to DEBUG
logging.basicConfig(level=logging.DEBUG)

# Allow easy copy paste of JSON
try:
    import __builtin__
except ImportError:
    import builtins as __builtin__

__builtin__.true = True
__builtin__.false = False
__builtin__.null = None
