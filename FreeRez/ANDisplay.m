//
//  ANDisplay.m
//  FreeRez
//
//  Created by Alex Nichol on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANDisplay.h"

static NSMutableArray * activeDisplays = nil;

@interface ANDisplay (Private)

- (void)handleReconfiguration;

@end

static void _DisplayReconfigurationCallback(CGDirectDisplayID display,
                                            CGDisplayChangeSummaryFlags flags,
                                            void * userInfo) {
    
    if (flags & kCGDisplaySetModeFlag) {
        for (ANDisplay * aDisplay in activeDisplays) {
            if (aDisplay.displayID == display) {
                [aDisplay handleReconfiguration];
            }
        }
    }
}

@implementation ANDisplay

@synthesize displayID;

+ (NSArray *)allDisplays {
    NSMutableArray * displays = [[NSMutableArray alloc] init];
    
    uint32_t maxDisplays = 20;
    CGDirectDisplayID output[20];
    uint32_t displayCount = 0;
    CGGetOnlineDisplayList(maxDisplays, output, &displayCount);
    for (uint32_t i = 0; i < displayCount; i++) {
        ANDisplay * display = [[ANDisplay alloc] initWithDisplayID:output[i]];
        [displays addObject:display];
        [display availableSettings];
    }
    
    return [NSArray arrayWithArray:displays];
}

+ (ANDisplay *)mainDisplay {
    return [[ANDisplay alloc] initWithDisplayID:CGMainDisplayID()];
}

+ (ANDisplay *)displayWithScreen:(NSScreen *)aScreen {
    [self allDisplays];
    CGDirectDisplayID displays[16];
    CGDisplayCount displayCount = 0;
    
    NSRect mainDisp = [[NSScreen mainScreen] frame];
    NSRect frame = [aScreen frame];
    frame.origin.y = (mainDisp.origin.y + mainDisp.size.height) - (frame.origin.y + frame.size.height);
    
    CGError err = CGGetDisplaysWithRect(CGRectMake(NSMinX(frame), NSMinY(frame), NSWidth(frame), NSHeight(frame)),
                                        16, displays, &displayCount);
    if (err != kCGErrorSuccess) return nil;
    if (displayCount < 1) return nil;
    
    return [[ANDisplay alloc] initWithDisplayID:displays[0]];
}

- (id)initWithDisplayID:(CGDirectDisplayID)theID {
    if ((self = [super init])) {
        displayID = theID;
        [self handleReconfiguration];
        if (!activeDisplays) {
            activeDisplays = [[NSMutableArray alloc] init];
            CGDisplayRegisterReconfigurationCallback(_DisplayReconfigurationCallback, NULL);
        }
        [activeDisplays addObject:self];
    }
    return self;
}

- (NSArray *)availableSettings {
    NSMutableArray * settings = [[NSMutableArray alloc] init];
        
    CFArrayRef modes = CGDisplayCopyAllDisplayModes(displayID, NULL);
        
    for (int i = 0; i < CFArrayGetCount(modes); i++) {
        CGDisplayModeRef mode = (CGDisplayModeRef)CFArrayGetValueAtIndex(modes, i);        
        ANDisplaySetting * setting = [[ANDisplaySetting alloc] initWithDisplayMode:mode];
        [settings addObject:setting];
    }
    
    CFRelease(modes);
    
    return [NSArray arrayWithArray:settings];
}

- (ANDisplaySetting *)currentSetting {
    return currentSetting;
}

- (void)setCurrentSetting:(ANDisplaySetting *)setting {
    CGDisplayConfigRef config;
    if (CGBeginDisplayConfiguration(&config) == kCGErrorSuccess) {
        CGConfigureDisplayWithDisplayMode(config, displayID, setting.displayMode, NULL);
        CGError err = CGCompleteDisplayConfiguration(config, kCGConfigureForSession);
        if (err == kCGErrorSuccess) {
            //[self willChangeValueForKey:@"currentSetting"];
            //currentSetting = setting;
            //[self didChangeValueForKey:@"currentSetting"];
        }
    }
}

- (void)dealloc {
    [activeDisplays removeObject:self];
}

#pragma mark - KVO -

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)theKey {
    BOOL automatic = NO;
    if ([theKey isEqualToString:@"currentSetting"]) {
        automatic = NO;
    } else {
        automatic = [super automaticallyNotifiesObserversForKey:theKey];
    }
    return automatic;
}

#pragma mark - Private -

- (void)handleReconfiguration {
    CGDisplayModeRef current = CGDisplayCopyDisplayMode(displayID);
    ANDisplaySetting * setting = [[ANDisplaySetting alloc] initWithDisplayMode:current];
    if ([setting isEqualToSetting:currentSetting]) return;
    [self willChangeValueForKey:@"currentSetting"];
    currentSetting = setting;
    [self didChangeValueForKey:@"currentSetting"];
    CGDisplayModeRelease(current);
}

@end
