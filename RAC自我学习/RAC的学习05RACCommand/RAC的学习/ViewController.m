//
//  ViewController.m
//  RAC的学习
//
//  Created by xyj on 2017/12/25.
//  Copyright © 2017年 xyj. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface ViewController ()

@end

@implementation ViewController
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    /*
     1. 如何拿到执行命令中产生的数据: 订阅命令内部的信号
     */
    //1. 创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        //input:执行命令传入的参数
        //signalBlock调用时刻:执行命令的时候调用
        NSLog(@"%@",input);
        // 2.创建信号,用来传递数据
        //创建空信号
//        return [RACSignal empty];
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            //发送网络请求
            NSLog(@"AFN网络请求");
            //网络请求完毕,将数据发出
            [subscriber sendNext:@"网络请求的到的数据"];
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            return nil;
        }];
    }];
     //方法1:直接订阅执行命令返回的信号(先执行命令,在订阅信号)
    //3.执行命令
//    RACSignal *signal = [command execute:@1];
    //4. 订阅信号
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"===%@",x);
//    }];
    //方法2:先订阅信号,在执行命令
    //3. 订阅RACCommand中的信号
    //3.1 基本用法:
    //executionSignals:信号源,信号中信号signal of signals信号,发送数据就是信号
    [command.executionSignals subscribeNext:^(RACSignal * x) {
        [x subscribeNext:^(id x) {

            NSLog(@"%@",x);
        }];
    }];
    
    
    //3.2 RAC高级用法
    //switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
//    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
//        
//        NSLog(@"%@",x);
//    }];
    //4. 监听信号(前提是订阅者发送完毕后一定要调用[subscriber sendCompleted];)
//
//    [command.executing   subscribeNext:^(NSNumber * _Nullable x) {
//       //x为bool型变量
//        if ([x boolValue] == YES) {
//            // 正在执行
//            NSLog(@"正在执行");
//
//        }else{
//            // 执行完成
//            NSLog(@"执行完成");
//        }
//    }];
    //监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
    [[command.executing  skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        //x为bool型变量
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");
            
        }else{
            // 执行完成
            NSLog(@"执行完成");
        }
    }];
    //5. 执行命令
    [command execute:@1];
    
   
}
/*
 不使用skip
 
 2018-01-02 15:20:22.091727+0800 RAC的学习[9676:454456] 执行完成
 2018-01-02 15:20:22.092156+0800 RAC的学习[9676:454456] 1
 2018-01-02 15:20:22.093439+0800 RAC的学习[9676:454456] 正在执行
 2018-01-02 15:20:22.093679+0800 RAC的学习[9676:454456] AFN网络请求
 2018-01-02 15:20:22.093902+0800 RAC的学习[9676:454456] 网络请求的到的数据
 2018-01-02 15:20:22.094442+0800 RAC的学习[9676:454456] 执行完成
 使用skip:
 监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
 2018-01-02 15:22:58.319233+0800 RAC的学习[9784:459537] 1
 2018-01-02 15:22:58.320647+0800 RAC的学习[9784:459537] 正在执行
 2018-01-02 15:22:58.320914+0800 RAC的学习[9784:459537] AFN网络请求
 2018-01-02 15:22:58.321147+0800 RAC的学习[9784:459537] 网络请求的到的数据
 2018-01-02 15:22:58.321548+0800 RAC的学习[9784:459537] 执行完成
 */
- (void)test {
    /*
     2. 创建信号中信号
     */
        RACSubject *signalofsignals = [RACSubject subject];
        RACSubject *signalA = [RACSubject subject];
        RACSubject *signalB = [RACSubject subject];
        //订阅信号
        [signalofsignals.switchToLatest subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
        }];
        //发送信号
        //信号发送信号
        [signalofsignals sendNext:signalA];
        [signalA sendNext:@1];
        [signalB sendNext:@"B"];
}
@end
