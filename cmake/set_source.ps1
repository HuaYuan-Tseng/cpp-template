#!/usr/bin/env pwsh

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ROOT_DIR = Get-Location
$OUTPUT_FILE = Join-Path -Path (Join-Path -Path $ROOT_DIR -ChildPath "cmake") -ChildPath "source.cmake"

if (Test-Path $OUTPUT_FILE) {
    Remove-Item $OUTPUT_FILE
}

Write-Host "-- Generating $OUTPUT_FILE ..."

# --- src/app/ ---

$APP_DIR = Join-Path -Path (Join-Path -Path $ROOT_DIR -ChildPath "src") -ChildPath "app"
Add-Content -Path $OUTPUT_FILE -Value "set(APP_SOURCE"

Get-ChildItem -Path $APP_DIR -Recurse -File -Include "*.h", "*.hxx", "*.cpp", "*.cxx" | ForEach-Object {
    $RELATIVE_PATH = $_.FullName.Substring($ROOT_DIR.Path.Length + 1)
    $RELATIVE_PATH = $RELATIVE_PATH -replace '\\', '/'
    Add-Content -Path $OUTPUT_FILE -Value "  `${CMAKE_SOURCE_DIR}/$RELATIVE_PATH"
}

Add-Content -Path $OUTPUT_FILE -Value ")"

# --- test/ ---

$TEST_DIR = Join-Path -Path $ROOT_DIR -ChildPath "test"
Add-Content -Path $OUTPUT_FILE -Value "set(TEST_SOURCE"

Get-ChildItem -Path $TEST_DIR -Recurse -File -Include "*.h", "*.hxx", "*.cpp", "*.cxx" | ForEach-Object {
    $RELATIVE_PATH = $_.FullName.Substring($ROOT_DIR.Path.Length + 1)
    $RELATIVE_PATH = $RELATIVE_PATH -replace '\\', '/'
    Add-Content -Path $OUTPUT_FILE -Value "  `${CMAKE_SOURCE_DIR}/$RELATIVE_PATH"
}

Add-Content -Path $OUTPUT_FILE -Value ")"

Write-Host "-- Finished generating $OUTPUT_FILE."
