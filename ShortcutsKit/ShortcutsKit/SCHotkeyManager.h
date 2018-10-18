//
//  SCHotkeyManager.h
//  ShortcutsKit
//
//  Created by Jovi on 10/9/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCHotkey;
@interface SCHotkeyManager : NSObject

+(instancetype)sharedManager;
-(BOOL)registerWithHotkey:(SCHotkey *)hotkey;
-(void)unregisterWithHotkey:(SCHotkey *)hotkey;
-(void)unregisterWithIdentifier:(NSString *)indentifier;
-(void)unregisterAllHotkeys;

@end
