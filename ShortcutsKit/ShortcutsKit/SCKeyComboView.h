//
//  SCKeyComboView.h
//  ShortcutsKit
//
//  Created by Jovi on 10/13/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SCKeyCombo;
@interface SCKeyComboView : NSView

@property (nonatomic, strong, readwrite)       SCKeyCombo              *keyCombo;

+(SCKeyComboView *)standardKeyComboView;

@end
