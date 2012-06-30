//
//  ANDisplay.h
//  FreeRez
//
//  Created by Alex Nichol on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANDisplaySetting.h"

@interface ANDisplay : NSObject {
    CGDirectDisplayID displayID;
    ANDisplaySetting * currentSetting;
}

@property (nonatomic, retain) ANDisplaySetting * currentSetting;
@property (readonly) CGDirectDisplayID displayID;

+ (NSArray *)allDisplays;
+ (ANDisplay *)mainDisplay;
+ (ANDisplay *)displayWithScreen:(NSScreen *)aScreen;

- (id)initWithDisplayID:(CGDirectDisplayID)theID;
- (NSArray *)availableSettings;

@end
