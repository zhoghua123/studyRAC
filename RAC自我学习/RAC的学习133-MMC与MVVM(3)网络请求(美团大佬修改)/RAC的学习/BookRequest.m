//
//  BookRequest.m
//  RAC的学习
//
//  Created by Zhuo Wu on 09/04/2018.
//  Copyright © 2018 xyj. All rights reserved.
//

#import "BookRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "Book.h"

@implementation BookRequest

- (RACSignal *)requestBookListWithKeyword:(NSString *)keyword
{
    return [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        //3.发送网络请求
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:@"https://api.douban.com/v2/book/search" parameters:@{@"q":keyword} progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSArray *dicAr = responseObject[@"books"];
            //将字典映射成模型
            NSArray *modelArray = [[dicAr.rac_sequence map:^id _Nullable(id  _Nullable value) {
                //一一映射,字典转模型
                return [Book bookWithDict:value];
            }] array];
            
            [subscriber sendNext:modelArray];
            [subscriber sendCompleted];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        return nil;
        // Zhuo：网络请求一般用热信号，多次触发。当然这个case里面冷信号也可以
    }] publish] autoconnect];
}


@end
