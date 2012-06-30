//
//  ANDisplaySetting.m
//  FreeRez
//
//  Created by Alex Nichol on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANDisplaySetting.h"

@implementation ANDisplaySetting

@synthesize displayMode;

- (id)initWithDisplayMode:(CGDisplayModeRef)mode {
    if ((self = [super init])) {
        displayMode = CGDisplayModeRetain(mode);
    }
    return self;
}

- (CGSize)size {
    return CGSizeMake(CGDisplayModeGetWidth(displayMode),
                      CGDisplayModeGetHeight(displayMode));
}

- (CGFloat)refreshRate {
    return CGDisplayModeGetRefreshRate(displayMode);
}

- (CGFloat)scale {
    CFDictionaryRef infoDict = ((CFDictionaryRef *)displayMode)[2]; // DIRTY, dirty, smelly, no good very bad hack
    float scale = 0;
    CFNumberGetValue(CFDictionaryGetValue(infoDict, CFSTR("kCGDisplayResolution")),
                     kCFNumberFloatType, &scale);
    return (CGFloat)scale;
}

- (int)bitsPerPixel {
    CFStringRef str = CGDisplayModeCopyPixelEncoding(displayMode);
    int bpp = CFStringGetLength(str);
    CFRelease(str);
    return bpp;
}

- (BOOL)isEqualToSetting:(ANDisplaySetting *)aSetting {
    return (self.bitsPerPixel == aSetting.bitsPerPixel && CGSizeEqualToSize(self.size, aSetting.size) &&
            self.refreshRate == aSetting.refreshRate && self.scale == aSetting.scale);
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%fx%f scale:%f", self.size.width, self.size.height, self.scale];
}

- (void)dealloc {
    CGDisplayModeRelease(displayMode);
}

@end
