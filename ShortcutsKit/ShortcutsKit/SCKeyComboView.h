//
//  SCKeyComboView.h
//  ShortcutsKit
//
//  Created by Jovi on 10/13/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SCKeyComboView;
@protocol  SCKeyComboViewDelegate <NSObject>
@optional
-(void)keyComboWillChange:(SCKeyComboView *)keyComboView;
-(void)keyComboDidChanged:(SCKeyComboView *)keyComboView;

@end

@class SCKeyCombo;
@interface SCKeyComboView : NSView

@property (nonatomic, weak, readwrite)          id<SCKeyComboViewDelegate>      delegate;
@property (nonatomic, strong, readwrite)        SCKeyCombo                      *keyCombo;
@property (nonatomic, strong, readwrite)        NSColor                         *backgroundColor;
@property (nonatomic, strong, readwrite)        NSColor                         *hoveredBackgroundColor;
@property (nonatomic, strong, readwrite)        NSColor                         *borderColor;
@property (nonatomic, strong, readwrite)        NSColor                         *hoveredBorderColor;
@property (nonatomic, strong, readwrite)        NSColor                         *onTintColor;
@property (nonatomic, strong, readwrite)        NSColor                         *tintColor;
@property (nonatomic, assign, readwrite)        CGFloat                         cornerRadius;
@property (nonatomic, strong, readonly)         NSButton                        *btnClear;

+(SCKeyComboView *)standardKeyComboView;

@end
