//
//  ANAppDelegate.m
//  FreeRez
//
//  Created by Alex Nichol on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ANAppDelegate.h"

@implementation ANAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self handleDisplayChanged];
    
    [_window setDelegate:self];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    // Insert code here to initialize your application
}

- (IBAction)setResolution:(id)sender {
    ANDisplaySetting * setting = [availableSettings objectAtIndex:[tableView selectedRow]];
    [currentDisplay setCurrentSetting:setting];
}

- (void)windowDidChangeScreen:(NSNotification *)notification {
    [self handleDisplayChanged];
}

- (void)handleDisplayChanged {
    currentDisplay = [ANDisplay displayWithScreen:[_window screen]];
    
    // filter out the bad settings
    NSArray * allSettings = [currentDisplay availableSettings];
    int maxBits = 0;
    
    for (ANDisplaySetting * setting in allSettings) {
        maxBits = MAX([setting bitsPerPixel], maxBits);
    }
    
    NSMutableArray * mUseSettings = [NSMutableArray array];
    for (ANDisplaySetting * setting in allSettings) {
        if ([setting scale] != 1) continue;
        if ([setting bitsPerPixel] < maxBits) continue;
        BOOL sizeExists = NO;
        for (ANDisplaySetting * prevSetting in mUseSettings) {
            if (CGSizeEqualToSize(prevSetting.size, setting.size)) {
                sizeExists = YES;
                break;
            }
        }
        if (!sizeExists) [mUseSettings addObject:setting];
    }
    
    availableSettings = [NSArray arrayWithArray:mUseSettings];
    [tableView reloadData];
}

#pragma mark - Table View -

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [availableSettings count];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger index = [tableView selectedRow];
    if (index < 0) {
        [setButton setEnabled:NO];
        return;
    }
    [setButton setEnabled:YES];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    ANDisplaySetting * setting = [availableSettings objectAtIndex:row];
    return [NSString stringWithFormat:@"%d x %d", (int)setting.size.width, (int)setting.size.height];
}

@end
