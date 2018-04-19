//
//  RequestViewModel.m
//  RAC的学习
//
//  Created by xyj on 2018/1/25.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "RequestViewModel.h"
#import "BookRequest.h"
#import "Book.h"
@interface RequestViewModel ()

@property (strong, nonatomic) BookRequest *bookRequest;

@end

@implementation RequestViewModel

- (instancetype)init
{
    if (self = [super init]) {
        _bookRequest = [[BookRequest alloc] init];
        [self setup];
    }
    return self;
}

- (void)setup
{
    @weakify(self)
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"======%@",input);
        @strongify(self)
        // Zhuo：网络层负责数据请求，以及返回数据封装成对象
        // VM 负责二次加工数据，比如要做筛选过滤操作，这儿单纯赋值触发UI刷新
        [[self.bookRequest requestBookListWithKeyword:input] subscribeNext:^(id  _Nullable responseObject) {
            @strongify(self)
            NSArray *dicAr = responseObject[@"books"];
            //将字典映射成模型
            NSArray *modelArray = [[dicAr.rac_sequence map:^id _Nullable(id  _Nullable value) {
                //一一映射,字典转模型
                return [Book bookWithDict:value];
            }] array];
            self.models = modelArray;
        }];
        
        return [RACSignal empty];
    }];
}
@end
