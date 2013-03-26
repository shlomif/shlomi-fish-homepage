# creating library

project(common C)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DDEFINE=123")


add_library(common SHARED common.c)
