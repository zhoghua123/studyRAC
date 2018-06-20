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
    //1.创建请求信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"创建信号中的block:AFN发送网络请求");
        //4.网络请求完毕,返回数据,发送信号,将数据传出
        [subscriber sendNext:@1];
        return nil;
    }];
    //2. 创建连接(把信号转换成连接类)，然后自动连接激活信号！！！这样随时订阅就可以触发信号了
    RACSignal *autoSignal = [[signal publish] autoconnect];
    //3. 订阅已经被激活的信号
    [autoSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者1===%@",x);
    }];
    //没用了，只能订阅一次
    [autoSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者2===%@",x);
    }];

    /*
     autoconnect原理：
     1. 创建返回一个RACSignal，该信号的didSubscribe（block中做了2件事）
        1. 拿到源信号（subject）订阅didSubscribe穿进去的订阅者
        2. 执行connect
        3. 代码如下：
        第一步： RACDisposable *subscriptionDisposable = [self.signal subscribe:subscriber];
        第二步：  RACDisposable *connectionDisposable = [self connect];

    2. 一旦autosignal被订阅就执行第一步，
     */
    
}
- (void)test2 {
    //1.创建请求信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"创建信号中的block:AFN发送网络请求");
        //4.网络请求完毕,返回数据,发送信号,将数据传出
        [subscriber sendNext:@1];
        return nil;
    }];
    //2. 创建连接(把信号转换成连接类)
    RACMulticastConnection *connection = [signal publish];
    //    RACMulticastConnection *connection = [signal multicast:[RACReplaySubject subject]];
    //3. 订阅连接类信号
    // 注意：订阅信号，也不能激活信号，只是保存订阅者到数组，必须通过连接,当调用连接，就会一次性调用所有订阅者的sendNext:
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者1===%@",x);
    }];
    [connection.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者2===%@",x);
    }];
    //5.连接,激活信号
    [connection connect];
    /*
     打印结果如下:
     2018-01-02 11:07:38.938790+0800 RAC的学习[6701:245354] 创建信号中的block:AFN发送网络请求
     2018-01-02 11:07:38.939491+0800 RAC的学习[6701:245354] 订阅者1===1
     2018-01-02 11:07:38.939804+0800 RAC的学习[6701:245354] 订阅者2===1
     
     原理:
     1.创建connect:
     1.publish创建其实与multicast创建一样,因为publish内部会通过multicast创建
     2.multicast内部做如下事情:
     1. 新建RACSubject对象
     2. 初始化RACMulticastConnection对象
     3. 将signal赋值给connect对象的属性sourceSignal; subject赋值给connect对象的属性signal
     2. connection.signal 订阅信号
     1. 本质是拿到subject(从上面的可以看出)订阅
     2. 订阅信号,此时用的是subject订阅信号,跟sourceSignal无关,因此此时的订阅不会调用源信号的block
     3. subject订阅信号原理可知,会保存所有的订阅者
     3.[connection connect]
     1. 拿到源信号sourceSignal,订阅新信号signal(subject)(此时subject就是充当订阅者了,不是信号了) `[self.sourceSignal subscribe:_signal]`
     2. 因为这里只调用了源信号一次,因此,源信号的block只会调用一次,但是源信号block中传出的订阅者可是subject
     3. 源信号中的订阅者subject,发送信号: didSubscribe，拿到订阅者调用sendNext，其实是调用RACSubject的sendNext
     4. 根据subject发送信号的原理,会遍历subject保存的所有订阅者发送信号
     
     
     // RACMulticastConnection底层原理:
     // 1.创建connect，connect.sourceSignal -> RACSignal(原始信号)  connect.signal -> RACSubject
     // 2.订阅connect.signal，会调用RACSubject的subscribeNext，创建订阅者，而且把订阅者保存起来，不会执行block。
     // 3.[connect connect]内部会订阅RACSignal(原始信号)，并且订阅者是RACSubject
     // 3.1.订阅原始信号，就会调用原始信号中的didSubscribe
     // 3.2 didSubscribe，拿到订阅者调用sendNext，其实是调用RACSubject的sendNext
     // 4.RACSubject的sendNext,会遍历RACSubject所有订阅者发送信号。
     // 4.1 因为刚刚第二步，都是在订阅RACSubject，因此会拿到第二步所有的订阅者，调用他们的nextBlock
     
     */
}
- (void)test {
    //引导
    //1.创建请求信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"创建信号中的block:AFN发送网络请求");
        //3.网络请求完毕,返回数据,发送信号,将数据传出
        [subscriber sendNext:@1];
        return nil;
    }];
    //2. 订阅信号
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者1===%@",x);
    }];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者2===%@",x);
    }];
    /*
     打印:
     2018-01-02 10:57:04.804152+0800 RAC的学习[6544:226938] 创建信号中的block:AFN发送网络请求
     2018-01-02 10:57:04.804411+0800 RAC的学习[6544:226938] 订阅者1===1
     2018-01-02 10:57:04.804694+0800 RAC的学习[6544:226938] 创建信号中的block:AFN发送网络请求
     2018-01-02 10:57:04.804855+0800 RAC的学习[6544:226938] 订阅者2===1
     从打印可以看出:
     创建信号中的block被调用了2次
     引起弊端:在一个信号中发送请求，每次订阅一次都会发送请求，这样就会导致多次请求。
     要求:
     1.每次订阅不要都请求一次,只请求一次,每次订阅都要拿到第一次请求的数据
     */
}

@end
