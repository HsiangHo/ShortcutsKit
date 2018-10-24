//
//  SCKeyComboView.m
//  ShortcutsKit
//
//  Created by Jovi on 10/13/18.
//  Copyright © 2018 Jovi. All rights reserved.
//

#import "SCKeyComboView.h"
#import "SCKeyCombo.h"

@implementation SCKeyComboView{
    SCKeyCombo              *_keyCombo;
    NSColor                 *_backgroundColor;
    NSColor                 *_hoveredBackgroundColor;
    NSColor                 *_borderColor;
    NSColor                 *_hoveredBorderColor;
    NSColor                 *_onTintColor;
    NSColor                 *_tintColor;
    CGFloat                 _cornerRadius;
    NSButton                *_btnClear;
    NSTrackingArea          *_trackingArea;
    BOOL                    _isEditing;
    BOOL                    _isHovered;
    
    __weak id<SCKeyComboViewDelegate>      _delegate;
}

+(SCKeyComboView *)standardKeyComboView{
    return [[SCKeyComboView alloc] initWithFrame:NSMakeRect(0, 0, 150, 30)];
}

-(instancetype)init{
    if (self = [super init]) {
        [self __initializeSCKeyComboView];
    }
    return self;
}

-(instancetype)initWithFrame:(NSRect)frameRect{
    if (self = [super initWithFrame:frameRect]) {
        [self __initializeSCKeyComboView];
    }
    return self;
}

-(void)__initializeSCKeyComboView{
    _backgroundColor = [NSColor clearColor];
    _hoveredBackgroundColor = [NSColor whiteColor];
    _borderColor = [NSColor clearColor];
    _hoveredBorderColor = [NSColor lightGrayColor];
    _onTintColor = [NSColor colorWithCalibratedRed:0 green:126/255.0 blue:200/255.0 alpha:1.0];
    _tintColor = [NSColor grayColor];
    _cornerRadius = 15.f;
    _isEditing = NO;
    _isHovered = NO;
    _btnClear = [[NSButton alloc] initWithFrame: NSMakeRect(0, 0, 16, 16)];
    [_btnClear setBezelStyle:NSRegularSquareBezelStyle];
    [_btnClear setButtonType: NSButtonTypeMomentaryChange];
    [_btnClear setBordered:NO];
    [_btnClear setHidden:YES];
    [_btnClear setTitle:@""];
    [_btnClear setTarget:self];
    [_btnClear setAction:@selector(clearButton_click:)];
    [self addSubview:_btnClear];
    _delegate = nil;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [self drawBackground:dirtyRect];
    [self drawKeyCombo:dirtyRect];
    [self drawClearButton:dirtyRect];
}

- (void)drawBackground:(NSRect)dirtyRect {
    if (_isHovered) {
        [_hoveredBackgroundColor setFill];
        [_hoveredBorderColor setStroke];
    }else{
        [_backgroundColor setFill];
        [_borderColor setStroke];
    }
    [[NSBezierPath bezierPathWithRoundedRect:dirtyRect xRadius:_cornerRadius yRadius:_cornerRadius] fill];
    
    CGFloat borderWidth = 2.f;
    NSRect rct = NSMakeRect(borderWidth / 2, borderWidth / 2, NSWidth(dirtyRect) - borderWidth, NSHeight(dirtyRect) - borderWidth);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rct xRadius:_cornerRadius yRadius:_cornerRadius];
    [path setLineWidth:borderWidth];
    [path stroke];
}

