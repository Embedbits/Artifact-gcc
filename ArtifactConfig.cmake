#Set GCC path
if(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows")

    set(ENV{PATH} "$ENV{PATH};${CMAKE_CURRENT_LIST_DIR}/mingw64/bin/")
    
else()
    
    set(ENV{PATH} "$ENV{PATH}:${CMAKE_CURRENT_LIST_DIR}/gcc/bin/")
    
endif()

execute_process(
    COMMAND gcc --version
    OUTPUT_VARIABLE ARTIFACT_VERSION
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

message(STATUS "Mingw version found: ${ARTIFACT_VERSION}")