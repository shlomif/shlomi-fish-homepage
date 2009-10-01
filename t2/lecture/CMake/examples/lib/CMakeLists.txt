# creating library

SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DDEFINE=123")


add_library (common SHARED common.c)
