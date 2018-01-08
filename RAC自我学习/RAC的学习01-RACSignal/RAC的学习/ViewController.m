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

@property (nonatomic, strong) id<RACSubscriber> subscriber;
@end

@implementation ViewController

// RACSignal底层实现：
// 1.创建信号，首先把didSubscribe保存到信号中，还不会触发。
// 2.当信号被订阅，也就是调用signal的subscribeNext:nextBlock
// 2.2 subscribeNext内部会创建订阅者subscriber，并且把nextBlock保存到subscriber中。
// 2.1 subscribeNext内部会调用siganl的didSubscribe
// 3.siganl的didSubscribe中调用[subscriber sendNext:@1];
// 3.1 sendNext底层其实就是执行subscriber的nextBlock

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber ) {
        
        _subscriber = subscriber;
        
        // 3.发送信号
        [subscriber sendNext:@"123"];
        
        return [RACDisposable disposableWithBlock:^{
            // 只要信号取消订阅就会来这
            // 清空资源
            NSLog(@"信号被取消订阅了");
        }];
    }];
    
    // 2.订阅信号
    RACDisposable *disposable = [signal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];

    // 默认一个信号发送数据完毕就会自动取消订阅.
    // 但是只要订阅者在,就不会自动取消信号订阅(用属性强引用着订阅者,就不会自动取消订阅了)
    // 那么我们就需要(主动取消)取消订阅信号
    [disposable dispose];
}

- (void)test {
    //1.创建信号
    RACSignal *signal  = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //didSubscribe:当前block
        // block调用时刻：每当有订阅者订阅信号，就会调用block。
        // didSubscribe作用: 发送数据
        // 3.发送信号
        [subscriber sendNext:@1];
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            //block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号
            // 执行完Block后，当前信号就不在被订阅了。
            
            NSLog(@"信号被销毁");
        }];
    }];
    //2. 订阅信号,才会激活信号(相当于响应式编程中的监听)
    [signal subscribeNext:^(id  _Nullable x) {
        //nextBlock:当前block
        // block调用时刻：每当有信号发出数据，就会调用block.
        //nextBlock作用: 处理数据展示到UI上面
        //x:信号发送内容
        NSLog(@"接收到数据:%@",x);
    } error:^(NSError * _Nullable error) {
        NSLog(@"订阅信号发生错误");
    } completed:^{
        NSLog(@"订阅完成");
    }];
}
@end
