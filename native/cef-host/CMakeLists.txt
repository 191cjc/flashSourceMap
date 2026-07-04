cmake_minimum_required(VERSION 3.19)

project(FlashSourceMapNativeHost LANGUAGES CXX)

set(CEF_ROOT "" CACHE PATH "Path to the CEF standard binary distribution")
if(NOT CEF_ROOT)
  message(FATAL_ERROR "Set CEF_ROOT to a CEF standard binary distribution directory.")
endif()

file(TO_CMAKE_PATH "${CEF_ROOT}" CEF_ROOT)
if(NOT EXISTS "${CEF_ROOT}/include/cef_app.h")
  message(FATAL_ERROR "CEF_ROOT does not look like a CEF standard distribution: ${CEF_ROOT}")
endif()
if(NOT EXISTS "${CEF_ROOT}/Release/libcef.lib")
  message(FATAL_ERROR "CEF_ROOT is missing Release/libcef.lib: ${CEF_ROOT}")
endif()
if(EXISTS "${CEF_ROOT}/libcef_dll_wrapper")
  set(CEF_WRAPPER_ROOT "${CEF_ROOT}/libcef_dll_wrapper")
elseif(EXISTS "${CEF_ROOT}/libcef_dll")
  set(CEF_WRAPPER_ROOT "${CEF_ROOT}/libcef_dll")
else()
  message(FATAL_ERROR "CEF_ROOT is missing libcef_dll/libcef_dll_wrapper sources: ${CEF_ROOT}")
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/out")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_BINARY_DIR}/out")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_BINARY_DIR}/out")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO "${CMAKE_BINARY_DIR}/out")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_MINSIZEREL "${CMAKE_BINARY_DIR}/out")

file(GLOB_RECURSE CEF_WRAPPER_SOURCES CONFIGURE_DEPENDS
  "${CEF_WRAPPER_ROOT}/*.cc"
)

add_library(libcef_dll_wrapper STATIC ${CEF_WRAPPER_SOURCES})
target_include_directories(libcef_dll_wrapper PUBLIC "${CEF_ROOT}")
target_compile_definitions(libcef_dll_wrapper PUBLIC
  NOMINMAX
  WIN32_LEAN_AND_MEAN
  WRAPPING_CEF_SHARED
)

add_executable(flash-native-host WIN32
  src/main_win.cc
  src/native_app.cc
  src/native_handler.cc
)

target_include_directories(flash-native-host PRIVATE "${CEF_ROOT}" "src")
target_compile_definitions(flash-native-host PRIVATE NOMINMAX WIN32_LEAN_AND_MEAN)
target_link_libraries(flash-native-host PRIVATE
  libcef_dll_wrapper
  "${CEF_ROOT}/Release/libcef.lib"
  comctl32.lib
  dbghelp.lib
  delayimp.lib
  gdi32.lib
  rpcrt4.lib
  shlwapi.lib
  user32.lib
  ws2_32.lib
)

if(MSVC)
  target_compile_options(libcef_dll_wrapper PRIVATE /EHsc /MP)
  target_compile_options(flash-native-host PRIVATE /EHsc /MP)
  target_link_options(flash-native-host PRIVATE /DELAYLOAD:libcef.dll)
endif()

set(CEF_RUNTIME_FILES
  cef.pak
  cef_100_percent.pak
  cef_200_percent.pak
  cef_extensions.pak
  chrome_elf.dll
  d3dcompiler_47.dll
  D3DCompiler_47.dll
  devtools_resources.pak
  icudtl.dat
  libcef.dll
  libEGL.dll
  libGLESv2.dll
  natives_blob.bin
  snapshot_blob.bin
  v8_context_snapshot.bin
)

foreach(file_name IN LISTS CEF_RUNTIME_FILES)
  if(EXISTS "${CEF_ROOT}/Release/${file_name}")
    add_custom_command(TARGET flash-native-host POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E copy_if_different
        "${CEF_ROOT}/Release/${file_name}"
        "$<TARGET_FILE_DIR:flash-native-host>/${file_name}"
    )
  endif()
endforeach()

foreach(dir_name locales swiftshader)
  if(EXISTS "${CEF_ROOT}/Release/${dir_name}")
    add_custom_command(TARGET flash-native-host POST_BUILD
      COMMAND ${CMAKE_COMMAND} -E copy_directory
        "${CEF_ROOT}/Release/${dir_name}"
        "$<TARGET_FILE_DIR:flash-native-host>/${dir_name}"
    )
  endif()
endforeach()

install(TARGETS flash-native-host RUNTIME DESTINATION Release)

foreach(file_name IN LISTS CEF_RUNTIME_FILES)
  if(EXISTS "${CEF_ROOT}/Release/${file_name}")
    install(FILES "${CEF_ROOT}/Release/${file_name}" DESTINATION Release)
  endif()
endforeach()

foreach(dir_name locales swiftshader)
  if(EXISTS "${CEF_ROOT}/Release/${dir_name}")
    install(DIRECTORY "${CEF_ROOT}/Release/${dir_name}" DESTINATION Release)
  endif()
endforeach()
