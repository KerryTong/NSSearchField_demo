//
//  AppDelegate.m
//  NSSearch_Demo
//
//  Created by 仝兴伟 on 2018/10/29.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "AppDelegate.h"
#import "RPDContentViewController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (strong, nonatomic) IBOutlet NSSegmentedControl *preferredEdgeControl;
@property (strong, nonatomic) IBOutlet NSSegmentedControl *behaviorControl;

@property (strong, nonatomic, readonly) NSPopover *NSPopover;
@property (strong, nonatomic, readonly) RBLPopover *RBLPopover;

@property (strong, nonatomic) NSNumber *arrowWidth;
@property (strong, nonatomic) NSNumber *arrowHeight;

@property (strong, nonatomic) NSNumber *anchorPointX;
@property (strong, nonatomic) NSNumber *anchorPointY;

@end

@implementation AppDelegate

- (instancetype)init {
    self = [super init];
    if (self == nil) return nil;
    
    _NSPopover = [NSPopover new];
    self.NSPopover.contentViewController = [RPDContentViewController new];
    
    _RBLPopover = [[RBLPopover alloc] initWithContentViewController:[RPDContentViewController new]];
    self.RBLPopover.canBecomeKey = YES;
    
    return self;
}

#pragma mark - Actions


- (IBAction)showNSPopover:(id)sender {
    if (self.NSPopover.shown) {
        [self.NSPopover close];
    } else {
        NSView *button = sender;
        self.NSPopover.behavior = self.behavior;
        
        NSRectEdge edge = self.preferredEdge;
        if (button.isFlipped) {
            if (edge == NSMaxYEdge) {
                edge = NSMinYEdge;
            } else if (edge == NSMinYEdge) {
                edge = NSMaxYEdge;
            }
        }
        [self.NSPopover showRelativeToRect:button.bounds ofView:button preferredEdge:edge];
    }
}


- (IBAction)showRBLPopover:(id)sender {
    if (self.RBLPopover.shown) {
        [self.RBLPopover close];
    } else {
        NSView *button = sender;
        self.RBLPopover.behavior = self.behavior;
        [self.RBLPopover showRelativeToRect:button.bounds ofView:button preferredEdge:(CGRectEdge)self.preferredEdge];
    }
}


#pragma mark - Configurable Properties

- (NSPopoverBehavior)behavior {
    NSInteger segment = self.behaviorControl.selectedSegment;
    return [self.behaviorControl.cell tagForSegment:segment];
}

- (NSRectEdge)preferredEdge {
    NSInteger segment = self.preferredEdgeControl.selectedSegment;
    return (CGRectEdge)[self.preferredEdgeControl.cell tagForSegment:segment];
}

- (NSNumber *)arrowHeight {
    return @(self.RBLPopover.backgroundView.arrowSize.height);
}

- (void)setArrowHeight:(NSNumber *)arrowHeight {
    CGSize size = self.RBLPopover.backgroundView.arrowSize;
    size.height = arrowHeight.integerValue;
    self.RBLPopover.backgroundView.arrowSize = size;
}

- (NSNumber *)arrowWidth {
    return @(self.RBLPopover.backgroundView.arrowSize.width);
}

- (void)setArrowWidth:(NSNumber *)arrowWidth {
    CGSize size = self.RBLPopover.backgroundView.arrowSize;
    size.width = arrowWidth.integerValue;
    self.RBLPopover.backgroundView.arrowSize = size;
}

- (NSNumber *)anchorPointX {
    return @(self.RBLPopover.anchorPoint.x);
}

- (void)setAnchorPointX:(NSNumber *)anchorPointX {
    self.RBLPopover.anchorPoint = (CGPoint){ .x = anchorPointX.floatValue, .y = self.RBLPopover.anchorPoint.y };
}

- (NSNumber *)anchorPointY {
    return @(self.RBLPopover.anchorPoint.y);
}

- (void)setAnchorPointY:(NSNumber *)anchorPointY {
    self.RBLPopover.anchorPoint = (CGPoint){ .x = self.RBLPopover.anchorPoint.x, .y = anchorPointY.floatValue };
}


#pragma mark ------------------------

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    MySearchField *filed = [[MySearchField alloc]initWithFrame:CGRectMake(100, 320, 200, 30)];
    filed.backgroundColor = [NSColor yellowColor];
    filed.myDelegate = self;
    [self.window.contentView addSubview:filed];

    NSActionCell *cancelCell = [[filed cell]cancelButtonCell];
    cancelCell.target = self;
    cancelCell.action = @selector(cancellButtonClicked:);
    
    // 监听pop将要消失
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self
                   selector:@selector(textDidEndEditings:)
                       name:NSPopoverWillCloseNotification
                     object:nil];
}

#pragma mark -- 点击取消按钮
- (void)cancellButtonClicked:(id)sender {
    NSLog(@"点击取消按钮");
    MySearchField *searchField = self.window.contentView.subviews[2];
    searchField.stringValue = @"";
    [self.window makeFirstResponder:nil];
}

- (void)showPop:(id)sender {
    if (self.NSPopover.shown) {
        [self.NSPopover close];
    } else {
    NSEvent *event = sender;
    self.NSPopover.behavior = self.behavior;
    NSLog(@"%@", event.window.contentView.subviews[2]);
    MySearchField *searchField = event.window.contentView.subviews[2];
    //显示在button 上面
    [self.NSPopover showRelativeToRect:[searchField bounds] ofView:searchField preferredEdge:NSRectEdgeMinY];
    }
}

-(void)mouseDown:(NSEvent *)event {
    NSLog(@"弹出窗口");
    [self showPop:event];
}

-(void)textDidChange:(NSNotification *)notification  {
     NSTextView *textField = [notification object];
    if (textField.string.length <= 0) {
        [self.window makeFirstResponder:nil];
        return;
    }
    NSLog(@"%@", textField.string);
    NSLog(@"需要判断 是否为空，开始搜索了");
}

-(void)textDidEndEditing:(NSNotification *)notification {
//    NSLog(@"textDidEndEditing ===%@", notification);
    [self.window makeFirstResponder:nil];
}


- (void)textDidEndEditings:(NSNotification *)notification {
    // 取消第一反应
    NSLog(@"取消%@", self.window.contentView.subviews[2]);
//    MySearchField *searchField = self.window.contentView.subviews[2];
//    if (searchField.becomeFirstResponder) {
//        [searchField resignFirstResponder];
//        [self.window makeFirstResponder:nil];
//    }
    [self cancellButtonClicked:nil];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
