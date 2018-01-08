//
//  LoginViewModel.h
//  RAC的学习
//
//  Created by xyj on 2018/1/8.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
@interface LoginViewModel : NSObject
//保存登录界面的账号和密码
//账号
@property (nonatomic,strong) NSString *account;
//密码
@property (nonatomic,strong) NSString *pwd;
//处理登录按钮是否允许点击
@property (nonatomic,strong,readonly) RACSignal *loginEnableSignal;
//登录按钮命令
@property (nonatomic,strong,readonly) RACCommand *loginCommand;
@end
