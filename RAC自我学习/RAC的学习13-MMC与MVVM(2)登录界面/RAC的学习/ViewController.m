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
#import "LoginViewModel.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextfield;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic,strong) LoginViewModel *loginVM;
@end


/*
 使用MVVM
 
 分析：
 1.之前界面的所有业务逻辑都交给控制器做处理
 2.在MVVM架构中把控制器的业务全部搬去VM模型，也就是每个控制器对应一个VM模型.
 MVVM:
 VM: 视图模型,处理界面上的所有业务逻辑,每一个控制器对应一个VM模型
 VM: 最好不要包括视图V
 VM: 模型都是继承自NSObject,命名都是以**ViewModel命名
 
 MVVM编程步骤
 1. 先创建VM模型,把整个界面的一些业务逻辑处理完
 2. 回到控制器去执行
 */
// ReactiveCocoa + MVVM 实战一：登录界面
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
