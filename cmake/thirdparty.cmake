include(FetchContent)

# find_package(Catch2 3 QUIET)
# if (NOT Catch2_FOUND)
#     message(WARNING "Catch2 for version 3.x not found, will download it.")
#     FetchContent_Declare(
#         Catch2
#         GIT_REPOSITORY https://github.com/catchorg/Catch2.git
#         GIT_TAG        v3.7.1
#     )
#     set(BUILD_TESTING OFF CACHE BOOL "Do not build Catch2's tests")
#     set(CATCH_INSTALL_DOCS OFF CACHE BOOL "Do not install Catch2's documentation")
#     set(CATCH_INSTALL_EXTRAS OFF CACHE BOOL "Do not install Catch2's extras folder")
#     set(CATCH_DEVELOPMENT_BUILD OFF CACHE BOOL "Do not configure Catch2 for development")
#     FetchContent_MakeAvailable(Catch2)
# endif ()
#
# find_package(spdlog CONFIG QUIET)
# if (NOT spdlog_FOUND)
#     message(WARNING "spdlog not found, will download it.")
#     FetchContent_Declare(
#         spdlog
#         GIT_REPOSITORY  https://github.com/gabime/spdlog.git
#         GIT_TAG         v1.15.0
#     )
#     set(SPDLOG_BUILD_SHARED ON CACHE BOOL "" FORCE)
#     FetchContent_MakeAvailable(spdlog)
# endif ()
