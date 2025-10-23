# Common compiler warnings for a C++ project.
# This script is designed to be included from the main CMakeLists.txt file.
#
# Usage:
#   include(cmake/compiler_warning.cmake)
#   set_project_warnings(my_project_name)

function(set_project_warnings project_name)

    option(${project_name}_WARNINGS_AS_ERRORS
        "Treat compiler warnings as errors" OFF)

    if(CMAKE_CXX_COMPILER_ID MATCHES ".*Clang|GNU")
        # Common flags for Clang and GCC
        set(PROJECT_WARNINGS
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

        if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
            # GCC specific warnings
            list(APPEND PROJECT_WARNINGS
                -Wmisleading-indentation
                -Wduplicated-cond
                -Wduplicated-branches
                -Wlogical-op
                -Wuseless-cast
            )
        endif()

        if(${project_name}_WARNINGS_AS_ERRORS)
            list(APPEND PROJECT_WARNINGS -Werror)
        endif()

    elseif(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
        # MSVC specific warnings
        set(PROJECT_WARNINGS
            /W4
            /permissive-
            /w14242 # 'identifier': conversion from 'type1' to 'type1', possible loss of data
            /w14254 # 'operator': conversion from 'type1:field_bits' to 'type2:field_bits', possible loss of data
            /w14263 # 'function': member function does not override any base class virtual member function
            /w14265 # 'classname': class has virtual functions, but destructor is not virtual
            /w14287 # 'operator': unsigned/negative constant mismatch
            /we4289 # nonstandard extension used: 'variable': loop control variable declared in the for-loop is used outside the for-loop scope
            /w14296 # 'operator': expression is always 'boolean_value'
            /w14311 # 'variable': pointer truncation from 'type1' to 'type2'
            /w14545 # expression before comma evaluates to a function which is missing an argument list
            /w14546 # function call before comma missing argument list
            /w14547 # 'operator': operator before comma has no effect; expected operator with side-effect
            /w14549 # 'operator': operator before comma has no effect; did you intend 'operator'?
            /w14555 # expression has no effect; expected expression with side- effect
            /w14619 # pragma warning: there is no warning number 'number'
            /w14640 # Enable warning on thread un-safe static member initialization
            /w14826 # Conversion from 'type1' to 'type_2' is sign-extended. This may cause unexpected runtime behavior.
            /w14905 # wide string literal cast to 'LPSTR'
            /w14906 # string literal cast to 'LPWSTR'
            /w14928 # illegal copy-initialization; more than one user-defined conversion has been implicitly applied
        )

        if(${project_name}_WARNINGS_AS_ERRORS)
            list(APPEND PROJECT_WARNINGS /WX)
        endif()

    else()
        message(AUTHOR_WARNING
            "No compiler warnings set for '${CMAKE_CXX_COMPILER_ID}' compiler.")
    endif()

    if(TARGET ${project_name})
        # Interface libraries don't have sources, so we use INTERFACE
        # Other libraries and executables have sources, so we use PUBLIC
        get_target_property(target_type ${project_name} TYPE)
        if(target_type STREQUAL "INTERFACE_LIBRARY")
            target_compile_options(${project_name} INTERFACE ${PROJECT_WARNINGS})
        else()
            target_compile_options(${project_name} PUBLIC ${PROJECT_WARNINGS})
        endif()
    else()
        message(AUTHOR_WARNING
            "${project_name} is not a target, \
            thus no compiler warnings were added.")
    endif()

endfunction()

