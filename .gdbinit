#source ~echen/.gdbinit.dholm
#source ~/.gdb/stl.gdb

#set max-value-size unlimited
set history save on
#set history size -1
set host-charset UTF-8

#allow printing of long char array values
set print elements 64
set print array-indexes on
set print static off
set python print-stack full

#set style enabled off
catch throw
#catch signal all
#set directories /lhome/HO-2331/ext/monorepo
#break __sanitizer::Die
#break __asan::ReportGenericError
#directory /lhome/snap/ext/monorepo
#directory /home/edwin.chen/snap/ext/monorepo
#directory /home/edwin.chen/RX-9027

python

import ast
import io
import itertools
import math
import os
import re
import struct
import sys
import traceback
sys.path.insert(0, '/home/edwin.chen/.gdb/printers/python')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end

skip -rfu ^std::
skip -rfu ^assemblies::AssemblyBase
