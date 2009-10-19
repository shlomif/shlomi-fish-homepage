
# project with some features

project(all_in_one C)

cmake_minimum_required(VERSION 2.6)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DDEFINE=123")
add_subdirectory(sub)

# unset(CMAKE_C_FLAGS) # doesn't work

include_directories(.)
link_directories(.) # just for sample

add_executable(app app.c)

target_link_libraries(app common pthread)

message(CMAKE_C_FLAGS:)
message(${CMAKE_C_FLAGS})

add_library(common SHARED common.c)
