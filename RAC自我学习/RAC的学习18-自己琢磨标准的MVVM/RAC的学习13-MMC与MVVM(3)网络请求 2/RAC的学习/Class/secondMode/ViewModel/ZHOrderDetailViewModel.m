//
//  ZHOrderDetailViewModel.m
//  RAC的学习
//
//  Created by xyj on 2018/4/23.
//  Copyright © 2018年 xyj. All rights reserved.
//
/*
 视图VM间的通信:
 1.源视图VM通过subject发出信号
 2.主线VM订阅subject信号,就可以接收到信号
 3.主线VM在把信号转交给目标视图VM
 */
#import "ZHOrderDetailViewModel.h"

@implementation ZHOrderDetailViewModel
-(instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}
-(RACSubject *)submitSubject{
    if (_submitSubject == nil) {
        _submitSubject = [RACSubject subject];
    }
    return _submitSubject ;
}
-(RACSubject *)clearSubject{
    if (_clearSubject == nil) {
        _clearSubject = [RACSubject subject];
    }
    return _clearSubject ;
}
//视图VM之间的通信: 源视图VM发出信号
-(void)setup{
    @weakify(self);
    _clearCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if (self.clearSubject) {
            [self.clearSubject sendNext:@1];
        }
        return [RACSignal empty];
    }];
    _submitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        if (self.submitCommand) {
            [self.submitSubject sendNext:@1];
        }
        return [RACSignal empty];
    }];
}
@end
