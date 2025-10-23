set(${PROJECT_NAME_UPPER}_CLANG_FORMAT_ENABLED OFF)
if(${PROJECT_NAME_UPPER}_ENABLE_CLANG_FORMAT)
    find_program(CLANG_FORMAT_EXECUTABLE clang-format)
    if(NOT CLANG_FORMAT_EXECUTABLE)
        message(
            WARNING
            "clang-format not found. \
            The 'format' target will not be available.")
    else()
        add_custom_target(format
            COMMAND ${CLANG_FORMAT_EXECUTABLE}
                -i
                --style=file
                ${APP_SOURCE}
                ${TEST_SOURCE}
            WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
            COMMENT "Formatting source code with clang-format"
        )
        set(${PROJECT_NAME_UPPER}_CLANG_FORMAT_ENABLED ON)
        message(STATUS "Added 'format' target to run clang-format.")
    endif()
endif()
