# C++ Template Project

A modern C++ project template using CMake, with support for testing, formatting, and static analysis.

## Features

*   **CMake-based build system:** Uses `CMakeLists.txt` and `CMakePresets.json` for easy configuration and building.
*   **Code Formatting:** Integrated with `.clang-format` to ensure consistent code style.
*   **Static Analysis:** Configured with `.clang-tidy` for static analysis to catch common errors.
*   **Testing Framework:** Ready for tests with a `test/` directory (framework not yet integrated).
*   **Dependency Management:** A `thirdparty/` directory is included for managing external libraries.
*   **Editor Configuration:** `.editorconfig` helps maintain consistent coding styles across different editors and IDEs.

## Prerequisites

*   A C++17 compliant compiler (e.g., Clang, GCC, MSVC)
*   [CMake](https://cmake.org/download/) (version 3.19 or later)

## Getting Started

### Configure and Build

This project uses CMake Presets for a streamlined build process.

1.  **List available presets:**
    ```bash
    cmake --list-presets
    ```

2.  **Configure the project:**
    ```bash
    cmake --preset <preset name>
    ```

3.  **Build the project:**
    ```bash
    cmake --build --preset <preset name>
    ```

    The executable will be located in `bin/<preset name>/`.

### Run the application

```bash
./bin/<preset name>/<application name>
```

## Running Tests

The testing framework is not yet integrated. Once it is, you can run tests using CTest:

```bash
ctest --preset <preset name>
```

## Folder Structure

```
.
├── CMakeLists.txt          # Main CMake build script
├── CMakePresets.json       # CMake presets for configuration
├── README.md               # This file
├── bin/                    # Output directory for binaries
├── build/                  # Build directory for intermediate files
├── cmake/                  # Helper CMake scripts
├── src/                    # Source code
│   └── app/
│       └── main.cpp        # Main application entry point
├── test/                   # Test source code
└── thirdparty/             # Third-party libraries
```

## License

This project is licensed under the MIT License.
