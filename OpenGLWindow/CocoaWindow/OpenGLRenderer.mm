//
//  OpenGLRenderer.m
//  OpenGLApp
//
//  Created by Matthew Good on 28/7/21.
//
// https://developer.apple.com/library/archive/samplecode/GLEssentials/Listings/

#import "OpenGLRenderer.h"

@implementation OpenGLRenderer

- (instancetype) init {
    window = getWindow();
    multiTouch.setMaxSupportedTouches(10);
    // appInstance = new AppInstance();
    return self;
}

- (void)touchesBeganWithTouch:(NSTouch *)touch AndPoint:(NSPoint)point {
    multiTouch.addTouch(
        ((NSInteger) touch.identity),
        point.x,
        point.y
    );
    window->onTouch(multiTouch);
}

- (void)touchesMovedWithTouch:(NSTouch *)touch AndPoint:(NSPoint)point {
    multiTouch.moveTouch(
        ((NSInteger) touch.identity),
        point.x,
        point.y
    );
    window->onTouch(multiTouch);
}

- (void)touchesEndedWithTouch:(NSTouch *)touch AndPoint:(NSPoint)point {
    multiTouch.removeTouch(
        ((NSInteger) touch.identity),
        point.x,
        point.y
    );
    window->onTouch(multiTouch);
}

- (void)touchesCancelledWithTouch:(NSTouch *)touch AndPoint:(NSPoint)point {
    multiTouch.cancelTouch(
        ((NSInteger) touch.identity),
        point.x,
        point.y
    );
    window->onTouch(multiTouch);
}

- (void) resizeWithWidth:(GLuint)width AndHeight:(GLuint)height

{
    // appInstance->surfaceChanged(width, height);
}

- (void) render

{
    // appInstance->onDraw();
}

- (void) destroy
{
    delete window;
}

@end
