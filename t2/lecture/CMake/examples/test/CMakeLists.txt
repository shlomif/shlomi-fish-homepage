cmake_minimum_required(VERSION 2.6)

#message(VARIABLES())
include(FindZLIB)

message(ZLIB_FOUND "=" ${ZLIB_FOUND})
message(ZLIB_INCLUDE_DIR "=" ${ZLIB_INCLUDE_DIR})
message(ZLIB_LIBRARIES "=" ${ZLIB_LIBRARIES})

set(L 1;2;3)
list(APPEND L a b c )
message("\${L}=" ${L})
message("\"\${L}\"=" "${L}")

macro(macro1 arg1 arg2)
	message("macro1 ${ARGV}")
endmacro(macro1)
macro1(1 2)

#message(SEND_ERROR SEND_ERROR)
message(STATUS STATUS)
#message(FATAL_ERROR FATAL_ERROR)

option(opt "help string describing option" 0)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g")
# unset(CMAKE_C_FLAGS) # doesn't work
