# Due to the complexity involved, this package doesn't install the Vulkan SDK.
# It instead verifies that Vulkan is installed.
# Other packages can depend on this package to declare a dependency on Vulkan.
include(vcpkg_common_functions)

# Make this a no-op at the moment.
SET(VCPKG_POLICY_EMPTY_PACKAGE enabled)
return()

#>>>>
# I'd like to get this closer to how FindVulkan.cmake works.
# Due to the way this portfile is written, Vulkan detection fails
# when installing the official Ubuntu packages. This probably affects
# other distribution formats as well. The problem is that the Vulkan
# SDK is not necessarily installed under the common root dir.
# We should support that.
# The strategy of FindVulkan.cmake is to use find_path and find_library
# and pass it the assumed vulkan sdk root dir locations as hints.
# If there is no vulkan root dir, this won't fail, but simply use the
# normal search heuristics that presumably know common file layouts.

# We don't need to be exact about finding the vulkan header
# and library since we just want to check whether the SDK looks
# like it is properly installed. Therefore we'll pass all the
# hints for both Windows and Un*x in one go.

set(VULKAN_ERROR_DL "Before continuing, please download and install Vulkan from:\n    https://vulkan.lunarg.com/sdk/home\nIf you have already downloaded it, make sure the VULKAN_SDK environment variable is set to vulkan's installation root.")

if (OFF)
message("===>")
get_directory_property(tmp_var_names VARIABLES)
foreach(tmp_var_name IN LISTS tmp_var_names)
    message("${tmp_var_name} = \"${${tmp_var_name}}\"")
endforeach()
message("<===")
endif()

set(CMAKE_LIBRARY_ARCHITECTURE "x86_64-linux-gnu")

file(TO_CMAKE_PATH "$ENV{VULKAN_SDK}" VULKAN_SDK_DIR)
find_path(INCLUDE_FILE NAMES vulkan/vulkan.h PATHS
    "${VULKAN_SDK_DIR}/Include"
    "${VULKAN_SDK_DIR}/include"
    "/usr/include")
find_library(LIBRARY_FILE NAMES vulkan vulkan vulkan-1 PATHS 
    "${VULKAN_SDK_DIR}/Lib"
    "${VULKAN_SDK_DIR}/Lib32"
    "${VULKAN_SDK_DIR}/Bin"
    "${VULKAN_SDK_DIR}/Bin32"
    "${VULKAN_SDK_DIR}/lib"
    "/usr/lib/x86_64-linux-gnu")

message(FATAL_ERROR "====> ${INCLUDE_FILE} || ${LIBRARY_FILE}")


if (INCLUDE_FILE AND LIBRARY_FILE)
    message(STATUS "Found Vulkan SDK version ${VULKAN_VERSION}")
else()
    message(FATAL_ERROR "Could not find Vulkan SDK. ${VULKAN_ERROR_DL}")
endif()

#<<<<

if (OFF)

message(STATUS "Querying VULKAN_SDK Enviroment variable")
file(TO_CMAKE_PATH "$ENV{VULKAN_SDK}" VULKAN_DIR)
set(VULKAN_INCLUDE "${VULKAN_DIR}/include/vulkan/")
set(VULKAN_ERROR_DL "Before continuing, please download and install Vulkan from:\n    https://vulkan.lunarg.com/sdk/home\nIf you have already downloaded it, make sure the VULKAN_SDK environment variable is set to vulkan's installation root.")

if(NOT DEFINED ENV{VULKAN_SDK})
    message(FATAL_ERROR "Could not find Vulkan SDK. ${VULKAN_ERROR_DL}")
endif()

message(STATUS "Searching " ${VULKAN_INCLUDE} " for vulkan.h")
if(NOT EXISTS "${VULKAN_INCLUDE}/vulkan.h")
    message(FATAL_ERROR "Could not find vulkan.h. ${VULKAN_ERROR_DL}")
endif()
message(STATUS "Found vulkan.h")

# Check if the user left the version in the installation directory e.g. c:/vulkanSDK/1.1.82.1/
if(VULKAN_DIR MATCHES "(([0-9]+)\\.([0-9]+)\\.([0-9]+)\\.([0-9]+))")
    set(VULKAN_VERSION "${CMAKE_MATCH_1}")
    set(VULKAN_MAJOR "${CMAKE_MATCH_2}")
    set(VULKAN_MINOR "${CMAKE_MATCH_3}")
    set(VULKAN_PATCH "${CMAKE_MATCH_4}")
    message(STATUS "Found Vulkan SDK version ${VULKAN_VERSION}")

    set(VULKAN_REQUIRED_VERSION "1.1.82.1")
    if (VULKAN_MAJOR LESS 1 OR VULKAN_MINOR LESS 1 OR VULKAN_PATCH LESS 82)
        message(FATAL_ERROR "Vulkan ${VULKAN_VERSION} but ${VULKAN_REQUIRED_VERSION} is required. Please download and install a more recent version from:"
                            "\n    https://vulkan.lunarg.com/sdk/home\n")
    endif()
endif()

if (EXISTS ${VULKAN_DIR}/../LICENSE.txt)
    configure_file(${VULKAN_DIR}/../LICENSE.txt ${CURRENT_PACKAGES_DIR}/share/vulkan/copyright COPYONLY)
elseif(EXISTS ${VULKAN_DIR}/LICENSE.txt)
    configure_file(${VULKAN_DIR}/LICENSE.txt ${CURRENT_PACKAGES_DIR}/share/vulkan/copyright COPYONLY)
else()
    configure_file(${CURRENT_PORT_DIR}/LICENSE.txt ${CURRENT_PACKAGES_DIR}/share/vulkan/copyright COPYONLY)
endif()

endif()

SET(VCPKG_POLICY_EMPTY_PACKAGE enabled)
