
//
//  SCKeyCombo.h
//  ShortcutsKit
//
//  Created by Jovi on 10/9/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Carbon/Carbon.h>

NS_ASSUME_NONNULL_BEGIN
@interface SCKeyCombo : NSObject <NSCoding>

@property (nonatomic, assign)               UInt32          keyCode;
@property (nonatomic, assign)               UInt32          keyModifiers;
@property (nonatomic, copy, readonly)       NSString        *stringForKeyCombo;

-(instancetype)initWithKeyCode:(UInt32)keyCode keyModifiers:(UInt32)modifiers;


//Convert keycode to string.  such as 'kVK_ANSI_F' to 'f', 'kVK_ANSI_F' + 'shiftKey' to 'F'
+(nullable NSString *)keyCode2String:(UInt32)keyCode keyModifiers:(UInt32)modifiers;

//Convert keyModifiers to string.  'shiftKey' to '⇧'
+(nullable NSString *)keyModifiers2String:(UInt32)modifiers;

@end
NS_ASSUME_NONNULL_END
