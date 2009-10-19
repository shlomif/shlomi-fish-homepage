
# application using libraries

cmake_minimum_required(VERSION 2.6)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -pg")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g")

include_directories (../lib)
link_directories(../lib)
add_executable(app app.c)

target_link_libraries(app common pthread)

message(CMAKE_C_FLAGS:)
message(${CMAKE_C_FLAGS})
