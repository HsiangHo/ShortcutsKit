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
    
    //Create a keyCombo object for "shift + option + control + space"
    SCKeyCombo *keyCombo = [[SCKeyCombo alloc] initWithKeyCode:kVK_Space keyModifiers:shiftKey + optionKey + controlKey];
    
    //Serialize keyCombo object
    [[NSUserDefaults standardUserDefaults] setValue:[NSKeyedArchiver archivedDataWithRootObject:keyCombo] forKey:@"keyCombo"];
    
    //Deserialization keyCombo object
    SCKeyCombo *keyCombo2 = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] valueForKey:@"keyCombo"]];
    NSLog(@"%@",[keyCombo2 stringForKeyCombo]);
    
    //Create a keyComboView to show the keyCombo
    SCKeyComboView *keyComboView = [SCKeyComboView standardKeyComboView];
    //Cunstomize keyComboView
    [keyComboView setOnTintColor:[NSColor redColor]];
    //Set delegate to handle keyconbo changed notification
    [keyComboView setDelegate:(id<SCKeyComboViewDelegate>)self];
    [keyComboView setKeyCombo:keyCombo2];
    
    //Create a hotkey object from a keyCombo object
    //Using block
    SCHotkey *shortcut = [[SCHotkey alloc] initWithKeyCombo:keyCombo2 identifier:@"shortcut" handler:^(SCHotkey * _Nonnull hotkey) {
        NSLog(@"shortcut has been called");
    }];
    [shortcut register];
    
    //Using selector
    SCKeyCombo *keyCombo3 = [[SCKeyCombo alloc] initWithKeyCode: kVK_ANSI_B keyModifiers: optionKey + controlKey];
    SCHotkey *shortcut2 = [[SCHotkey alloc]initWithKeyCombo:keyCombo3 identifier:@"shortcut2" target:self action:@selector(shortcut2Callback)];
    [shortcut2 register];
    
    //Invoke hotkey object action
    [shortcut invoke];
    
    //Unregister hotkey object
    [shortcut unregister];
    
    //About SCHotkeyManager
    //Register with hotkey object
    [[SCHotkeyManager sharedManager] registerWithHotkey:shortcut];
    //Unregister with identifier
    [[SCHotkeyManager sharedManager] unregisterWithIdentifier:@"shortcut"];
    //Unregister with hotkey object
    [[SCHotkeyManager sharedManager] unregisterWithHotkey:shortcut2];
    //Unregister all hotkey objects
    [[SCHotkeyManager sharedManager] unregisterAllHotkeys];
    
    [[_window contentView] addSubview:keyComboView];
    [keyComboView setFrameOrigin:NSMakePoint(100, 118)];
    
    //About SCShortcutsCenterWindowController
    static SCShortcutsCenterWindowController *wndController = nil;
    wndController = [[SCShortcutsCenterWindowController alloc] init];
    //customize SCShortcutsCenterWindowController
    [wndController setDelegate:(id<SCShortcutsCenterWindowControllerDelegate>)self];
    [wndController showWindow:nil];
    
    SCKeyCombo *k1 = [[SCKeyCombo alloc] initWithKeyCode:kVK_ANSI_A keyModifiers:shiftKey + optionKey + controlKey];
    SCHotkey *s1 = [[SCHotkey alloc]initWithKeyCombo:k1 identifier:@"s1" handler:^(SCHotkey * _Nonnull hotkey) {
        NSLog(@"s1 has been called");
    }];
    [wndController addHotkey:s1 withDescription:@"s1"];
    
    SCKeyCombo *k2 = [[SCKeyCombo alloc] initWithKeyCode:kVK_ANSI_B keyModifiers:shiftKey + optionKey + controlKey];
    SCHotkey *s2 = [[SCHotkey alloc]initWithKeyCombo:k2 identifier:@"s2" handler:^(SCHotkey * _Nonnull hotkey) {
        NSLog(@"s2 has been called");
    }];
    [wndController addHotkey:s2 withDescription:@"s2"];
    
    SCKeyCombo *k3 = [[SCKeyCombo alloc] initWithKeyCode:kVK_ANSI_C keyModifiers:shiftKey + optionKey + controlKey];
    SCHotkey *s3 = [[SCHotkey alloc]initWithKeyCombo:k3 identifier:@"s3" handler:^(SCHotkey * _Nonnull hotkey) {
        NSLog(@"s3 has been called");
    }];
    [wndController addHotkey:s3 withDescription:@"s3"];
    [wndController updateUI];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

-(void)shortcut2Callback{
    NSLog(@"shortcut2 has been called");
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

-(void)addButton_click:(SCHotkey *)obj withShortcutsCenterWindowController:(SCShortcutsCenterWindowController *)controller{
    SCKeyCombo *keyCombo = [[SCKeyCombo alloc] initWithKeyCode:kVK_Space keyModifiers:shiftKey + optionKey + controlKey];
    SCHotkey *shortcut = [[SCHotkey alloc]initWithKeyCombo:keyCombo identifier:@"shortcut" handler:^(SCHotkey * _Nonnull hotkey) {
        NSLog(@"shortcut has been called");
    }];
    [controller addHotkey:shortcut withDescription:@"shortcut"];
    [controller updateUI];
}
-(void)removeButton_click:(SCHotkey *)obj withShortcutsCenterWindowController:(SCShortcutsCenterWindowController *)controller{
    [controller removeHotkey:obj];
    [controller updateUI];
}

-(NSString *)shortcutsCenterWindowTitle{
    return @"title";
}

-(NSString *)shortcutsCenterWindowSubtitle{
    return @"subtitle";
}

@end
