//
//  SCShortcutsCenterWindowController.m
//  ShortcutsKit
//
//  Created by Jovi on 1/7/19.
//  Copyright © 2019 Jovi. All rights reserved.
//

#import "SCShortcutsCenterWindowController.h"
#import "SCHotkey.h"
#import "SCShortcutInfoObject.h"
#import "SCShortcutsCenterTableViewItemView.h"

@interface SCShortcutsCenterWindowController ()

@end

@implementation SCShortcutsCenterWindowController{
    NSTextField                                                 *_lbTitle;
    NSTextField                                                 *_lbSubtitle;
    NSScrollView                                                *_scrollView;
    NSTableView                                                 *_tvShortcuts;
    NSButton                                                    *_btnAddShortcut;
    NSButton                                                    *_btnRemoveShortcut;
    NSMutableDictionary<NSString *, SCShortcutInfoObject *>     *_dictHotKeyMap;
    __weak id<SCShortcutsCenterWindowControllerDelegate>        _delegate;
}

-(instancetype)init{
    if (self = [super init]) {
        [self __initializeSCShortcutsCenterWindowController];
    }
    return self;
}

-(void)addHotkey:(nonnull SCHotkey *)hotkey withDescription:(nonnull NSString *)descr{
    if (nil == [hotkey identifier]) {
        return;
    }
    [hotkey addObserver:self forKeyPath:@"keyCombo" options:NSKeyValueObservingOptionNew context:nil];
    SCShortcutInfoObject *infoObj = [[SCShortcutInfoObject alloc] init];
    [infoObj setDescr:descr];
    [infoObj setHotkey:hotkey];
    [_dictHotKeyMap setValue:infoObj forKey:[hotkey identifier]];
    [hotkey register];
}

-(void)removeHotkey:(nonnull SCHotkey *)hotkey{
    if (nil == [hotkey identifier]) {
        return;
    }
    [hotkey unregister];
    [hotkey removeObserver:self forKeyPath:@"keyCombo" context:nil];
    [_dictHotKeyMap setValue:nil forKey:[hotkey identifier]];
}

-(void)setDelegate:(id<SCShortcutsCenterWindowControllerDelegate>)delegate{
    _delegate = delegate;
    [self updateUI];
}

-(void)updateUI{
    NSString *title = @"Shortcuts Center";
    if ([_delegate respondsToSelector:@selector(shortcutsCenterWindowTitle)]) {
        title = [_delegate shortcutsCenterWindowTitle];
    }
    [_lbTitle setStringValue:title];
    NSString *subtitle = @"Customize your own shortcuts:";
    if ([_delegate respondsToSelector:@selector(shortcutsCenterWindowSubtitle)]) {
        subtitle = [_delegate shortcutsCenterWindowSubtitle];
    }
    [_lbSubtitle setStringValue:subtitle];
    [_tvShortcuts reloadData];
}

-(void)showWindow:(id)sender{
    [super showWindow:sender];
    [self updateUI];
}

