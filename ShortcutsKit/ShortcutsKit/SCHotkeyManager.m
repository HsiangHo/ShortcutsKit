//
//  SCHotkeyManager.m
//  ShortcutsKit
//
//  Created by Jovi on 10/9/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

#import "SCHotkeyManager.h"
#import "SCHotkey.h"

static SCHotkeyManager *instance;
@implementation SCHotkeyManager{
    NSMutableDictionary             *_dictHotkeyIdentifierMap;      //Identifier to Hotkey
    NSMutableDictionary             *_dictHotkeyIndexMap;       //Index to Hotkey
    NSUInteger                      _nIndex;
}

+(instancetype)sharedManager{
    @synchronized(self){
        if(nil == instance){
            instance = [[SCHotkeyManager alloc] init];
        }
        return instance;
    }
}

-(instancetype)init{
    if (self = [super init]) {
        _nIndex = 0;
        _dictHotkeyIdentifierMap = [[NSMutableDictionary alloc] init];
        _dictHotkeyIndexMap = [[NSMutableDictionary alloc] init];
        
        EventTypeSpec eventType;
        eventType.eventClass=kEventClassKeyboard;
        eventType.eventKind=kEventHotKeyPressed;
        InstallApplicationEventHandler(&hotKeyHandler, 1, &eventType, NULL, NULL);
    }
    return self;
}

-(BOOL)isHotkeyRegisted:(SCHotkey *)hotkey{
    BOOL bRslt = NO;
    if(nil == hotkey){
        return bRslt;
    }
    bRslt = nil != [_dictHotkeyIdentifierMap valueForKey:[hotkey identifier]];
    return bRslt;
}

-(BOOL)registerWithHotkey:(SCHotkey *)hotkey{
    BOOL bRslt = NO;
    if(nil == hotkey){
        return bRslt;
    }
    EventHotKeyRef hotKeyRef = NULL;
    EventHotKeyID hotKeyID = {.signature = UTGetOSTypeFromString(CFSTR("ShortcutsKit")), .id = (UInt32)_nIndex};
    OSStatus error = RegisterEventHotKey([[hotkey keyCombo] keyCode], [[hotkey keyCombo] keyModifiers], hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef);
    if (noErr != error || NULL == hotKeyRef) {
        return bRslt;
    }
    
    [hotkey setHotKeyRef:hotKeyRef];
    [_dictHotkeyIdentifierMap setValue:hotkey forKey:[hotkey identifier]];
    [_dictHotkeyIndexMap setValue:hotkey forKey:[NSString stringWithFormat:@"%lu",(unsigned long)_nIndex]];
    
    ++ _nIndex;
    return bRslt;
}

-(void)unregisterWithHotkey:(SCHotkey *)hotkey{
    [self unregisterWithIdentifier:[hotkey identifier]];
}

-(void)unregisterWithIdentifier:(NSString *)indentifier{
    if (nil == indentifier) {
        return;
    }
    SCHotkey *hotkey = [_dictHotkeyIdentifierMap valueForKey:indentifier];
    if (nil == hotkey || NULL == [hotkey hotKeyRef]) {
        return;
    }
    UnregisterEventHotKey([hotkey hotKeyRef]);
    [_dictHotkeyIdentifierMap removeObjectForKey:indentifier];
    [_dictHotkeyIndexMap removeObjectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)[hotkey hotKeyID]]];
}

-(void)unregisterAllHotkeys{
    for (SCHotkey *hotkey in _dictHotkeyIdentifierMap.allValues) {
        UnregisterEventHotKey([hotkey hotKeyRef]);
    }
    [_dictHotkeyIdentifierMap removeAllObjects];
    [_dictHotkeyIndexMap removeAllObjects];
}

-(void)__hotkeyDown:(SCHotkey *)hotkey{
    [hotkey invoke];
}

OSStatus hotKeyHandler(EventHandlerCallRef nextHandler,EventRef theEvent, void *userData) {
    EventHotKeyID hotKeyID = { 0 };
    OSStatus error = GetEventParameter(theEvent, kEventParamDirectObject, typeEventHotKeyID, NULL, sizeof(hotKeyID), NULL, &hotKeyID);
    
    if (noErr != error) {
        return error;
    }
    UInt32 keyID = hotKeyID.id;
    SCHotkey *hotkey = [[SCHotkeyManager sharedManager]->_dictHotkeyIndexMap objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)keyID]];
    [[SCHotkeyManager sharedManager] __hotkeyDown:hotkey];
    
    return noErr;
}

@end
