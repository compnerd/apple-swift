
if(CMAKE_SYSTEM_NAME STREQUAL Darwin)
  add_library(swiftDarwin-install_name OBJECT
    ${PROJECT_SOURCE_DIR}/linker-support/magic-symbols-for-install-name.c)
  target_compile_definitions(swiftDarwin-install_name PRIVATE
    SWIFT_TARGET_LIBRARY_NAME=swiftDarwin)

  add_library(swiftDarwin
    MachError.swift
    Platform.swift
    POSIXError.swift
    TiocConstants.swift)
  swift_gyb_target_sources(swiftDarwin PRIVATE
    Darwin.swift.gyb
    tgmath.swift.gyb)
  set_target_properties(swiftDarwin PROPERTIES
    Swift_MODULE_NAME Darwin)
  target_compile_definitions(swiftDarwin PRIVATE
    $<$<BOOL:${SWIFT_STDLIB_ENABLE_REFLECTION}>:SWIFT_ENABLE_REFLECTION>)
  target_compile_options(swiftDarwin PRIVATE
    "SHELL:-Xfrontend -disable-objc-attr-requires-foundation-module")
  target_link_libraries(swiftDarwin PRIVATE
    $<TARGET_OBJECTS:swiftDarwin-install_name>)
endif()

if(NOT CMAKE_SYSTEM_NAME STREQUAL Darwin AND
   NOT CMAKE_SYSTEM_NAME STREQUAL Windows)
  add_library(swiftGlibc
    Platform.swift
    POSIXError.swift
    TiocConstants.swift)
  swift_gyb_target_sources(swiftGlibc PRIVATE
    Glibc.swift.gyb
    tgmath.swift.gyb)
  set_target_properties(swiftGlibc PROPERTIES
    Swift_MODULE_NAME Glibc)
  target_compile_definitions(swiftGlibc PRIVATE
    $<$<BOOL:${SWIFT_STDLIB_ENABLE_REFLECTION}>:SWIFT_ENABLE_REFLECTION>)
endif()

if(CMAKE_SYSTEM_NAME STREQUAL Windows)
  add_library(swiftCRT
    Platform.swift
    POSIXError.swift
    TiocConstants.swift
    ucrt.swift)
  swift_gyb_target_sources(swiftCRT PRIVATE
    tgmath.swift.gyb)
  set_target_properties(swiftCRT PROPERTIES
    Swift_MODULE_NAME CRT)
  target_compile_definitions(swiftCRT PRIVATE
    $<$<BOOL:${SWIFT_STDLIB_ENABLE_REFLECTION}>:SWIFT_ENABLE_REFLECTION>)
  target_compile_options(swiftCRT PRIVATE
    "SHELL:-Xcc -D_USE_MATH_DEFINES")
endif()

