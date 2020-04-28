#set(_GEN_ARGS use_gold=false target_cpu=\\"${TARGET_CPU}\\" target_os=\\"${TARGET_OS}\\" is_component_build=false)


# linux default:
#set(_GEN_ARGS use_gold=false target_cpu=\\"${TARGET_CPU}\\" target_os=\\"${TARGET_OS}\\" is_component_build=false rtc_include_tests=false use_debug_fission=false  linux_use_bundled_binutils=false treat_warnings_as_errors=false is_debug=false clang_use_chrome_plugins=false use_custom_libcxx=false)

# new windows default:
set(_GEN_ARGS use_gold=false target_cpu=\\"${TARGET_CPU}\\" target_os=\\"${TARGET_OS}\\" rtc_include_tests=false use_sysroot=false use_debug_fission=false linux_use_bundled_binutils=false treat_warnings_as_errors=false is_debug=false clang_use_chrome_plugins=false use_cxx11 = true)

# FIXME with using `use_sysroot=false` keeps failing, the build has compile errors and later linker errors

if (MSVC OR XCODE)
  set(_GEN_ARGS ${_GEN_ARGS} is_debug=$<$<CONFIG:Debug>:true>$<$<CONFIG:Release>:false>$<$<CONFIG:RelWithDebInfo>:false>$<$<CONFIG:MinSizeRel>:false>)
  set(_NINJA_BUILD_DIR out/$<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>$<$<CONFIG:RelWithDebInfo>:Release>$<$<CONFIG:MinSizeRel>:Release>)
elseif (CMAKE_BUILD_TYPE MATCHES Debug)
  set(_GEN_ARGS ${_GEN_ARGS} is_debug=true)
  set(_NINJA_BUILD_DIR out/Debug)
else (MSVC OR XCODE)
  set(_GEN_ARGS ${_GEN_ARGS} is_debug=false)
  set(_NINJA_BUILD_DIR out/Release)
endif (MSVC OR XCODE)

if (GN_EXTRA_ARGS)
  set(_GEN_ARGS ${_GEN_ARGS} ${GN_EXTRA_ARGS})
endif (GN_EXTRA_ARGS)

if (WIN32)
  set(_GN_EXECUTABLE gn.bat)
else (WIN32)
  set(_GN_EXECUTABLE gn)
endif (WIN32)

set(_GEN_COMMAND ${_GN_EXECUTABLE} gen ${_NINJA_BUILD_DIR} --args=\"${_GEN_ARGS}\")
