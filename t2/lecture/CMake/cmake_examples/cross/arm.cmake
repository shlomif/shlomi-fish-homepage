# the name of the target operating system
set(CMAKE_SYSTEM_NAME Linux)

# which C and C++ compiler to use
set(CMAKE_C_COMPILER   /opt/arm-2009q1/bin/arm-none-linux-gnueabi-gcc)
set(CMAKE_CXX_COMPILER /opt/arm-2009q1/bin/arm-none-linux-gnueabi-gcc)

# here is the target environment located
set(CMAKE_FIND_ROOT_PATH /opt/arm-2009q1/arm-none-linux-gnueabi/)

# adjust the default behaviour of the FIND_XXX() commands:
# search headers and libraries in the target environment, search 
# programs in the host environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
