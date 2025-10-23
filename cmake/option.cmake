# --------------- Package Managers ---------------

option(${PROJECT_NAME_UPPER}_ENABLE_CONAN
    "Enable the Conan package manager for this project." OFF
)

option(${PROJECT_NAME_UPPER}_ENABLE_VCPKG
    "Enable the Vcpkg package manager for this project." OFF
)

# --------------- Static Analyzers ---------------

option(${PROJECT_NAME_UPPER}_ENABLE_CLANG_TIDY
    "Enable static analysis with Clang-Tidy." ON
)

option(${PROJECT_NAME_UPPER}_ENABLE_CPPCHECK
    "Enable static analysis with Cppcheck." OFF
)

# --------------- CCache ---------------

option(${PROJECT_NAME_UPPER}_ENABLE_CCACHE
    "Enable the usage of Ccache, in order to speed up rebuild times." ON
)

set(${PROJECT_NAME_UPPER}_CCACHE_ENABLED OFF)
find_program(CCACHE_FOUND ccache)
if(${PROJECT_NAME_UPPER}_ENABLE_CCACHE AND CCACHE_FOUND)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_COMPILE ccache)
    set_property(GLOBAL PROPERTY RULE_LAUNCH_LINK ccache)
    set(${PROJECT_NAME_UPPER}_CCACHE_ENABLED ON)
    message(STATUS "Ccache enabled.")
endif()

# --------------- Formatter ---------------

option(${PROJECT_NAME_UPPER}_ENABLE_CLANG_FORMAT
    "Enable code formatting with Clang-Format." ON
)

# --------------- Testing ---------------

option(${PROJECT_NAME_UPPER}_ENABLE_TESTING
    "Enable tests for the projects (from the `test` subfolder)." ON
)

# --------------- Code Coverage ---------------

option(${PROJECT_NAME_UPPER}_ENABLE_CODE_COVERAGE
    "Enable code coverage." ON
)

# --------------- Symbol Visibility ---------------

# Configure symbol visibility for shared libraries.
if(BUILD_SHARED_LIBS)
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS OFF)
    set(CMAKE_C_VISIBILITY_PRESET hidden)
    set(CMAKE_CXX_VISIBILITY_PRESET hidden)
    set(CMAKE_VISIBILITY_INLINES_HIDDEN 1)
endif()

# --------------- Link Time Optimization (LTO) ---------------

option(${PROJECT_NAME_UPPER}_ENABLE_LTO
    "Enable Inter-procedural Optimization." OFF
)

if(${PROJECT_NAME_UPPER}_ENABLE_LTO)
    include(CheckIPOSupported)
    check_ipo_supported(RESULT result OUTPUT output)
    if(result)
        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
    else()
        message(SEND_ERROR "IPO is not supported: ${output}.")
    endif()
endif()

# --------------- Sanitizer Options ---------------

option(${PROJECT_NAME_UPPER}_ENABLE_ASAN
    "Enable Address Sanitizer to detect memory error." OFF
)

if(${PROJECT_NAME_UPPER}_ENABLE_ASAN)
    add_compile_options(-fsanitize=address)
    add_link_options(-fsanitize=address)
endif()

