//
//  SCHotkey.m
//  ShortcutsKit
//
//  Created by Jovi on 10/9/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

#import "SCHotkey.h"
#import "SCHotkeyManager.h"

@implementation SCHotkey{
    NSString            *_identifier;
    SCKeyCombo          *_keyCombo;
    id                  _target;
    SEL                 _selector;
    hotkeyHandler       _handler;
    EventHotKeyRef      _hotKeyRef;
    NSUInteger          _hotKeyID;
}

-(instancetype)initWithKeyCombo:(SCKeyCombo *)keyCombo identifier:(NSString *)identifier target:(id)target action: (SEL)selector{
    if (self = [super init]) {
        _keyCombo = keyCombo;
        _identifier = identifier;
        _target = target;
        _selector = selector;
        _handler = NULL;
        _hotKeyRef = NULL;
        _hotKeyID = -1;
    }
    return self;
}

-(instancetype)initWithKeyCombo:(SCKeyCombo *)keyCombo identifier:(NSString *)identifier handler:(hotkeyHandler)handler{
    if (self = [super init]) {
        _keyCombo = keyCombo;
        _identifier = identifier;
        _handler = handler;
        _target = nil;
        _selector = nil;
    }
    return self;
}

-(BOOL)updateKeyCombo:(SCKeyCombo*)keyCombo{
    BOOL bRslt = YES;
    if ([[SCHotkeyManager sharedManager] isHotkeyRegisted:self]) {
        [[SCHotkeyManager sharedManager] unregisterWithHotkey:self];
        SCKeyCombo *tmp = _keyCombo;
        _keyCombo = keyCombo;
        if (![[SCHotkeyManager sharedManager] registerWithHotkey:self]) {
            bRslt = NO;
            _keyCombo = tmp;
            [[SCHotkeyManager sharedManager] registerWithHotkey:self];
        }
    }else{
        _keyCombo = keyCombo;
    }
    return bRslt;
}

-(void)invoke{
    if (NULL == _handler) {
        if ([_target respondsToSelector:_selector]) {
            ((void (*)(SCHotkey *hotkey))[_target methodForSelector:_selector])(self);
        }
    }else{
        _handler(self);
    }
}

-(BOOL)register{
    return [[SCHotkeyManager sharedManager] registerWithHotkey:self];
}

-(void)unregister{
    [[SCHotkeyManager sharedManager] unregisterWithHotkey:self];
}

-(BOOL)isEqual:(id)object{
    BOOL bRslt = NO;
    if ([object isKindOfClass:[self class]]) {
        SCHotkey *other = (SCHotkey *)object;
        if ([[other keyCombo] isEqual:_keyCombo] && [[other identifier] isEqualToString:_identifier]) {
            bRslt = YES; 
        }
    }
    return bRslt;
}

@end

