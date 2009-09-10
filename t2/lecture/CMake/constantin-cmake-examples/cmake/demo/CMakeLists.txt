
# more complex cmake example

SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g")
SET(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DDEFINE=123")

add_library (func SHARED func.c)

add_executable(demo demo.c)

target_link_libraries (demo func)
target_link_libraries (demo pthread)
