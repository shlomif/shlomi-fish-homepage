
# project with some features

project(all_in_one C)

cmake_minimum_required(VERSION 2.6)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g")

add_definitions(-DDEFINE=123) # like set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DDEFINE=123")

add_subdirectory(sub)

add_library(common SHARED common.c)

# unset(CMAKE_C_FLAGS) # doesn't work

include_directories(.)
link_directories(.) # just for sample

add_executable(app app.c)

link_libraries(pthread)
target_link_libraries(app common pthread)

message(CMAKE_C_FLAGS:)
message(${CMAKE_C_FLAGS})

