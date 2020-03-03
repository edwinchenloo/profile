#source ~echen/.gdbinit.dholm
#source ~/.gdb/stl.gdb

#set max-value-size unlimited
set history save on
set history size -1

python
import sys
sys.path.insert(0, '/home/edwin.chen/.gdb/printers/python')
from libstdcxx.v6.printers import register_libstdcxx_printers
end
