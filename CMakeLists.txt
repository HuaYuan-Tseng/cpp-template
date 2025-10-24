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

# --------------- Set Output Directory ---------------

if(DEFINED PRESET_NAME AND NOT PRESET_NAME STREQUAL "")
    set(OUTPUT_DIR ${PRESET_NAME})
else()
    if(WIN32)
        set(OS "windows")
    elseif(UNIX AND NOT APPLE)
        set(OS "linux")
    elseif(APPLE)
        set(OS "macos")
    else()
        string(TOLOWER ${CMAKE_SYSTEM_NAME} OS)
    endif()

    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang|AppleClang")
        set(COMPILER "clang")
    elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
        set(COMPILER "gcc")
    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        set(COMPILER "msvc")
    else()
        string(TOLOWER ${CMAKE_CXX_COMPILER_ID} COMPILER)
    endif()

    string(TOLOWER ${CMAKE_BUILD_TYPE} BUILD_TYPE_LOWER)
    set(OUTPUT_DIR "${OS}-${COMPILER}-${BUILD_TYPE_LOWER}")
endif()

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin/${OUTPUT_DIR})
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin/${OUTPUT_DIR})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin/${OUTPUT_DIR})
set(CMAKE_COMPILE_PDB_OUTPUT_DIRECTORY ${CMAKE_SOURCE_DIR}/bin/${OUTPUT_DIR})

foreach(OUTPUT_CONFIG ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER ${OUTPUT_CONFIG} OUTPUT_CONFIG_UPPER)
    set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_${OUTPUT_CONFIG_UPPER} ${CMAKE_SOURCE_DIR}/bin/${OUTPUT_DIR})
    set(CMAKE_LIBRARY_OUTPUT_DIRECTORY_${OUTPUT_CONFIG_UPPER} ${CMAKE_SOURCE_DIR}/bin/${OUTPUT_DIR})
    set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${OUTPUT_CONFIG_UPPER} ${CMAKE_SOURCE_DIR}/bin/${OUTPUT_DIR})
    set(CMAKE_COMPILE_PDB_OUTPUT_DIRECTORY_${OUTPUT_CONFIG_UPPER} ${CMAKE_SOURCE_DIR}/bin/${OUTPUT_DIR})
endforeach()

# --------------- Thirdparty ---------------

include(cmake/thirdparty.cmake)

# --------------- Source ---------------

set(PROJECT_TARGETS "")

add_executable(${PROJECT_NAME_LOWER}-app "")
target_sources(${PROJECT_NAME_LOWER}-app
    PRIVATE
    ${APP_SOURCE}
)
target_include_directories(${PROJECT_NAME_LOWER}-app
    PRIVATE
    ${CMAKE_SOURCE_DIR}/src
)
target_link_libraries(${PROJECT_NAME_LOWER}-app
    PRIVATE
)
if(UNIX AND NOT APPLE)
    target_link_libraries(${PROJECT_NAME_LOWER}-app
        PRIVATE
        pthread
    )
endif()

list(APPEND PROJECT_TARGETS ${PROJECT_NAME_LOWER}-app)

# --------------- Testing ---------------

if(${PROJECT_NAME_UPPER}_ENABLE_TESTING)
    enable_testing()

    # add_executable(${PROJECT_NAME_LOWER}-test "")
    # target_sources(${PROJECT_NAME_LOWER}-test
    #     PRIVATE
    #     ${TEST_SOURCE}
    # )
    # target_include_directories(${PROJECT_NAME_LOWER}-test
    #     PRIVATE
    #     ${CMAKE_SOURCE_DIR}/src
    #     ${CMAKE_SOURCE_DIR}/test
    # )
    # target_link_libraries(${PROJECT_NAME_LOWER}-test
    #     PRIVATE
    # )
    # if (UNIX AND NOT APPLE)
    #     target_link_libraries(${PROJECT_NAME_LOWER}-test
    #         PRIVATE
    #         pthread
    #     )
    # endif ()
    #
    # list(APPLE PROJECT_TARGETS ${PROJECT_NAME_UPPER}-test)
endif()

# --------------- Set Building Options ---------------

