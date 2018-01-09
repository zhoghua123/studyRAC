//
//  RequestModel.m
//  RAC的学习
//
//  Created by xyj on 2018/1/8.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "RequestModel.h"
#import <AFNetworking/AFNetworking.h>
#import "Book.h"
@implementation RequestModel

-(instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

-(void)setup{
    //1.执行请求命令
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
     //2. 创建请求信号
        RACSignal *requestSignal =[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            //3.发送网络请求
            //创建请求管理者
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:@"https://api.douban.com/v2/book/search" parameters:@{@"q":@"基础"} progress:^(NSProgress * _Nonnull downloadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [subscriber sendNext:responseObject];
                [subscriber sendCompleted];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [subscriber sendError:error];
            }];
            return nil;
        }];
        
      //4.处理数据
        //将原始数据映射出模型数组
      RACSignal *dealSignal =  [requestSignal map:^id _Nullable(NSDictionary *  _Nullable value) {
          
            NSArray *dicAr = value[@"books"];
            //将字典映射成模型
            NSArray *modelArray = [[dicAr.rac_sequence map:^id _Nullable(id  _Nullable value) {
                //一一映射,字典转模型
                return [Book bookWithDict:value];
            }] array];
          
            return modelArray;
          
        }] ;
        
        //返回处理后的信号
        return dealSignal;
    }];
    
    //5. 监听执行过程
    //skip1的原因是,程序已启动就回调用一次
    [[_requestCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if ([x boolValue] == YES) {
            //正在执行
            NSLog(@"请求中");
            //弹框提示正在登录
        }else{
            //执行完成,隐藏弹框
            NSLog(@"请求完成");
        }
    } error:^(NSError * _Nullable error) {
        NSLog(@"请求失败");
    }];
    
    //6.执行命令后更新数据源
    //使用这个
//    @weakify(self);
//    [_requestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
//        @strongify(self);
//        self.models = x;
//    }];
    //或者
    RAC(self,models) = _requestCommand.executionSignals.switchToLatest;
}
@end
