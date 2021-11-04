#include <OpenGLWindow.h>
#include <iostream>

OpenGLWindow * getWindow() {
    std::cout << "obtained" << std::endl;
    return new OpenGLWindow();
}