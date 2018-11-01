//
//  MyTextFieldCell.m
//  NSSearch_Demo
//
//  Created by 仝兴伟 on 2018/11/1.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "MyTextFieldCell.h"
@implementation MyTextFieldCell


- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSGradient * gradient = [[NSGradient alloc] initWithStartingColor:[NSColor blackColor] endingColor:[NSColor whiteColor]];
    [gradient drawInBezierPath:[NSBezierPath bezierPathWithRect:cellFrame] angle:90];
    NSBezierPath * bezierPath = [NSBezierPath bezierPathWithRect:NSInsetRect(cellFrame, 1, 1)];
    [[NSColor controlColor] setFill];
    [bezierPath fill];
    return [super drawWithFrame:cellFrame inView:controlView];
}

@end
