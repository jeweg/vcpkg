get_filename_component(_IMPORT_PREFIX "${CMAKE_CURRENT_LIST_FILE}" PATH)
get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)
get_filename_component(_IMPORT_PREFIX "${_IMPORT_PREFIX}" PATH)

if(_VCPKG_TARGET_TRIPLET_PLAT STREQUAL "linux")
    set(_LIB_PREFIX "lib")
    set(_LIB_SUFFIX ".a")
else()
    set(_LIB_PREFIX "")
    set(_LIB_SUFFIX ".lib")
endif()

add_library(unofficial::shaderc::shaderc STATIC IMPORTED GLOBAL)
set_target_properties(unofficial::shaderc::shaderc PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${_IMPORT_PREFIX}/include"
    IMPORTED_LOCATION "${_IMPORT_PREFIX}/lib/${_LIB_PREFIX}shaderc${_LIB_INFIX}${_LIB_SUFFIX}"
    IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/debug/lib/${_LIB_PREFIX}shaderc${_LIB_INFIX}${_LIB_SUFFIX}"
)

add_library(unofficial::shaderc::combined STATIC IMPORTED GLOBAL)
set_target_properties(unofficial::shaderc::combined PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${_IMPORT_PREFIX}/include"
    IMPORTED_LOCATION "${_IMPORT_PREFIX}/lib/${_LIB_PREFIX}shaderc_combined${_LIB_INFIX}${_LIB_SUFFIX}"
    IMPORTED_LOCATION_DEBUG "${_IMPORT_PREFIX}/debug/lib/${_LIB_PREFIX}shaderc_combined${_LIB_INFIX}${_LIB_SUFFIX}"
)

set(_LIB_INFIX)
set(_LIB_PREFIX)
set(_LIB_SUFFIX)
set(_IMPORT_PREFIX)