#pragma mark - private methods
-(void)__initializeSCShortcutsCenterWindowController{
    _dictHotKeyMap = [[NSMutableDictionary alloc] init];
    _delegate = nil;
    NSRect rctWindow = NSMakeRect(0, 0, 420, 620);
    NSWindow *window = [[NSWindow alloc] initWithContentRect:rctWindow styleMask:NSWindowStyleMaskTitled | NSWindowStyleMaskFullSizeContentView | NSClosableWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self setWindow:window];
    [window setTitlebarAppearsTransparent:YES];
    [window setTitleVisibility:NSWindowTitleHidden];
    [window setMovableByWindowBackground:YES];
    [window center];
    [window setAnimationBehavior:NSWindowAnimationBehaviorAlertPanel];
    [[window standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
    [[window standardWindowButton:NSWindowZoomButton] setHidden:YES];
    
    _lbTitle = [[NSTextField alloc] initWithFrame:NSMakeRect(25, NSHeight(rctWindow) - 70, 300, 38)];
    [_lbTitle setEditable:NO];
    [_lbTitle setBezeled:NO];
    [_lbTitle setSelectable:NO];
    [_lbTitle setBackgroundColor:[NSColor clearColor]];
    [_lbTitle setFont:[NSFont fontWithName:@"Helvetica Neue Light" size:35]];
    [_lbTitle setStringValue:@""];
    [window.contentView addSubview:_lbTitle];
    
    _lbSubtitle = [[NSTextField alloc] initWithFrame:NSMakeRect(25, NSMinY(_lbTitle.frame) - 65, 300, 36)];
    [_lbSubtitle setEditable:NO];
    [_lbSubtitle setBezeled:NO];
    [_lbSubtitle setSelectable:NO];
    [_lbSubtitle setBackgroundColor:[NSColor clearColor]];
    [_lbSubtitle setFont:[NSFont fontWithName:@"Helvetica Neue Light" size:15]];
    [_lbSubtitle setStringValue:@""];
    [window.contentView addSubview:_lbSubtitle];
    
    _scrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(NSMinX(_lbTitle.frame), 55, NSWidth(rctWindow) - NSMinX(_lbTitle.frame) * 2, NSMinY(_lbTitle.frame) - 110)];
    [_scrollView setWantsLayer:YES];
    [_scrollView.layer setCornerRadius:5.f];
    [window.contentView addSubview:_scrollView];
    
    _tvShortcuts = [[NSTableView alloc] initWithFrame:_scrollView.bounds];
    NSTableColumn *column1 = [[NSTableColumn alloc] initWithIdentifier:@"Column1"];
    [column1 setWidth:NSWidth(_tvShortcuts.frame)];
    [_tvShortcuts addTableColumn:column1];
    [_tvShortcuts setUsesAlternatingRowBackgroundColors:YES];
    [_tvShortcuts setHeaderView:nil];
    [_tvShortcuts setDataSource:(id<NSTableViewDataSource> _Nullable)self];
    [_tvShortcuts setDelegate:(id<NSTableViewDelegate> _Nullable)self];
    [_scrollView setDocumentView:_tvShortcuts];
    
    _btnAddShortcut = [[NSButton alloc] initWithFrame:NSMakeRect(NSMinX(_scrollView.frame) - 3, 30, 24, 24)];
    [_btnAddShortcut setBezelStyle: NSBezelStyleRegularSquare];
    [_btnAddShortcut setImage:[NSImage imageNamed:@"NSAddTemplate"]];
    [_btnAddShortcut setAction:@selector(addButton_click:)];
    [_btnAddShortcut setTarget:self];
    [window.contentView addSubview:_btnAddShortcut];
    
    _btnRemoveShortcut = [[NSButton alloc] initWithFrame:NSMakeRect(NSMaxX(_btnAddShortcut.frame), NSMinY(_btnAddShortcut.frame), 24, 24)];
    [_btnRemoveShortcut setBezelStyle: NSBezelStyleRegularSquare];
    [_btnRemoveShortcut setImage:[NSImage imageNamed:@"NSRemoveTemplate"]];
    [_btnRemoveShortcut setAction:@selector(removeButton_click:)];
    [_btnRemoveShortcut setTarget:self];
    [window.contentView addSubview:_btnRemoveShortcut];
    
    [self updateUI];
}

-(IBAction)addButton_click:(id)sender{
    if ([_delegate respondsToSelector:@selector(addButton_click:withShortcutsCenterWindowController:)]) {
        [_delegate addButton_click:nil withShortcutsCenterWindowController:self];
    }
}

-(IBAction)removeButton_click:(id)sender{
    if ([_delegate respondsToSelector:@selector(removeButton_click:withShortcutsCenterWindowController:)]) {
        NSArray *array = [_dictHotKeyMap allValues];
        NSInteger nSelectedRow = [_tvShortcuts selectedRow];
        SCShortcutInfoObject *obj = nil;
        if (nSelectedRow >= 0 && nSelectedRow < [array count]) {
            obj = [array objectAtIndex:nSelectedRow];
        }
        [_delegate removeButton_click:[obj hotkey] withShortcutsCenterWindowController:self];
    }
}

#pragma mark - delegate
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row{
    return 40;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row{
    return YES;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    NSInteger nRows = 0;
    NSArray *array = [_dictHotKeyMap allValues];
    if (nil != array) {
        nRows = [array count];
    }
    return nRows;
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row{
    NSArray *array = [_dictHotKeyMap allValues];
    SCShortcutInfoObject *infoObj = [array objectAtIndex:row];
    SCShortcutsCenterTableViewItemView *view = [tableView makeViewWithIdentifier:@"itemView" owner:self];
    if (nil == view) {
        view = [[SCShortcutsCenterTableViewItemView alloc] init];
        [view setIdentifier:@"itemView"];
    }
    NSRect rctView = view.frame;
    rctView.size.width = NSWidth(tableView.frame);
    [view setFrame:rctView];
    [view setShortcutInfoObj:infoObj];
    return view;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"keyCombo"]) {
        if ([_delegate respondsToSelector:@selector(shortcutsKeyComboDidChanged:)]) {
            [_delegate shortcutsKeyComboDidChanged:object];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
