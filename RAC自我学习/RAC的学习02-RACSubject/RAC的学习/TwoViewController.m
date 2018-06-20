//
//  TwoViewController.m
//  RAC的学习
//
//  Created by xyj on 2017/12/26.
//  Copyright © 2017年 xyj. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController ()

@end

@implementation TwoViewController


- (IBAction)twoAction:(id)sender {
    // 通知第一个控制器，告诉它，按钮被点了
    // 通知代理
    // 判断代理信号是否有值
    if (self.delegateSignal) {
        // 有值，才需要通知
        [self.delegateSignal sendNext:nil];
    }
}


@end
