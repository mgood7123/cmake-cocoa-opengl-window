cmake_minimum_required(VERSION 3.10.2)
project(OpenGLWindow)

add_subdirectory(MultiTouch)

add_library(OpenGLWindow SHARED OpenGLWindow.cpp)

target_include_directories(OpenGLWindow PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

target_link_libraries(OpenGLWindow MultiTouch)

if (APPLE)
    add_subdirectory(CocoaWindow)
endif()

set(COCOA_WINDOW_DIR ${COCOA_WINDOW_DIR} PARENT_SCOPE)
