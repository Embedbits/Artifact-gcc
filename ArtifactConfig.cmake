set(GCC_CURRENT_LIST_DIR ${CMAKE_CURRENT_LIST_DIR})
#------------------------------------------------------------------------------#
# Returns artifact version.
#
# The name of function must consist of folder name (gcc) and postfix 
# (_GetArtifactVersion). Otherwise the buildprocess will fail.  
#
# ARTIFACT_VERSION [out]: Version of artifact in format X.Y.Z
#------------------------------------------------------------------------------#
function(gcc_GetArtifactVersion RET_VERSION)

    # Execute the gcc command to get its version
    execute_process(
        COMMAND gcc --version
        OUTPUT_VARIABLE ARTIFACT_VERSION
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    string(REGEX MATCH "[0-9]+\\.[0-9]+\\.[0-9]+" VERSION "${ARTIFACT_VERSION}")
                    
    set(${RET_VERSION} "${VERSION}" PARENT_SCOPE)

endfunction()


#------------------------------------------------------------------------------#
# Initialize artifact for build.
#
# The name of function must consist of folder name (gcc) and postfix 
# (_ArtifactInstall). Otherwise the buildprocess will fail.  
#
# The artifact gcc / g++ are also set as C / C++ compiler of the project
# (CMAKE_C_COMPILER / CMAKE_CXX_COMPILER) - PATH alone is not enough, CMake
# searches the C compiler as "cc" first and the Linux build has no "cc", so
# the system compiler would be used. Compiler chosen by user (cache variable,
# CC / CXX environment variable) or by toolchain file is kept.
#
# ARTIFACT_BIN_PATH_ARG [in]: Path to the binary part of artifact
#------------------------------------------------------------------------------#
function(gcc_ArtifactInit ARTIFACT_BIN_PATH_ARG)

    if(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows")

        set(GCC_BIN_DIR "${ARTIFACT_BIN_PATH_ARG}/mingw64/bin")
        set(EXECUTABLE_SUFFIX ".exe")

        set(ENV{PATH} "${GCC_BIN_DIR}/;$ENV{PATH}")

    else()

        set(GCC_BIN_DIR "${ARTIFACT_BIN_PATH_ARG}/gcc/bin")
        set(EXECUTABLE_SUFFIX "")

        set(ENV{PATH} "${GCC_BIN_DIR}/:$ENV{PATH}")

    endif()

    if(NOT CMAKE_SCRIPT_MODE_FILE AND NOT CMAKE_TOOLCHAIN_FILE)

        if(NOT CMAKE_C_COMPILER AND NOT DEFINED ENV{CC} AND EXISTS "${GCC_BIN_DIR}/gcc${EXECUTABLE_SUFFIX}")
            set(CMAKE_C_COMPILER "${GCC_BIN_DIR}/gcc${EXECUTABLE_SUFFIX}" CACHE FILEPATH "C compiler (gcc artifact)")
            message(STATUS "C compiler set to gcc artifact: ${CMAKE_C_COMPILER}")
        endif()

        if(NOT CMAKE_CXX_COMPILER AND NOT DEFINED ENV{CXX} AND EXISTS "${GCC_BIN_DIR}/g++${EXECUTABLE_SUFFIX}")
            set(CMAKE_CXX_COMPILER "${GCC_BIN_DIR}/g++${EXECUTABLE_SUFFIX}" CACHE FILEPATH "C++ compiler (gcc artifact)")
            message(STATUS "C++ compiler set to gcc artifact: ${CMAKE_CXX_COMPILER}")
        endif()

    endif()

endfunction()