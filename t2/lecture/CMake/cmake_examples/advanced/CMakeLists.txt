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
endmacro()
macro1(1 2)

function(func1 arg1 arg2)
	message("func1 ${ARGV}")
endfunction()
func1(1 2)

#message(SEND_ERROR SEND_ERROR)
message(STATUS STATUS)
#message(FATAL_ERROR FATAL_ERROR)

option(opt "help string describing option" 0)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g")
# unset(CMAKE_C_FLAGS) # doesn't work

set(abc a b c)
message("abc="${abc})
message("abc=" "${abc}")

set(string "abc")
string(REGEX REPLACE "b.*" "BC" string ${string})
message( - ${string} -)

set(VERSION 1.2)
string(REGEX MATCHALL "([0-9]+)" VERSION_DIGITS "${VERSION}")

list(GET VERSION_DIGITS 0 MAJOR)
list(GET VERSION_DIGITS 1 MINOR)
message(${MAJOR} " " ${MINOR})


if(1)
message(1)	
elseif(2)
message(2)	
else()
endif()

add_executable(hello2 hello.c)
install(TARGETS hello2 DESTINATION /tmp)


# file
# option
message("CMAKE_MODULE_PATH=" ${CMAKE_MODULE_PATH})
message("CMAKE_BUILD_TYPE=" ${CMAKE_BUILD_TYPE})
message("CMAKE_INSTALL_PREFIX=" ${CMAKE_INSTALL_PREFIX})

