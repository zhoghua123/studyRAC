//
//  ViewController.m
//  RAC的学习
//
//  Created by xyj on 2017/12/25.
//  Copyright © 2017年 xyj. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "RedView.h"
//#import "NSObject+RACKVOWrapper.h"
@interface ViewController ()
@property (nonatomic,weak) RedView *redV;
@end


@implementation ViewController


-(void)viewDidLoad{
    //处理当一个界面有多次请求时，需要都获取到数据时，才能展示界面
    //网络请求1
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"网络请求1") ;
        [subscriber sendNext:@"网络请求1获取到的数据"];
        [subscriber sendCompleted];
        return nil;
    }];
    //网络请求2
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"网络请求2") ;
        [subscriber sendNext:@"网络请求2获取到的数据"];
        [subscriber sendCompleted];
        return nil;
    }];
    
    //保证两个请求都完成的情况下才能刷新UI
    /*
     数组用于存放信号
     selector:当数组中的信号都发送数据的时候,才会调用
     selector参数个数: 与数组中的信号个数一样
     selector参数类型: 与数组中对应的信号发出的数据一一对应
     */
    [self rac_liftSelector:@selector(obtainData1: andData2:) withSignalsFromArray:@[signal1,signal2]];
}
//同时获取到数据,刷新UI
-(void)obtainData1:(NSString *)data1 andData2: (NSString *)data2{
    NSLog(@"数据1===%@===数据2===%@",data1,data2);
}


//监听TextField内容改变
- (void)test5 {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    textField.backgroundColor = [UIColor redColor];
    [self.view addSubview:textField];
    //监听TextField内容改变
    [textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"=====%@",x);
    }];
}
//监听通知
- (void)test4 {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    textField.backgroundColor = [UIColor redColor];
    [self.view addSubview:textField];
    //监听键盘弹出的通知
    //RAC监听
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"键盘将要弹出了");
    }];
    //OC监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sss:) name:UIKeyboardWillShowNotification object:nil];
}
-(void)sss:(id)d{
    NSLog(@"键盘将要sss弹出了");
}
//监听事件
- (void)test3 {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
    //监听事件
    //把按钮的的点击事件转换为信号,点击按钮,就回发送信号
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"点击了按钮");
    }];
}
//KVO
- (void)test2 {
    //KVO
    RedView *redV = [[RedView alloc] init];
    redV.backgroundColor = [UIColor redColor];
    redV.frame = CGRectMake(50, 50, 100, 100);
    [self.view addSubview:redV];
    _redV = redV;
    
    //把监听redview的frame属性改变转换成信号,只要只改变就发送信号
    //方法1:
    //程序一启动,加载RedView就会改变frame,因此开始就会调用一次
    [[redV rac_valuesForKeyPath:@"frame" observer:self] subscribeNext:^(id  _Nullable x) {
        NSLog(@"--监听属性值---");
    }];
    
    //方法2:
    //程序启动加载redView时不会调用
    [[redV rac_valuesAndChangesForKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:self] subscribeNext:^(RACTwoTuple<id,NSDictionary *> * _Nullable x) {
        NSLog(@"--监听属性变化---");
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.redV.frame = CGRectMake(100, 100, 200, 200);
}
/*
 rac_signalForSelector
 原理:把调用某个对象的方法转换成信号，只要调用这个方法，就会发送信号。只要提前订阅这个信号就可以监听这个对象的调用了.
 作用: 监听对象的某个方法有没有调用
 
 */
- (void)test {
    RedView *redV = [[RedView alloc] init];
    redV.backgroundColor = [UIColor redColor];
    redV.frame = CGRectMake(50, 50, 100, 100);
    [self.view addSubview:redV];
    
    [[redV rac_signalForSelector:@selector(touchesBegan:withEvent:)] subscribeNext:^(id  _Nullable x) {
        NSLog(@"点击View");
    }];
}


@end
