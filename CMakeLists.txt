cmake_minimum_required(VERSION 3.19)
project(cpp-template
    VERSION 0.0.1
    LANGUAGES C CXX
)

# Setup alternatives name.
string(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWER)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

# --------------- Build Guards ---------------

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
    message(
        FATAL_ERROR
        "In-source builds not allowed. \
        Please make a new directory (called a build directory) \
        and run cmake from there."
    )
endif()

# --------------- Set CMake Options ---------------

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_DEBUG_POSTFIX "d")
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_INCLUDE_CURRENT_DIR OFF)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE Release)
endif()

# Generate the source.cmake file.
execute_process(
    COMMAND bash ${CMAKE_SOURCE_DIR}/cmake/set_source.sh
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
    RESULT_VARIABLE GEN_SOURCE_RES
    ERROR_VARIABLE GEN_SOURCE_ERR
)

if(NOT GEN_SOURCE_RES EQUAL 0)
    message(FATAL_ERROR "Failed to generate source.cmake: ${GEN_SOURCE_ERR}")
endif()

include(cmake/source.cmake)
include(cmake/option.cmake)
include(cmake/format.cmake)
include(cmake/static_analyzer.cmake)
include(cmake/compiler_warning.cmake)

