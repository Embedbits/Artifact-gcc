set(GCC_CURRENT_LIST_DIR ${CMAKE_CURRENT_LIST_DIR})
#------------------------------------------------------------------------------#
# Returns artifact version.
#
# The name of function must consist of folder name (doxygen) and postfix 
# (_GetArtifactVersion). Otherwise the buildprocess will fail.  
#
# ARTIFACT_VERSION [out]: Version of artifact in format X.Y.Z
#------------------------------------------------------------------------------#
function(doxygen_GetArtifactVersion RET_VERSION)

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
# The name of function must consist of folder name (doxygen) and postfix 
# (_ArtifactInstall). Otherwise the buildprocess will fail.  
#
# ARTIFACT_BIN_PATH_ARG [in]: Path to the binary part of artifact
#------------------------------------------------------------------------------#
function(doxygen_ArtifactInit ARTIFACT_BIN_PATH_ARG)

    if(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows")

        set(ENV{PATH} "${ARTIFACT_BIN_PATH_ARG}/mingw64/bin/;$ENV{PATH}")
        
    else()
        
        set(ENV{PATH} "${ARTIFACT_BIN_PATH_ARG}/gcc/bin/:$ENV{PATH}")
        
    endif()

endfunction()