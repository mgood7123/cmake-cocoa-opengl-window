#include <MultiTouch/MultiTouch.h>

class OpenGLWindow {
    public:
    void main() {};
    void onTouch(MultiTouch & touchEvent) {
        Log::Debug("touch event");
    };
};

extern OpenGLWindow * getWindow();