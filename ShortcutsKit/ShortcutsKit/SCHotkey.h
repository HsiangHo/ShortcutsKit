//
//  SCHotkey.h
//  ShortcutsKit
//
//  Created by Jovi on 10/9/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCKeyCombo.h"

NS_ASSUME_NONNULL_BEGIN
@interface SCHotkey : NSObject

typedef void(^hotkeyHandler)(SCHotkey *hotkey);

@property (nonatomic, strong, readonly)       NSString              *identifier;
@property (nonatomic, strong, readonly)       SCKeyCombo            *keyCombo;
@property (nonatomic, strong, readwrite)      id                    target;
@property (nonatomic, assign, readwrite)      SEL                   selector;   //with object:  SCHotkey
@property (nonatomic, strong, readwrite)      hotkeyHandler         handler;
@property (nonatomic, assign, readwrite)      NSUInteger            hotKeyID;
@property (nonatomic, assign, readwrite)      EventHotKeyRef        hotKeyRef;

-(instancetype)initWithKeyCombo:(SCKeyCombo *)keyCombo identifier:(NSString *)identifier target:(id)target action: (SEL)selector;
-(instancetype)initWithKeyCombo:(SCKeyCombo *)keyCombo identifier:(NSString *)identifier handler:(hotkeyHandler)handler;
-(void)invoke;
-(BOOL)register;
-(void)unregister;

@end
NS_ASSUME_NONNULL_END
