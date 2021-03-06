# The name of our project is "CHomP". CMakeLists files in this project can 
# refer to the root source directory of the project as ${CHomP_SOURCE_DIR} and 
# to the root binary directory of the project as ${CHomP_BINARY_DIR}. 
cmake_minimum_required (VERSION 2.6) 
project (CHomP) 

# C++11 Support
if( CMAKE_COMPILER_IS_GNUCXX )
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -O3 -DNDEBUG")
else()
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -stdlib=libc++ -O3 -DNDEBUG")
endif()

# Append directories in case people use MacPorts
list(APPEND CMAKE_LIBRARY_PATH /opt/local/lib)
list(APPEND CMAKE_INCLUDE_PATH /opt/local/include)
find_package(Threads)
find_package(X11)
if(NOT X11_FOUND)
    message(FATAL_ERROR "Failed to find X11 which is required to build CHomP")
endif(NOT X11_FOUND)

file(GLOB HEADERS ./include/chomp/*.h)

include_directories( ./include 
                     /usr/local/include
		     ${USER_INCLUDE_PATH}
                      ${X11_X11_INCLUDE_PATH} )

link_directories( ${USER_LIBRARY_PATH} /usr/local/lib )

set(LIBS ${LIBS} ${X11_LIBRARIES} ${CMAKE_THREAD_LIBS_INIT})

# Tell it where to put the products
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# Recurse into the "source" subdirectory.
add_subdirectory (source)

# Install Project
install(DIRECTORY include/ DESTINATION include/ )

# Tests
enable_testing()
set(bin ${CMAKE_BINARY_DIR}/bin )
set(examples "../examples")
add_test( circle ../tests/circle.test ${bin} ${examples})
add_test( rubik ../tests/segment.test ${bin} ${examples})
add_test( simplex ../tests/simplex.test ${bin} ${examples})
add_test( square ../tests/square.test ${bin} ${examples})
add_test( square_relative ../tests/square_relative.test ${bin} ${examples})
add_test( square_withhole ../tests/square_withhole.test ${bin} ${examples})

