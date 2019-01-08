//
//  SCShortcutsCenterTableViewItemView.h
//  ShortcutsKit
//
//  Created by Jovi on 1/8/19.
//  Copyright © 2019 Jovi. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@class SCShortcutInfoObject;
@interface SCShortcutsCenterTableViewItemView : NSView

-(void)setShortcutInfoObj:(SCShortcutInfoObject *)obj;

@end

NS_ASSUME_NONNULL_END
