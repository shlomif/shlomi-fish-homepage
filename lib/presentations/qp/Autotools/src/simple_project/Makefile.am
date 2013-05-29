# Define sub-directories of the project
SUBDIRS = man

# noinst_PROGRAMS are programs that should be compiled but not installed
noinst_PROGRAMS = test_rwlock
# Source files for test_rwlock
test_rwlock_SOURCES = test_rwlock.c
# Libraries to link against
test_rwlock_LDADD = libpthread_rwlock_fcfs.la

# Libraries that are built using libtool
lib_LTLIBRARIES = libpthread_rwlock_fcfs.la
# Where to install the headers
libpthread_rwlock_fcfsincludedir=$(includedir)/pthread
# The source files of the library
libpthread_rwlock_fcfs_la_SOURCES = rwlock.c queue.c
# A libtool library version numbers
libpthread_rwlock_fcfs_la_LDFLAGS = -version-info 0:0:0
# The headers of the library
libpthread_rwlock_fcfsinclude_HEADERS = rwlock_fcfs.h rwlock_fcfs_queue.h

# Extra files in the distribution
EXTRA_DIST += Docs/FCFS_RWLock_Scheme.txt Docs/FCFS_RWLock_Scheme_RLE.txt
EXTRA_DIST += test_rwlock.c 
EXTRA_DIST += test_queue.cpp

EXTRA_DIST += pthread/rwlock_fcfs.h pthread/rwlock_fcfs_queue.h

EXTRA_DIST += TODO


