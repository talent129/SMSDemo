//
//  CountButton.m
//  SMSDemo
//
//  Created by luckyCoderCai on 2019/1/22.
//  Copyright © 2019年 cai. All rights reserved.
//

#import "CountButton.h"

@implementation CountButton

+ (CountButton *)countdownButtonWith:(SEL)method withTarget:(id)target
{
    CountButton *button = [CountButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:method forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)startTime
{
    __block int timeout = 59; //倒计时时间
    __weak typeof(self) weakSelfBtn = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0) { //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [weakSelfBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [weakSelfBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                weakSelfBtn.userInteractionEnabled = YES;
            });
        } else{
            
            int seconds = timeout % 60;
            
            NSString *strTime = [NSString stringWithFormat:@"%.2ds后可重新发送", seconds];;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置界面的按钮显示 根据自己需求设置
                [weakSelfBtn setTitle:strTime forState:UIControlStateNormal];
                [weakSelfBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                weakSelfBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
