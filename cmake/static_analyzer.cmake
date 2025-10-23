# --------------- Clang Tidy ---------------

set(${PROJECT_NAME_UPPER}_CLANG_TIDY_ENABLED OFF)
if(${PROJECT_NAME_UPPER}_ENABLE_CLANG_TIDY)
    find_program(CLANG_TIDY clang-tidy)
    if(CLANG_TIDY)
        set(ALL_SOURCE_FILE ${APP_SOURCE} ${TEST_SOURCE})
        if(ALL_SOURCE_FILE)
            set(${PROJECT_NAME_UPPER}_CLANG_TIDY_ENABLED ON)
            add_custom_target(
                clang-tidy
                COMMAND ${CLANG_TIDY}
                        -p=${CMAKE_BINARY_DIR}
                        ${ALL_SOURCE_FILE}
            )
        endif()
    else()
        message(WARNING "clang-tidy not found.")
    endif()
endif()

# --------------- CppCheck ---------------

set(${PROJECT_NAME_UPPER}_CPPCHECK_ENABLED OFF)
if(${PROJECT_NAME_UPPER}_ENABLE_CPPCHECK)
    find_program(CPPCHECK cppcheck)
    if(CPPCHECK)
        set(${PROJECT_NAME_UPPER}_CPPCHECK_ENABLED ON)
        add_custom_target(
            cppcheck
            COMMAND ${CPPCHECK}
                    --enable=all
                    --project=${CMAKE_BINARY_DIR}/compile_commands.json
        )
    else()
        message(WARNING "cppcheck not found.")
    endif()
endif()
