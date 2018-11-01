//
//  MySearchField.m
//  NSSearch_Demo
//
//  Created by 仝兴伟 on 2018/10/29.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "MySearchField.h"
#import "MySearchFieldCell.h"
@interface MySearchField()
@property (nonatomic, assign)BOOL isEdi;
@end
@implementation MySearchField

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    self.isEdi = YES;
}

// 自定义 FieldCell
+ (void)setCellClass:(Class)factoryId
{
    [super setCellClass:[MySearchFieldCell class]];
}

+ (Class)cellClass
{
    return [MySearchFieldCell class];
}


/**
 用户点击了搜索框
 */
- (void)mouseDown:(NSEvent *)event {
    [super mouseDown:event];
//    NSLog(@"用户点击了搜索框");
    if (self.isEdi) {
        [_myDelegate mouseDown:event];
    }
}


/**
 搜索框文本变化
 */
-(void)textDidChange:(NSNotification *)notification {
    [super textDidChange:notification];
    self.isEdi = YES;
    [_myDelegate textDidChange:notification];
}


/**
 搜索框点击clear button
 */
-(void)textDidEndEditing:(NSNotification *)notification {
    [super textDidEndEditing:notification];
    self.isEdi = NO;
    [_myDelegate textDidEndEditing:notification];
}


@end
