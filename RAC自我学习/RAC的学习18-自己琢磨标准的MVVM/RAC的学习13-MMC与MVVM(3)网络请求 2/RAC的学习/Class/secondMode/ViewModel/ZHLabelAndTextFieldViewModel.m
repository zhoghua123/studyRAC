//
//  ZHLabelAndTextFieldViewModel.m
//  RAC的学习
//
//  Created by xyj on 2018/4/21.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ZHLabelAndTextFieldViewModel.h"

@implementation ZHLabelAndTextFieldViewModel
-(instancetype)init{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}
-(void)setup{
    _inputChannel = RACObserve(self, inputText);
}
@end
