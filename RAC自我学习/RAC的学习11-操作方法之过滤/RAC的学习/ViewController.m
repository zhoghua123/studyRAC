//
//  ViewController.m
//  RAC的学习
//
//  Created by xyj on 2017/12/25.
//  Copyright © 2017年 xyj. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/RACReturnSignal.h>
@interface ViewController ()
@property (nonatomic,weak) UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passWordTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@end

// 监听文本框的内容改变，把结构重新映射成一个新值.



@implementation ViewController
-(void)viewDidLoad{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 30)];
    textField.backgroundColor = [UIColor redColor];
    [self.view addSubview:textField];
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(100, 300, 200, 30);
    [self.view addSubview: label];
    _textField = textField;
    [self test6];
}
//distinctUntilChanged:当上一次的值和当前的值有明显的变化就会发出信号，否则会被忽略掉。
- (void)test6 {
    // 过滤，当上一次和当前的值不一样，就会发出内容。
    // 在开发中，刷新UI经常使用，只有两次数据不一样才需要刷新
    [[_textField.rac_textSignal distinctUntilChanged] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
}
- (void)test5 {
   // takeUntil:(RACSignal *):获取信号直到某个信号执行完成
    //例1:
    // 监听文本框的改变直到当前对象被销毁
    [[_textField.rac_textSignal takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //例2:
    //监听信号subject知道subject1发送完成
    RACSubject *subject1 = [RACSubject subject];
    RACSubject *subject = [RACSubject subject];
    [[subject takeUntil:subject1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    [subject sendNext:@1];
    [subject sendNext:@2];
    //一旦信号1发送完成,就不会在订阅subject信号
    [subject1 sendCompleted];
    //不会在订阅了
    [subject sendNext:@3];
    
}

- (void)test4 {
    RACSubject *subject = [RACSubject subject];
    //只会取倒数第一个值
    RACSignal *takeLastSignal = [subject takeLast:1];
    //订阅信号
    [takeLastSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    //发送信号
    //只取倒数第一个
    [subject sendNext:@1];
    [subject sendNext:@123];
    [subject sendCompleted];
}
//take:从开始一共取N次的信号
- (void)test3{
    RACSubject *subject = [RACSubject subject];
    //忽略一些值
    RACSignal *takeSignal = [subject take:1];
    //订阅信号
    [takeSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    //发送信号
    //只取第一个
    [subject sendNext:@1];
    [subject sendNext:@123];
}
- (void)test2 {
    RACSubject *subject = [RACSubject subject];
    //忽略一些值
    RACSignal *ignoreSignal = [subject ignore:@1];
    //忽略所有值
//    [subject ignoreValues];
    //订阅信号
    [ignoreSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    //发送信号
    //会被忽略掉
    [subject sendNext:@1];
    [subject sendNext:@123];
}
/*
 filter:过滤信号，使用它可以获取满足条件的信号.
 */

- (void)test {
    //只有文本框的长度大于5才获取值
    [[_textField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        //返回值,就是过滤条件,只有满足这个条件才能获取到内容
        return value.length > 5;
    }] subscribeNext:^(NSString * _Nullable x) {
       //文本框的内容
        NSLog(@"%@",x);
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
}

@end
