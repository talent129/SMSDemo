//
//  CountButton.h
//  SMSDemo
//
//  Created by luckyCoderCai on 2019/1/22.
//  Copyright © 2019年 cai. All rights reserved.
//

#import <UIKit/UIKit.h>

///倒计时
@interface CountButton : UIButton

+ (CountButton *)countdownButtonWith:(SEL)method withTarget:(id)target;
- (void)startTime;

@end