- (void)drawKeyCombo:(NSRect)dirtyRect {
    if (nil == _keyCombo) {
        return;
    }
    NSString *keyCode = [SCKeyCombo keyCode2String:[_keyCombo keyCode] keyModifiers:0];
    NSMutableAttributedString *attributedModifier = [[NSMutableAttributedString alloc] initWithString:@""];
    [attributedModifier appendAttributedString:[[NSAttributedString alloc] initWithString:@"⇧" attributes:[self __attribuetesForKeyCombo:([_keyCombo keyModifiers] & shiftKey) != 0 ]]];
    [attributedModifier appendAttributedString:[[NSAttributedString alloc] initWithString:@"⌃" attributes:[self __attribuetesForKeyCombo:([_keyCombo keyModifiers] & controlKey) != 0 ]]];
    [attributedModifier appendAttributedString:[[NSAttributedString alloc] initWithString:@"⌥" attributes:[self __attribuetesForKeyCombo:([_keyCombo keyModifiers] & optionKey) != 0 ]]];
    [attributedModifier appendAttributedString:[[NSAttributedString alloc] initWithString:@"⌘" attributes:[self __attribuetesForKeyCombo:([_keyCombo keyModifiers] & cmdKey) != 0 ]]];
    
    [attributedModifier appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@",keyCode] attributes:[self __attribuetesForKeyCombo:YES]]];
     
    NSSize sizeModifier = [attributedModifier size];
    NSRect rct = self.bounds;
    rct.origin.x = (NSWidth(rct) - sizeModifier.width) / 2;
    rct.origin.y = (sizeModifier.height - NSHeight(rct)) / 2;
    [attributedModifier drawInRect:rct];
}

- (void)drawClearButton:(NSRect)dirtyRect {
    NSRect rct = [self bounds];
    NSUInteger offsetX = NSWidth(rct) - 16 - _cornerRadius * 0.8;
    NSUInteger offsetY = (NSHeight(rct) - 16) / 2;
    [_btnClear setFrame:NSMakeRect(offsetX, offsetY, 16, 16)];
    [_btnClear setImage:[self __clearButtonImage]];
}

#pragma mark - Override Methods

-(void)updateTrackingAreas{
    if(nil != _trackingArea) {
        [self removeTrackingArea:_trackingArea];
    }
    
    int opts = (NSTrackingMouseEnteredAndExited | NSTrackingActiveAlways | NSTrackingMouseMoved | NSTrackingActiveWhenFirstResponder);
    _trackingArea = [ [NSTrackingArea alloc] initWithRect:[self bounds]
                                                  options:opts
                                                    owner:self
                                                 userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

-(void)mouseEntered:(NSEvent *)event{
    if (nil == _keyCombo) {
        _isEditing = YES;
    }
    _isHovered = YES;
    [[_btnClear animator]setHidden:NO];
    [self setNeedsDisplay:YES];
    [self.window makeFirstResponder:self];
}

-(void)mouseExited:(NSEvent *)event{
    _isHovered = NO;
    _isEditing = NO;
    [[_btnClear animator]setHidden:YES];
    [self setNeedsDisplay:YES];
    [self.window makeFirstResponder:nil];
}

-(void)keyDown:(NSEvent *)event{
    if (_isEditing) {
        UInt32 modifiers = 0;
        if(0 != ([event modifierFlags] & NSCommandKeyMask)){
            modifiers += cmdKey;
        }
        if(0 != ([event modifierFlags] & NSAlternateKeyMask)){
            modifiers += optionKey;
        }
        if(0 != ([event modifierFlags] & NSControlKeyMask)){
            modifiers += controlKey;
        }
        if(0 != ([event modifierFlags] & NSShiftKeyMask)){
            modifiers += shiftKey;
        }
        if ([event keyCode] == [_keyCombo keyCode] && modifiers == [_keyCombo keyModifiers]) {
            return;
        }
        if ([_delegate respondsToSelector:@selector(keyComboWillChange:)]) {
            [_delegate keyComboWillChange:self];
        }
        if (nil == _keyCombo) {
            _keyCombo = [[SCKeyCombo alloc] initWithKeyCode:[event keyCode] keyModifiers:modifiers];
        }
        [_keyCombo setKeyCode:[event keyCode]];
        [_keyCombo setKeyModifiers:modifiers];
        if ([_delegate respondsToSelector:@selector(keyComboDidChanged:)]) {
            [_delegate keyComboDidChanged:self];
        }
        [self setNeedsDisplay:YES];
    }
}

#pragma MARK - Actions

-(IBAction)clearButton_click:(id)sender{
    if ([_delegate respondsToSelector:@selector(keyComboWillChange:)]) {
        [_delegate keyComboWillChange:self];
    }
    _keyCombo = nil;
    _isEditing = YES;
    [self setNeedsDisplay:YES];
    if ([_delegate respondsToSelector:@selector(keyComboDidChanged:)]) {
        [_delegate keyComboDidChanged:self];
    }
}

#pragma MARK - Private methods

-(NSImage *)__clearButtonImage{
    static NSImage *image = nil;
    if (nil != image) {
        return image;
    }
    image = [[NSImage alloc] initWithSize:NSMakeSize(16, 16)];
    [image lockFocus];
    
    NSBezierPath * ovalPath = [NSBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 16, 16)];
    [[NSColor colorWithCalibratedRed:0.529 green: 0.529 blue:0.529 alpha:1] setFill];
    [ovalPath fill];
    
    [[NSColor colorWithCalibratedRed:0.871 green: 0.871 blue:0.871 alpha:1] setStroke];
    NSBezierPath *pathPath = [NSBezierPath bezierPath];
    [pathPath moveToPoint:CGPointMake(5, 11)];
    [pathPath curveToPoint:CGPointMake(11, 5) controlPoint1:CGPointMake(7, 9) controlPoint2:CGPointMake(9, 7)];
    [pathPath setLineWidth:2.f];
    [pathPath stroke];
    NSBezierPath *path2Path = [NSBezierPath bezierPath];
    [path2Path moveToPoint:CGPointMake(11, 11)];
    [path2Path curveToPoint:CGPointMake(5, 5) controlPoint1:CGPointMake(9, 9) controlPoint2:CGPointMake(7, 7)];
    [path2Path setLineWidth:2.f];
    [path2Path stroke];
    
    [image unlockFocus];
    return image;
}

-(NSDictionary *)__attribuetesForKeyCombo:(BOOL)bFlag{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSLeftTextAlignment;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    NSMutableDictionary * attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    if (bFlag) {
        [attributes setObject:_onTintColor forKey:NSForegroundColorAttributeName];
    }else{
        [attributes setObject:_tintColor forKey:NSForegroundColorAttributeName];
    }
    [attributes setObject:[NSFont fontWithName:@"Helvetica" size:NSHeight(self.bounds)/1.7] forKey:NSFontAttributeName];
    return attributes;
}

@end
