//
//  AppDelegate.m
//  ShortcutsDemo
//
//  Created by Jovi on 10/9/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

#import "AppDelegate.h"
#import <ShortcutsKit/ShortcutsKit.h>

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    SCKeyCombo *keyCombo = [[SCKeyCombo alloc] initWithKeyCode:kVK_Space keyModifiers:shiftKey + optionKey + controlKey];
    SCKeyComboView *keyComboView = [SCKeyComboView standardKeyComboView];
    [keyComboView setDelegate:(id<SCKeyComboViewDelegate>)self];
    [keyComboView setKeyCombo:keyCombo];
    [[_window contentView] addSubview:keyComboView];
    [keyComboView setFrameOrigin:NSMakePoint(100, 118)];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(void)keyComboWillChange:(SCKeyComboView *)keyComboView{
    NSLog(@"will change.");
}

-(void)keyComboDidChanged:(SCKeyComboView *)keyComboView{
    if (0 == [[keyComboView keyCombo] keyModifiers]) {
        [keyComboView setKeyCombo:nil];
        return;
    }
    NSLog(@"%@",[[keyComboView keyCombo] stringForKeyCombo]);
}

@end