## set(glibc_modulemap_target_list)
## foreach(sdk ${SWIFT_SDKS})
##   if(NOT "${sdk}" STREQUAL "LINUX" AND
##      NOT "${sdk}" STREQUAL "FREEBSD" AND
##      NOT "${sdk}" STREQUAL "OPENBSD" AND
##      NOT "${sdk}" STREQUAL "ANDROID" AND
##      NOT "${sdk}" STREQUAL "CYGWIN" AND
##      NOT "${sdk}" STREQUAL "HAIKU")
##     continue()
##   endif()
## 
##   foreach(arch ${SWIFT_SDK_${sdk}_ARCHITECTURES})
##     set(arch_subdir "${SWIFT_SDK_${sdk}_LIB_SUBDIR}/${arch}")
##     set(module_dir "${SWIFTLIB_DIR}/${arch_subdir}")
##     set(module_dir_static "${SWIFTSTATICLIB_DIR}/${arch_subdir}")
## 
##     if(${sdk} STREQUAL ANDROID)
##       set(glibc_modulemap_source "bionic.modulemap.gyb")
##     elseif(${sdk} STREQUAL OPENBSD)
##       set(glibc_modulemap_source "libc-openbsd.modulemap.gyb")
##     else()
##       set(glibc_modulemap_source "glibc.modulemap.gyb")
##     endif()
##     set(glibc_modulemap_out "${module_dir}/glibc.modulemap")
##     set(glibc_modulemap_out_static "${module_dir_static}/glibc.modulemap")
## 
##     # Configure the module map based on the target. Each platform needs to
##     # reference different headers, based on what's available in their glibc.
##     # This is the 'glibc.modulemap' in the 'resource-dir', so
##     # it's the one we'll look at during the build process.
##     handle_gyb_source_single(glibc_modulemap_target
##         SOURCE "${glibc_modulemap_source}"
##         OUTPUT "${glibc_modulemap_out}"
##         FLAGS
##             "-DCMAKE_SDK=${sdk}"
##             "-DGLIBC_INCLUDE_PATH=${SWIFT_SDK_${sdk}_ARCH_${arch}_LIBC_INCLUDE_DIRECTORY}"
##             "-DGLIBC_ARCH_INCLUDE_PATH=${SWIFT_SDK_${sdk}_ARCH_${arch}_LIBC_ARCHITECTURE_INCLUDE_DIRECTORY}")
## 
##     list(APPEND glibc_modulemap_target_list ${glibc_modulemap_target})
## 
##     if(SWIFT_BUILD_STATIC_STDLIB)
##       add_custom_command_target(
##         copy_glibc_modulemap_static
##         COMMAND
##           "${CMAKE_COMMAND}" "-E" "make_directory" ${module_dir_static}
##         COMMAND
##           "${CMAKE_COMMAND}" "-E" "copy" ${glibc_modulemap_out} ${glibc_modulemap_out_static}
##         OUTPUT ${glibc_modulemap_out_static}
##         DEPENDS
##           "${glibc_modulemap_target}"
##         COMMENT "Copying Glibc modulemap to static resources")
## 
##       list(APPEND glibc_modulemap_target_list ${copy_glibc_modulemap_static})
##     endif()
## 
##     set(glibc_header_out "${module_dir}/SwiftGlibc.h")
##     handle_gyb_source_single(glibc_header_target
##         SOURCE "SwiftGlibc.h.gyb"
##         OUTPUT "${glibc_header_out}"
##         FLAGS "-DCMAKE_SDK=${sdk}")
##     list(APPEND glibc_modulemap_target_list ${glibc_header_target})
## 
##     # If this SDK is a target for a non-native host, except if it's for Android
##     # with its own native sysroot, create a native modulemap without a sysroot
##     # prefix. This is the one we'll install instead.
##     if(NOT "${SWIFT_SDK_${SWIFT_HOST_VARIANT_SDK}_ARCH_${arch}_PATH}" STREQUAL "/" AND
##        NOT (${sdk} STREQUAL ANDROID AND NOT "${SWIFT_ANDROID_NATIVE_SYSROOT}" STREQUAL ""))
##       set(glibc_sysroot_relative_modulemap_out "${module_dir}/sysroot-relative-modulemaps/glibc.modulemap")
## 
##       string(REPLACE "${SWIFT_SDK_${SWIFT_HOST_VARIANT_SDK}_ARCH_${arch}_PATH}"
##         "" absolute_libc_include_path "${SWIFT_SDK_${sdk}_ARCH_${arch}_LIBC_INCLUDE_DIRECTORY}")
##       string(REPLACE "${SWIFT_SDK_${SWIFT_HOST_VARIANT_SDK}_ARCH_${arch}_PATH}"
##         "" absolute_libc_arch_include_path ${SWIFT_SDK_${sdk}_ARCH_${arch}_LIBC_ARCHITECTURE_INCLUDE_DIRECTORY})
## 
##       handle_gyb_source_single(glibc_modulemap_native_target
##         SOURCE "${glibc_modulemap_source}"
##         OUTPUT "${glibc_sysroot_relative_modulemap_out}"
##         FLAGS "-DCMAKE_SDK=${sdk}"
##               "-DGLIBC_INCLUDE_PATH=${absolute_libc_include_path}"
##               "-DGLIBC_ARCH_INCLUDE_PATH=${absolute_libc_arch_include_path}")
## 
##       list(APPEND glibc_modulemap_target_list ${glibc_modulemap_native_target})
##       set(glibc_modulemap_out ${glibc_sysroot_relative_modulemap_out})
##     endif()
## 
##     # FIXME: When SDK is a cross-compile target (SDK != Host), the generated
##     #        modulemap will be relative to the Host, with hardcoded paths.
##     #        It is not relocatable to the target platform itself.
##     #        This affects any cross-comipled targets that use glibc.modulemap.
## 
##     swift_install_in_component(FILES "${glibc_modulemap_out}"
##                                DESTINATION "lib/swift/${arch_subdir}"
##                                COMPONENT sdk-overlay)
##     swift_install_in_component(FILES "${glibc_header_out}"
##                                DESTINATION "lib/swift/${arch_subdir}"
##                                COMPONENT sdk-overlay)
## 
##     if(SWIFT_BUILD_STATIC_STDLIB)
##       swift_install_in_component(FILES "${glibc_modulemap_out}"
##                                  DESTINATION "lib/swift_static/${arch_subdir}"
##                                  COMPONENT sdk-overlay)
##       swift_install_in_component(FILES "${glibc_header_out}"
##                                  DESTINATION "lib/swift_static/${arch_subdir}"
##                                  COMPONENT sdk-overlay)
##     endif()
##   endforeach()
## endforeach()
## add_custom_target(glibc_modulemap DEPENDS ${glibc_modulemap_target_list})
## set_property(TARGET glibc_modulemap PROPERTY FOLDER "Miscellaneous")
## add_dependencies(sdk-overlay glibc_modulemap)
