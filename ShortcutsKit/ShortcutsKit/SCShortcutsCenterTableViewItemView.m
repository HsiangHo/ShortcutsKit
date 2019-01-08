//
//  SCShortcutsCenterTableViewItemView.m
//  ShortcutsKit
//
//  Created by Jovi on 1/8/19.
//  Copyright © 2019 Jovi. All rights reserved.
//

#import "SCShortcutsCenterTableViewItemView.h"
#import "SCKeyComboView.h"
#import "SCShortcutInfoObject.h"
#import "SCHotkey.h"

@implementation SCShortcutsCenterTableViewItemView{
    NSTextField                 *_lbDescr;
    SCKeyComboView              *_keyComboView;
    SCShortcutInfoObject        *_infoObject;
}

-(instancetype)init{
    if (self = [super init]) {
        [self __initializeSCShortcutsCenterTableViewItemView];
    }
    return self;
}

-(void)setShortcutInfoObj:(SCShortcutInfoObject *)obj{
    _infoObject = obj;
    [self __update];
}

-(void)__initializeSCShortcutsCenterTableViewItemView{
    _lbDescr = [[NSTextField alloc] initWithFrame:NSMakeRect(8, 7, 200, 25)];
    [_lbDescr setEditable:NO];
    [_lbDescr setBezeled:NO];
    [_lbDescr setSelectable:NO];
    [_lbDescr setBackgroundColor:[NSColor clearColor]];
    [_lbDescr setFont:[NSFont fontWithName:@"Helvetica Neue Light" size:13]];
    [_lbDescr setStringValue:@""];
    [self addSubview:_lbDescr];
    
    _keyComboView = [SCKeyComboView standardKeyComboView];
    [_keyComboView setOnTintColor:[NSColor redColor]];
    [self addSubview:_keyComboView];
}

-(void)__update{
    [_lbDescr setStringValue:[_infoObject descr]];
    [_keyComboView setKeyCombo:[[_infoObject hotkey] keyCombo]];
    NSRect rctDescr = _keyComboView.frame;
    rctDescr.origin.x = NSWidth(self.frame) - NSWidth(rctDescr) - 20;
    rctDescr.origin.y = 5;
    [_keyComboView setFrame:rctDescr];
}

@end
