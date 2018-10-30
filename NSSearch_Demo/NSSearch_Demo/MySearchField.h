//
//  MySearchField.h
//  NSSearch_Demo
//
//  Created by 仝兴伟 on 2018/10/29.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol MySearchFieldDelegate <NSObject>

@optional
- (void)mouseDown:(NSEvent *)event;
-(void)textDidChange:(NSNotification *)notification;
-(void)textDidEndEditing:(NSNotification *)notification;
@end

@interface MySearchField : NSSearchField

@property (nonatomic, weak) id<MySearchFieldDelegate> myDelegate;
@end
