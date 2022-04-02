#source ~echen/.gdbinit.dholm
#source ~/.gdb/stl.gdb

#set max-value-size unlimited
set history save on
#set history size -1
set host-charset UTF-8

#allow printing of long char array values
set print elements 4096
set print static off

#set style enabled off
catch throw
#catch signal all
#set directories /lhome/HO-2331/ext/monorepo
#break __sanitizer::Die
#break __asan::ReportGenericError
directory /lhome/snap/ext/monorepo

python
import sys
sys.path.insert(0, '/home/edwin.chen/.gdb/printers/python')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end
