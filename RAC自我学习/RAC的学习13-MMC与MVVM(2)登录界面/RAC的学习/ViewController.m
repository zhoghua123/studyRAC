//
//  ViewController.m
//  RAC的学习
//
//  Created by xyj on 2017/12/25.
//  Copyright © 2017年 xyj. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "LoginViewModel.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextfield;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic,strong) LoginViewModel *loginVM;
@end

@implementation ViewController
-(LoginViewModel *)loginVM{
    if (_loginVM == nil) {
        _loginVM = [[LoginViewModel alloc] init];
    }
    return _loginVM ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self bindViewModel];
    [self loginEvent];
}
-(void)bindViewModel{
    //1. 给视图模型的账号和密码绑定信号(只要文本框内容改变,就回给属性赋值)
    RAC(self.loginVM,account) = _accountTextfield.rac_textSignal;
    RAC(self.loginVM,pwd) = _pwdTextField.rac_textSignal;
    
}
//登录事件
-(void)loginEvent{
    //1.处理文本框的业务逻辑
    //设置按钮能否点击
      RAC(_loginBtn,enabled) = self.loginVM.loginEnableSignal;
    //2. 监听登录按钮点击
    [[_loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"点击了登录按钮");
        //处理登录事件(只要是处理事件,就要想到用命令类(Racmmand)
        //7.执行命令
        [self.loginVM.loginCommand execute:nil];
    }];
    
    
    //3. 处理登录的执行过程
    //skip1的原因是,程序已启动就回调用一次
    [[self.loginVM.loginCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
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
