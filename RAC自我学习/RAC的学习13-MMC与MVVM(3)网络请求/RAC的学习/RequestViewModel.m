//
//  RequestViewModel.m
//  RAC的学习
//
//  Created by xyj on 2018/1/25.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "RequestViewModel.h"
#import <AFNetworking/AFNetworking.h>
#import "Book.h"

@implementation RequestViewModel

-(instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

-(void)setup{
    //1.执行请求命令
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"======%@",input);
        //2. 创建请求信号
        RACSignal *requestSignal =[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            //3.发送网络请求
            //创建请求管理者
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:@"https://api.douban.com/v2/book/search" parameters:@{@"q":@"基础"} progress:^(NSProgress * _Nonnull downloadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"%@",responseObject);
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
    
    
    //5.执行命令后更新数据源
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
