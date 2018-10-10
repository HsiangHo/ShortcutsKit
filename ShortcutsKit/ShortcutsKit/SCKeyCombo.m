//
//  SCKeyCombo.m
//  ShortcutsKit
//
//  Created by Jovi on 10/9/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

#import "SCKeyCombo.h"

#define NSStringFromKeyCode(keyCode)    [NSString stringWithFormat:@"%C", keyCode]
#define kKeyCode                        @"keyCode"
#define kKeyModifiers                   @"keyModifiers"

@implementation SCKeyCombo{
    UInt32          _keyCode;
    UInt32          _keyModifiers;
}

-(instancetype)initWithKeyCode:(UInt32)keyCode keyModifiers:(UInt32)modifiers{
    if (self = [super init]) {
        _keyCode = keyCode;
        _keyModifiers = modifiers;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]){
        _keyCode = (UInt32)[[aDecoder decodeObjectForKey:kKeyCode] integerValue];
        _keyModifiers = (UInt32)[[aDecoder decodeObjectForKey:kKeyModifiers] integerValue];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:@(_keyCode) forKey:kKeyCode];
    [aCoder encodeObject:@(_keyModifiers) forKey:kKeyModifiers];
}

-(NSString *)stringForKeyCombo{
    NSString *rslt = @"";
    NSString *key = [SCKeyCombo keyCode2String:_keyCode keyModifiers:0];
    NSString *modifiers = [SCKeyCombo keyModifiers2String:_keyModifiers];
    if (nil != modifiers) {
        rslt = [rslt stringByAppendingString:modifiers];
    }
    if (nil != key) {
        rslt = [rslt stringByAppendingString:key];
    }
    return rslt;
}

+(nullable NSString *)keyCode2String:(UInt32)keyCode keyModifiers:(UInt32)modifiers{
    NSString *rslt = [SCKeyCombo specialkeyCode2String:keyCode];
    if (nil != rslt) {
        return rslt;
    }
    TISInputSourceRef currentKeyboard = TISCopyCurrentASCIICapableKeyboardLayoutInputSource();
    CFDataRef layoutData = TISGetInputSourceProperty(currentKeyboard, kTISPropertyUnicodeKeyLayoutData);
    if (NULL != layoutData) {
        const UCKeyboardLayout *keyboardLayout = (const UCKeyboardLayout *)CFDataGetBytePtr(layoutData);
        UInt32 deadKeyState = 0;
        UniChar chars[4] = { 0 };
        UniCharCount realLength;
        UInt32 modifierKeyState = (modifiers >> 8) & 0xFF;
        
        OSStatus error = UCKeyTranslate(keyboardLayout,
                                        keyCode,
                                        kUCKeyActionDown,
                                        modifierKeyState,
                                        LMGetKbdType(),
                                        kUCKeyTranslateNoDeadKeysBit,
                                        &deadKeyState,
                                        sizeof(chars) / sizeof(chars[0]),
                                        &realLength,
                                        chars);
        
        CFRelease(currentKeyboard);
        if (noErr == error) {
            rslt = [[NSString alloc] initWithCharacters:chars length:realLength];
        }
    }
    return rslt;
}

+(nullable NSString *)keyModifiers2String:(UInt32)modifiers{
    NSString *rslt = @"";
    if (modifiers & shiftKey) {
        rslt = [rslt stringByAppendingString:@"⇧"];
    }
    if (modifiers & controlKey) {
        rslt = [rslt stringByAppendingString:@"⌃"];
    }
    if (modifiers & optionKey) {
        rslt = [rslt stringByAppendingString:@"⌥"];
    }
    if (modifiers & cmdKey) {
        rslt = [rslt stringByAppendingString:@"⌘"];
    }
    return [rslt isEqualToString:@""] ? nil : rslt;
}

+(NSString *)specialkeyCode2String:(UInt32)keyCode{
    static NSDictionary *dictSpecialKeyCode2String = nil;
    if (nil == dictSpecialKeyCode2String) {
        dictSpecialKeyCode2String = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"F1",@(kVK_F1),
                                     @"F2",@(kVK_F2),
                                     @"F3",@(kVK_F3),
                                     @"F4",@(kVK_F4),
                                     @"F5",@(kVK_F5),
                                     @"F6",@(kVK_F6),
                                     @"F7",@(kVK_F7),
                                     @"F8",@(kVK_F8),
                                     @"F9",@(kVK_F9),
                                     @"F10",@(kVK_F10),
                                     @"F11",@(kVK_F11),
                                     @"F12",@(kVK_F12),
                                     @"F13",@(kVK_F13),
                                     @"F14",@(kVK_F14),
                                     @"F15",@(kVK_F15),
                                     @"F16",@(kVK_F16),
                                     @"F17",@(kVK_F17),
                                     @"F18",@(kVK_F18),
                                     @"F19",@(kVK_F19),
                                     @"F20",@(kVK_F20),
                                     @"Space",@(kVK_Space),
                                     NSStringFromKeyCode(0x232B),@(kVK_Delete),
                                     NSStringFromKeyCode(0x2326),@(kVK_ForwardDelete),
                                     NSStringFromKeyCode(0x2327),@(kVK_ANSI_Keypad0),
                                     NSStringFromKeyCode(0x2190),@(kVK_LeftArrow),
                                     NSStringFromKeyCode(0x2192),@(kVK_RightArrow),
                                     NSStringFromKeyCode(0x2191),@(kVK_UpArrow),
                                     NSStringFromKeyCode(0x2193),@(kVK_DownArrow),
                                     NSStringFromKeyCode(0x2198),@(kVK_End),
                                     NSStringFromKeyCode(0x2196),@(kVK_Home),
                                     NSStringFromKeyCode(0x238B),@(kVK_Escape),
                                     NSStringFromKeyCode(0x21DF),@(kVK_PageDown),
                                     NSStringFromKeyCode(0x21DE),@(kVK_PageUp),
                                     NSStringFromKeyCode(0x21A9),@(kVK_Return),
                                     NSStringFromKeyCode(0x2305),@(kVK_ANSI_KeypadEnter),
                                     NSStringFromKeyCode(0x21E5),@(kVK_Tab),
                                     @"?⃝",@(kVK_Help),
                                     nil];
    }
    return [dictSpecialKeyCode2String objectForKey:@(keyCode)];
}

@end
