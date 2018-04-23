//
//  ZHLabelAndTextFieldViewModel.h
//  RAC的学习
//
//  Created by xyj on 2018/4/21.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ZHBaseViewModel.h"

@interface ZHLabelAndTextFieldViewModel : ZHBaseViewModel
@property (nonatomic,copy) NSString *inputText;
@property (nonatomic,strong) RACSignal *inputChannel;
@end
