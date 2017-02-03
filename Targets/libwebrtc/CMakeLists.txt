cmake_minimum_required(VERSION 3.5)
project(libwebrtc)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH}
    ${CMAKE_SOURCE_DIR}/CMakeModules)

set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT")
set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MTd")

if (WIN32)
  set(LIBWEBRTC_OBJ_EXT obj)
elseif (UNIX AND NOT APPLE)
  set(LIBWEBRTC_OBJ_EXT o)
elseif (APPLE)
  set(LIBWEBRTC_OBJ_EXT o)
endif ()

file(GLOB_RECURSE LIBWEBRTC_OBJ_FILES
     ${LIBWEBRTC_OUTPUT_DIR}/obj/*.${LIBWEBRTC_OBJ_EXT})

# capture the assembly compile outputs of libvpx_yasm.lib and other third_party libs
if (WIN32)
    file(GLOB_RECURSE LIBWEBRTC_O_FILES
         ${LIBWEBRTC_OUTPUT_DIR}/obj/*.o)
    list(APPEND LIBWEBRTC_OBJ_FILES ${LIBWEBRTC_O_FILES})
endif()

list(FILTER LIBWEBRTC_OBJ_FILES EXCLUDE REGEX test)
list(FILTER LIBWEBRTC_OBJ_FILES EXCLUDE REGEX unittests)
list(FILTER LIBWEBRTC_OBJ_FILES EXCLUDE REGEX third_party/yasm/gen)
list(FILTER LIBWEBRTC_OBJ_FILES EXCLUDE REGEX third_party/yasm/re2c)
list(FILTER LIBWEBRTC_OBJ_FILES EXCLUDE REGEX third_party/yasm/re2c)
list(FILTER LIBWEBRTC_OBJ_FILES EXCLUDE REGEX third_party/protobuf/protoc)
list(FILTER LIBWEBRTC_OBJ_FILES EXCLUDE REGEX third_party/protobuf/protobuf_full)
list(FILTER LIBWEBRTC_OBJ_FILES EXCLUDE REGEX webrtc/examples)
list(FILTER LIBWEBRTC_OBJ_FILES EXCLUDE REGEX webrtc/tools)
list(FILTER LIBWEBRTC_OBJ_FILES EXCLUDE REGEX webrtc/modules/video_capture/video_capture/video_capture_external)
list(FILTER LIBWEBRTC_OBJ_FILES EXCLUDE REGEX webrtc/modules/video_capture/video_capture/device_info_external)
list(FILTER LIBWEBRTC_OBJ_FILES EXCLUDE REGEX webrtc/modules/video_capture/video_capture/device_info_external)

#add fakeaudio device 
file(GLOB_RECURSE LIBWEBRTC_TEST_COMMON_FILES 
      "${LIBWEBRTC_OUTPUT_DIR}/obj/webrtc/test/test_common/*.${LIBWEBRTC_OBJ_EXT}"
      "${LIBWEBRTC_OUTPUT_DIR}/obj/testing/gtest/gtest*.${LIBWEBRTC_OBJ_EXT}")
list(APPEND LIBWEBRTC_OBJ_FILES ${LIBWEBRTC_TEST_COMMON_FILES})

add_library(webrtc STATIC ${LIBWEBRTC_OBJ_FILES})

set_source_files_properties(${LIBWEBRTC_OBJ_FILES} PROPERTIES
                            EXTERNAL_OBJECT true
                            GENERATED true)

set_target_properties(webrtc PROPERTIES
                      LINKER_LANGUAGE C
                      LIBRARY_OUTPUT_DIRECTORY ${LIBWEBRTC_OUTPUT_DIR}
                      PREFIX lib)

#
# Install headers
#
install(DIRECTORY ${LIBWEBRTC_INCLUDE_DIR}
        DESTINATION "include"
        FILES_MATCHING PATTERN "*.h")

#
# Install library
#
install(TARGETS webrtc
        DESTINATION "lib"
        COMPONENT Libraries)