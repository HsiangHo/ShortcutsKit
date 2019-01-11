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
    NSImageView                 *_ivIcon;
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
    _ivIcon = [[NSImageView alloc] initWithFrame:NSMakeRect(5, 8, 24, 24)];
    [_ivIcon setImage:[NSImage imageNamed:@"NSStatusAvailable"]];
    [self addSubview:_ivIcon];
    
    _lbDescr = [[NSTextField alloc] initWithFrame:NSMakeRect(33, 7, 190, 25)];
    [_lbDescr setEditable:NO];
    [_lbDescr setBezeled:NO];
    [_lbDescr setSelectable:NO];
    [[_lbDescr cell] setLineBreakMode:NSLineBreakByTruncatingTail];
    [_lbDescr setBackgroundColor:[NSColor clearColor]];
    [_lbDescr setFont:[NSFont fontWithName:@"Helvetica Neue" size:15]];
    [_lbDescr setStringValue:@""];
    [self addSubview:_lbDescr];
    
    _keyComboView = [SCKeyComboView standardKeyComboView];
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
    [_keyComboView setNeedsDisplay:YES];
    [self __updateIcon];
}

-(void)__updateIcon{
    NSImage *icon = [_infoObject icon];
    if (nil == icon) {
        if(nil != [_keyComboView keyCombo]){
            icon = [NSImage imageNamed:@"NSStatusAvailable"];
        }else{
            icon = [NSImage imageNamed:@"NSStatusNone"];
        }
    }
    [_ivIcon setImage:icon];
}

#pragma mark - delegate
-(void)keyComboWillChange:(SCKeyComboView *)keyComboView{
}

-(void)keyComboDidChanged:(SCKeyComboView *)keyComboView{
    [self __updateIcon];
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
