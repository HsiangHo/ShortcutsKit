//
//  SCShortcutsCenterWindowController.h
//  ShortcutsKit
//
//  Created by Jovi on 1/7/19.
//  Copyright © 2019 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SCHotkey;
@class SCShortcutsCenterWindowController;

NS_CLASS_AVAILABLE_MAC(10_10)
@protocol SCShortcutsCenterWindowControllerDelegate <NSObject>

@optional
-(void)addButton_click:(SCHotkey *)obj withShortcutsCenterWindowController:(SCShortcutsCenterWindowController *)controller;
-(void)removeButton_click:(SCHotkey *)obj withShortcutsCenterWindowController:(SCShortcutsCenterWindowController *)controller;
-(NSString *)shortcutsCenterWindowTitle;
-(NSString *)shortcutsCenterWindowSubtitle;

@end

NS_CLASS_AVAILABLE_MAC(10_10)
@interface SCShortcutsCenterWindowController : NSWindowController

@property (nonatomic, weak, readwrite)      id<SCShortcutsCenterWindowControllerDelegate>       delegate;
@property (nonatomic, copy, readonly)       NSArray<SCHotkey *>                                 *arrayHotkeys;

-(void)addHotkey:(nonnull SCHotkey *)hotkey withDescription:(nonnull NSString *)descr;
-(void)removeHotkey:(nonnull SCHotkey *)hotkey;
-(void)updateUI;

@end
