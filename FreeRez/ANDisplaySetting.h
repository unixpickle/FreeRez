//
//  ANDisplaySetting.h
//  FreeRez
//
//  Created by Alex Nichol on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ANDisplaySetting : NSObject {
    CGDisplayModeRef displayMode;
}

@property (readonly) CGDisplayModeRef displayMode;

- (id)initWithDisplayMode:(CGDisplayModeRef)mode;
- (CGSize)size;
- (CGFloat)refreshRate;
- (CGFloat)scale;
- (int)bitsPerPixel;

- (BOOL)isEqualToSetting:(ANDisplaySetting *)aSetting;

@end
