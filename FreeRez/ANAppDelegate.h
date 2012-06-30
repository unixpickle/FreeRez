//
//  ANAppDelegate.h
//  FreeRez
//
//  Created by Alex Nichol on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ANDisplay.h"

@interface ANAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate, NSTableViewDelegate, NSTableViewDataSource> {
    IBOutlet NSButton * setButton;
    IBOutlet NSTableView * tableView;
    
    ANDisplay * currentDisplay;
    NSArray * availableSettings;
}

@property (assign) IBOutlet NSWindow * window;

- (IBAction)setResolution:(id)sender;
- (void)handleDisplayChanged;

@end
