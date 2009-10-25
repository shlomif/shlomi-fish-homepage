
# application using libraries

project(appxxx C)

cmake_minimum_required(VERSION 2.6)

add_definitions(-g)

include_directories (../lib)
link_directories(../lib)
add_executable(app app.c)

target_link_libraries(app common pthread)

message(CMAKE_C_FLAGS: ${CMAKE_C_FLAGS})
