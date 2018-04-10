//
//  RequestViewModel.m
//  RAC的学习
//
//  Created by xyj on 2018/1/25.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "RequestViewModel.h"
#import "BookRequest.h"

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
        [[self.bookRequest requestBookListWithKeyword:input] subscribeNext:^(NSArray * _Nullable bookArray) {
            @strongify(self)
            self.models = bookArray;
        }];
        
        return [RACSignal empty];
    }];
}
@end
