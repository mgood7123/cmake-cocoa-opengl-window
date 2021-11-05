cmake_minimum_required(VERSION 3.10.2)
project(CocoaWindow)

# Application Bundle

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_WARN_DEPRECATED FALSE)

set(COCOA_WINDOW_DIR ${CMAKE_CURRENT_SOURCE_DIR} PARENT_SCOPE)

macro(buildOpenGLWindow name target)
    add_executable(${name} MACOSX_BUNDLE
        ${COCOA_WINDOW_DIR}/main.mm
        ${COCOA_WINDOW_DIR}/AppDelegate.mm
        ${COCOA_WINDOW_DIR}/OpenGLRenderer.mm
        ${COCOA_WINDOW_DIR}/GLEssentialsGLView.mm
    )

    # do not warn about GL's deprecated api's
    set_property(
        TARGET ${name}
        APPEND PROPERTY
        COMPILE_DEFINITIONS GL_SILENCE_DEPRECATION
    )

    # do not warn about API deprecation
    set_property(
        TARGET ${name}
        APPEND PROPERTY
        COMPILE_OPTIONS -Wno-deprecated-declarations
    )

    # Include demo source code dir because the MacOS cube's Objective-C source includes
    # the "original" cube application C source code.
    # Also include the MoltenVK helper files.
    target_include_directories(${name} PRIVATE ${COCOA_WINDOW_DIR})

    target_link_libraries(
        ${name}
        "-framework Cocoa"
        "-framework CoreVideo"
        "-framework OpenGL"
        OpenGLWindow
        ${target}
    )

    # Set the OS X Bundle specific CMake variables which will be used to populate the plist for
    # the application bundle
    # set(MACOSX_BUNDLE_GUI_IDENTIFIER "org.vtk.SimpleCocoaVTK")
    # set(MACOSX_BUNDLE_BUNDLE_NAME ${PROJECT_NAME})

    # These variables are specific to our plist and are NOT standard CMake variables
    # set(MACOSX_BUNDLE_NSMAIN_NIB_FILE "MainMenu")
    # set(MACOSX_BUNDLE_NSPRINCIPAL_CLASS "NSApplication")

    set_target_properties(${name} PROPERTIES
        MACOSX_BUNDLE_INFO_PLIST ${COCOA_WINDOW_DIR}/Info.plist
        # XCODE_EMBED_FRAMEWORKS AppInstance
        # XCODE_EMBED_FRAMEWORKS_CODE_SIGN_ON_COPY TRUE
    )

    # Make sure we can find the 'ibtool' program. If we can NOT find it we
    # skip generation of this project
    find_program(IBTOOL ibtool HINTS "/usr/bin" "${OSX_DEVELOPER_ROOT}/usr/bin")
    if (${IBTOOL} STREQUAL "IBTOOL-NOTFOUND")
    message(SEND_ERROR "ibtool can not be found and is needed to compile the .xib files. It should have been installed with the Apple developer tools. The default system paths were searched in addition to ${OSX_DEVELOPER_ROOT}/usr/bin")
    endif()

    # Make sure the 'Resources' Directory is correctly created before we build
    add_custom_command (TARGET ${name} PRE_BUILD
                        COMMAND mkdir -p ${CMAKE_CURRENT_BINARY_DIR}/${name}.app/Contents/Resources)

    # Compile the .xib files using the 'ibtool' program with the destination being the app package
    add_custom_command (TARGET ${name} POST_BUILD
                        COMMAND ${IBTOOL} --errors --warnings --notices --output-format human-readable-text --compile ${CMAKE_CURRENT_BINARY_DIR}/${name}.app/Contents/Resources/MainMenu.nib ${COCOA_WINDOW_DIR}/Base.lproj/MainMenu.xib
                        COMMENT "Compiling Base.lproj/MainMenu.xib")


    # Fix up the library search path in the executable to find (loader) libraries in the bundle.
    install(CODE "
        include(BundleUtilities)
        fixup_bundle(${CMAKE_INSTALL_PREFIX}/${name}.app \"\" \"\")
        verify_app(${CMAKE_INSTALL_PREFIX}/${name}.app)
        " COMPONENT Runtime
    )

endmacro()