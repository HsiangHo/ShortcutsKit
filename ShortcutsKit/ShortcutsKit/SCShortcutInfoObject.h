//
//  SCShortcutInfoObject.h
//  ShortcutsKit
//
//  Created by Jovi on 1/8/19.
//  Copyright © 2019 Jovi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCHotkey;
@interface SCShortcutInfoObject : NSObject

@property (nonatomic, strong, readwrite)        NSString        *descr;
@property (nonatomic, strong, readwrite)        SCHotkey        *hotkey;
@property (nonatomic, strong, readwrite)        NSImage         *icon;

@end