if(CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang|AppleClang")
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -O0")
        set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -O0")
    elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
        set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -O3")
        set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3")
    endif()
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /Od /Zi")
        set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /Od /Zi")
    elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
        set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /O2")
        set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /O2")
    endif()

    set(CMAKE_EXE_LINKER_FLAGS_DEBUG "/DEBUG /INCREMENTAL:NO /SUBSYSTEM:CONSOLE")
    set(CMAKE_STATC_LINKER_FLAGS_DEBUG "/DEBUG /INCREMENTAL:NO /SUBSYSTEM:CONSOLE")
    set(CMAKE_SHARED_LINKER_FLAGS_DEBUG "/DEBUG /INCREMENTAL:NO /SUBSYSTEM:CONSOLE")
    set(CMAKE_MODULE_LINKER_FLAGS_DEBUG "/DEBUG /INCREMENTAL:NO /SUBSYSTEM:CONSOLE")
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")

    set_target_properties(${PROJECT_NAME_LOWER}-app PROPERTIES WIN32_EXECUTABLE ON)

    # Add Unicode support for Windows
    foreach(TARGET ${PROJECT_TARGETS})
        target_compile_definitions(${TARGET}
            PRIVATE
            UNICODE
            _UNICODE
        )
    endforeach()
endif()

# Add debug macro for Unix
if(UNIX)
    foreach(TARGET ${PROJECT_TARGETS})
        target_compile_definitions(${TARGET}
            PRIVATE
            $<$<CONFIG:DEBUG>:_DEBUG>
        )
    endforeach()
endif()

# Set compiler warnings
foreach(TARGET ${PROJECT_TARGETS})
    set_project_warnings(${TARGET})
endforeach()

# --------------- Results ---------------

message(STATUS "------------------")
message(STATUS "Configure Result: ")
message(STATUS "------------------")
message(STATUS "Project Name: ${PROJECT_NAME}")
message(STATUS "Project Version: ${PROJECT_VERSION}")
message(STATUS "System Name: ${CMAKE_SYSTEM_NAME}")
message(STATUS "System Version: ${CMAKE_SYSTEM_VERSION}")
message(STATUS "System Processor: ${CMAKE_SYSTEM_PROCESSOR}")
message(STATUS "Build Type: ${CMAKE_BUILD_TYPE}")
message(STATUS "C Version: ${CMAKE_C_STANDARD}")
message(STATUS "C++ Version: ${CMAKE_CXX_STANDARD}")
message(STATUS "C Compiler: ${CMAKE_C_COMPILER_ID} ${CMAKE_C_COMPILER_VERSION}")
message(STATUS "C++ Compiler: ${CMAKE_CXX_COMPILER_ID} ${CMAKE_CXX_COMPILER_VERSION}")
message(STATUS "C Flags: ${CMAKE_C_FLAGS}")
message(STATUS "C Debug Flags: ${CMAKE_C_FLAGS_DEBUG}")
message(STATUS "C Release Flags: ${CMAKE_C_FLAGS_RELEASE}")
message(STATUS "C++ Flags: ${CMAKE_CXX_FLAGS}")
message(STATUS "C++ Debug Flags: ${CMAKE_CXX_FLAGS_DEBUG}")
message(STATUS "C++ Release Flags: ${CMAKE_CXX_FLAGS_RELEASE}")
message(STATUS "Linker Flags: ${CMAKE_EXE_LINKER_FLAGS}")
message(STATUS "Export Compile Commands: ${${PROJECT_NAME_UPPER}_EXPORT_COMPILE_COMMANDS}")
message(STATUS "Enable Conan: ${${PROJECT_NAME_UPPER}_ENABLE_CONAN}")
message(STATUS "Enable VCPKG: ${${PROJECT_NAME_UPPER}_ENABLE_VCPKG}")
message(STATUS "Enable Clang-Tidy: ${${PROJECT_NAME_UPPER}_CLANG_TIDY_ENABLED}")
message(STATUS "Enable CppCheck: ${${PROJECT_NAME_UPPER}_CPPCHECK_ENABLED}")
message(STATUS "Enable CCache: ${${PROJECT_NAME_UPPER}_CCACHE_ENABLED}")
message(STATUS "Enable Clang-Format: ${${PROJECT_NAME_UPPER}_ENABLE_CLANG_FORMAT}")
message(STATUS "Enable Testing: ${${PROJECT_NAME_UPPER}_ENABLE_TESTING}")
message(STATUS "Enable Code Coverage: ${${PROJECT_NAME_UPPER}_ENABLE_CODE_COVERAGE}")
message(STATUS "Enable LTO: ${${PROJECT_NAME_UPPER}_ENABLE_LTO}")
message(STATUS "Enable Address Sanitizer: ${${PROJECT_NAME_UPPER}_ENABLE_ASAN}")

