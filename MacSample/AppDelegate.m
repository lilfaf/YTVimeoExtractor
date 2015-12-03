//
//  AppDelegate.m
//  MacSample
//
//  Created by Louis Larpin on 14/12/2014.
//  Copyright (c) 2014 Louis Larpin. All rights reserved.
//

#import "MainWindowController.h"
#import "AppDelegate.h"

@interface AppDelegate ()

@property(strong, nonatomic) MainWindowController *mainWindowController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    self.mainWindowController = [[MainWindowController alloc] initWithWindowNibName:@"MainWindow"];
    [self.mainWindowController showWindow:self];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
