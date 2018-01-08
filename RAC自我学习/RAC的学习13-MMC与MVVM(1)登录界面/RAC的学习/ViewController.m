//
//  ViewController.m
//  RAC的学习
//
//  Created by xyj on 2017/12/25.
//  Copyright © 2017年 xyj. All rights reserved.
//

/*
 1.  常见的架构思想:
 MVC M:模型 V:视图 C:控制器
 MVVM M:模型 V:视图+控制器 VM:视图模型
 MVCS M:模型 V:视图 C:控制器 C:服务类
 VIPER V:视图 I:交互器 P:展示器 E:实体 R:路由
 2. MVVM介绍
 模型(M):保存视图数据。
 视图+控制器(V):展示内容 + 如何展示
 视图模型(VM):处理展示的业务逻辑，包括按钮的点击，数据的请求和解析等等。
 */
#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
@interface ViewController ()

@property (nonatomic, strong) id<RACSubscriber> subscriber;
@property (weak, nonatomic) IBOutlet UITextField *accountTextfield;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

// ReactiveCocoa + MVVM 实战一：登录界面

//正常写法:不使用MVVM
/*
 可以看到如下:
 1. 文本框与等登录按钮的逻辑
 2. 点击按钮发送网络请求
 这些业务逻辑都放在了控制器中
 */
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //1. 处理文本框的业务逻辑
    RACSignal *loginEnableSignal = [RACSignal combineLatest:@[_accountTextfield.rac_textSignal,_pwdTextField.rac_textSignal] reduce:^id _Nullable(NSString *account ,NSString *pwd){
        
        return @(account.length && pwd.length);
    }];
    //2. 设置按钮能否点击
    RAC(_loginBtn,enabled) = loginEnableSignal;
    
    //3. 创建登录命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
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
    //4. 处理登录请求返回的结果
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    //5.处理登录的执行过程
    //skip1的原因是,程序已启动就回调用一次
    [[command.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue] == YES) {
            //正在执行
            NSLog(@"正在执行");
            //弹框提示正在登录
        }else{
            //执行完成,隐藏弹框
            NSLog(@"执行完成");
        }
    }];
    //6.监听登录按钮点击
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"点击了登录按钮");
        //处理登录事件(只要是处理事件,就要想到用命令类(Racmmand)
        //7.执行命令
        [command execute:nil];
    }];
}


@end
