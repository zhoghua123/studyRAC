//
//  ViewController.m
//  RAC的学习
//
//  Created by xyj on 2017/12/25.
//  Copyright © 2017年 xyj. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "TwoViewController.h"
@interface ViewController ()

@end

@implementation ViewController
- (IBAction)oneAction:(id)sender {
    // 创建第二个控制器
    TwoViewController *twoVc = [[TwoViewController alloc] init];
    // 设置代理信号
    twoVc.delegateSignal = [RACSubject subject];
    // 订阅代理信号
    [twoVc.delegateSignal subscribeNext:^(id x) {
        
        NSLog(@"点击了通知按钮");
    }];
    
    // 跳转到第二个控制器
    [self presentViewController:twoVc animated:YES completion:nil];
}

// RACSubject使用步骤
// 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
// 2.订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
// 3.发送信号 sendNext:(id)value

/*
 RACSubject:底层实现和RACSignal不一样。
 1.[RACSubject subject]:
    内部会创建一个可变数组赋值给属性
 2.调用subscribeNext订阅信号:
    创建订阅者,把nextblock赋值给订阅者属性
    将该订阅者保存到属性数组中
 3.调用sendNext发送信号:
    遍历数组属性,拿到所有的订阅者,一个一个调用订阅者的nextBlock。
 
 */

// RACReplaySubject使用步骤:
// 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
// 2.可以先订阅信号，也可以先发送信号。
// 2.1 订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
// 2.2 发送信号 sendNext:(id)value

/*
  RACReplaySubject:底层实现和RACSubject不一样。
 1. 创建[RACReplaySubject subject]:
    尽管subject方法是父类的,但是调用init会有优先调用子类RACReplaySubject的init
    初始化一个可变数组属性用于存储值
  2.调用sendNext发送信号:
    把值保存到数组属性中
    调用父类RACSubject sendNext:遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
  3.调用subscribeNext订阅信号:
        遍历保存的所有值，一个一个调用订阅者的nextBlock(一个订阅者遍历值调用)
 1. 如果先订阅再发送:
    跟RACSubject效果一样
 2.如果先发送再订阅:
    也就是先保存值，在订阅值。
    一旦订阅就回迅速拿到之前发送的所有值
    即: 如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    //1.创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    //2.发送信号
    //1.保存值 2. 遍历所有的订阅者,发送数据
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    //3. 订阅信号
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"第一个订阅者拿到的数据===%@",x);
    }];
    [replaySubject subscribeNext:^(id  _Nullable x) {
        NSLog(@"第二个订阅者拿到的数据===%@",x);
    }];
    [self test];
}
- (void)test {
    //1.创建信号(此时代表信号)
    RACSubject *subject = [RACSubject subject];
    //2.订阅信号
    //RACSubject处理订阅:仅仅是保存订阅者
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者第一次接收到数据:%@",x);
    }];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者第二次接收到数据:%@",x);
    }];
    //3. 发送数据(信号)(此时代表订阅者)
    //底层实现:遍历所有的订阅者,调用nextBlock
    [subject sendNext:@"1"];
}
@end
