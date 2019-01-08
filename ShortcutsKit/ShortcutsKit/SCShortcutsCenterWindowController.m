//
//  SCShortcutsCenterWindowController.m
//  ShortcutsKit
//
//  Created by Jovi on 1/7/19.
//  Copyright © 2019 Jovi. All rights reserved.
//

#import "SCShortcutsCenterWindowController.h"

@interface SCShortcutsCenterWindowController ()

@end

@implementation SCShortcutsCenterWindowController{
    NSTextField         *_lbTitle;
    NSScrollView        *_scrollView;
    NSTableView         *_tvShortcuts;
    NSButton            *_btnAddShortcut;
    NSButton            *_btnRemoveShortcut;
}

-(instancetype)init{
    if (self = [super init]) {
        [self __initializeSCShortcutsCenterWindowController];
    }
    return self;
}

-(void)__initializeSCShortcutsCenterWindowController{
    NSRect rctWindow = NSMakeRect(0, 0, 420, 620);
    NSWindow *window = [[NSWindow alloc] initWithContentRect:rctWindow styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskFullSizeContentView | NSClosableWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self setWindow:window];
    [window setLevel:NSFloatingWindowLevel];
    [window setTitlebarAppearsTransparent:YES];
    [window setTitleVisibility:NSWindowTitleHidden];
    [window setMovableByWindowBackground:YES];
    [window center];
    [window setAnimationBehavior:NSWindowAnimationBehaviorAlertPanel];
    [[window standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
    [[window standardWindowButton:NSWindowZoomButton] setHidden:YES];
    
    _lbTitle = [[NSTextField alloc] initWithFrame:NSMakeRect(25, NSHeight(rctWindow) - 70, 300, 36)];
    [_lbTitle setEditable:NO];
    [_lbTitle setBezeled:NO];
    [_lbTitle setSelectable:NO];
    [_lbTitle setBackgroundColor:[NSColor clearColor]];
    [_lbTitle setFont:[NSFont fontWithName:@"Helvetica Neue Light" size:35]];
    [_lbTitle setStringValue:@"Shortcuts Center"];
    [window.contentView addSubview:_lbTitle];
    
    _scrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(NSMinX(_lbTitle.frame), 55, NSWidth(rctWindow) - NSMinX(_lbTitle.frame) * 2, NSMinY(_lbTitle.frame) - 70)];
    [_scrollView setWantsLayer:YES];
    [_scrollView.layer setCornerRadius:5.f];
    [window.contentView addSubview:_scrollView];
    
    _tvShortcuts = [[NSTableView alloc] initWithFrame:_scrollView.bounds];
    [_tvShortcuts setGridStyleMask: NSTableViewSolidHorizontalGridLineMask];
    [_tvShortcuts setHeaderView:nil];
    [_scrollView setDocumentView:_tvShortcuts];
    
    _btnAddShortcut = [[NSButton alloc] initWithFrame:NSMakeRect(NSMinX(_scrollView.frame) - 5, 20, 32, 32)];
    [_btnAddShortcut setBezelStyle: NSBezelStyleRegularSquare];
    [_btnAddShortcut setImage:[NSImage imageNamed:@"NSAddTemplate"]];
    [_btnAddShortcut setAction:@selector(addButton_click:)];
    [_btnAddShortcut setTarget:self];
    [window.contentView addSubview:_btnAddShortcut];
    
    _btnRemoveShortcut = [[NSButton alloc] initWithFrame:NSMakeRect(NSMaxX(_btnAddShortcut.frame), NSMinY(_btnAddShortcut.frame), 32, 32)];
    [_btnRemoveShortcut setBezelStyle: NSBezelStyleRegularSquare];
    [_btnRemoveShortcut setImage:[NSImage imageNamed:@"NSRemoveTemplate"]];
    [_btnRemoveShortcut setAction:@selector(removeButton_click:)];
    [_btnRemoveShortcut setTarget:self];
    [window.contentView addSubview:_btnRemoveShortcut];
}

-(IBAction)addButton_click:(id)sender{
    
}

-(IBAction)removeButton_click:(id)sender{
    
}

@end
