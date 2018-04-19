//
//  ZHBookListViewModel.m
//  RAC的学习
//
//  Created by xyj on 2018/4/19.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ZHBookListViewModel.h"
#import "Book.h"
#import "ZHBooklistCellViewModel.h"
@interface ZHBookListViewModel()

@end

@implementation ZHBookListViewModel

- (instancetype)init
{
    if (self = [super init]) {
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
        [[self.netRequest requestBookListWithURL:ZHURLSearchBook andParameter:@{@"q":input}] subscribeNext:^(id  _Nullable responseObject) {
            //处理数据
            @strongify(self)
            NSArray *dicAr = responseObject[@"books"];
            //将字典映射成模型
            NSArray *modelArray = [[dicAr.rac_sequence map:^id _Nullable(id  _Nullable value) {
                //一一映射,字典转模型
                return [[ZHBooklistCellViewModel alloc] initWithModel:[Book bookWithDict:value]];
            }] array];
            self.models = modelArray;
        }];
        
        return [RACSignal empty];
    }];
}
@end
