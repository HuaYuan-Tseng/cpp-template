# Common compiler warnings for a C++ project.
# This script is designed to be included from the main CMakeLists.txt file.
#
# Usage:
#   include(cmake/compiler_warning.cmake)
#   set_project_warnings(my_project_name)

function(set_project_warnings project_name)
    option(${project_name}_WARNINGS_AS_ERRORS
        "Treat compiler warnings as errors" OFF)

    set(CLANG_GCC_WARNINGS
        -Wall
        -Wextra
        -Wpedantic
        -Wconversion
        -Wsign-conversion
        -Wshadow
        -Wnon-virtual-dtor
        -Wold-style-cast
        -Wcast-align
        -Wunused
        -Woverloaded-virtual
        -Wnull-dereference
        -Wdouble-promotion
        -Wformat=2
    )

    set(GCC_SPECIFIC_WARNINGS
        -Wmisleading-indentation
        -Wduplicated-cond
        -Wduplicated-branches
        -Wlogical-op
        -Wuseless-cast
    )

    set(MSVC_WARNINGS
        /W4
        /permissive-
    )

    target_compile_options(${project_name}
        PRIVATE
        $<$<CXX_COMPILER_ID:GNU>:${CLANG_GCC_WARNINGS} ${GCC_SPECIFIC_WARNINGS}>
        $<$<CXX_COMPILER_ID:Clang>:${CLANG_GCC_WARNINGS}>
        $<$<CXX_COMPILER_ID:MSVC>:${MSVC_WARNINGS}>
    )

    if(${project_name}_WARNINGS_AS_ERRORS)
        target_compile_options(${project_name}
            PRIVATE
            $<$<CXX_COMPILER_ID:GNU,Clang>:-Werror>
            $<$<CXX_COMPILER_ID:MSVC>:/WX>
        )
    endif()

endfunction()

