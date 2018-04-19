//
//  ZHTableViewViewModel.m
//  RAC的学习
//
//  Created by xyj on 2018/4/19.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ZHTableViewViewModel.h"

@implementation ZHTableViewViewModel
-(BookRequest *)netRequest{
    if (_netRequest == nil) {
        _netRequest = [[BookRequest alloc] init];
    }
    return _netRequest;
}
@end
