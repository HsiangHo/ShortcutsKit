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
    _lbDescr = [[NSTextField alloc] initWithFrame:NSMakeRect(8, 5, 200, 25)];
    [_lbDescr setEditable:NO];
    [_lbDescr setBezeled:NO];
    [_lbDescr setSelectable:NO];
    [[_lbDescr cell] setLineBreakMode:NSLineBreakByTruncatingTail];
    [_lbDescr setBackgroundColor:[NSColor clearColor]];
    [_lbDescr setFont:[NSFont fontWithName:@"Helvetica Neue" size:15]];
    [_lbDescr setStringValue:@""];
    [self addSubview:_lbDescr];
    
    _keyComboView = [SCKeyComboView standardKeyComboView];
    [_keyComboView setOnTintColor:[NSColor redColor]];
    [_keyComboView setDelegate:(id<SCKeyComboViewDelegate>)self];
    [self addSubview:_keyComboView];
}

-(void)__update{
    [_lbDescr setStringValue:[_infoObject descr]];
    [_lbDescr setToolTip:[_infoObject descr]];
    [_keyComboView setKeyCombo:[[_infoObject hotkey] keyCombo]];
    NSRect rctDescr = _keyComboView.frame;
    rctDescr.origin.x = NSWidth(self.frame) - NSWidth(rctDescr) - 10;
    rctDescr.origin.y = 5;
    [_keyComboView setFrame:rctDescr];
}

#pragma mark - delegate
-(void)keyComboWillChange:(SCKeyComboView *)keyComboView{
}

-(void)keyComboDidChanged:(SCKeyComboView *)keyComboView{
    if (nil == [keyComboView keyCombo]){
        //clear hotkey
        [[_infoObject hotkey] unregister];
        [[_infoObject hotkey] updateKeyCombo:nil];
        return;
    }
    [[_infoObject hotkey] updateKeyCombo:[keyComboView keyCombo]];
    [keyComboView setKeyCombo:[[_infoObject hotkey] keyCombo]];
    [[_infoObject hotkey] register];
}

@end
