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
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
     //执行命令,发送网络请求,创建信号
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            //创建请求管理者
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            
            [manager GET:@"https://api.douban.com/v2/book/search" parameters:@{@"q":@"基础"} progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //请求成功调用
                NSLog(@"请求成功%@",responseObject);
                NSArray *dicAr = responseObject[@"books"];
                [dicAr writeToFile:@"/Users/xyj/Desktop/sss.plist" atomically:YES];
                //字典数组
                NSArray *modelArray = [[dicAr.rac_sequence map:^id _Nullable(id  _Nullable value) {
                    //一一映射,字典转模型
                    return [Book bookWithDict:value];
                }] array];
                //发送数据
                [subscriber sendNext:modelArray];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
            return nil;
        }];
    }];
}
@end
