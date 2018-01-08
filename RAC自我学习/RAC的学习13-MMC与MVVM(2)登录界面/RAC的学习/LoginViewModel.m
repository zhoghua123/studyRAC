//
//  LoginViewModel.m
//  RAC的学习
//
//  Created by xyj on 2018/1/8.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel
-(instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}
-(void)setup{
    //1.处理登录点击按钮的信号()
    //RACObserve(self, account):只要self的account属性已改动,就会产生信号
    _loginEnableSignal = [RACSignal combineLatest:@[RACObserve(self, account),RACObserve(self, pwd)] reduce:^id _Nullable(NSString *account ,NSString *pwd){
        
        return @(account.length && pwd.length);
    }];
    //2. 处理登录点击命令
    _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        //block: 执行命令就回调用
        //block作用: 事件处理(发送网络请求)
        //发送登录的网络请求
        NSLog(@"发送网络请求返回的数据");
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            //将数据发送出去
            [subscriber sendNext:@"登录的网络请求数据"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    //3. 处理登录请求返回的结果
    [_loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    //4. 处理登录的执行过程
    //skip1的原因是,程序已启动就回调用一次
    [[_loginCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue] == YES) {
            //正在执行
            NSLog(@"正在执行");
            //弹框提示正在登录
        }else{
            //执行完成,隐藏弹框
            NSLog(@"执行完成");
        }
    }];
    
}
@end
