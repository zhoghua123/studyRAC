//
//  ZHTableViewViewModel.h
//  RAC的学习
//
//  Created by xyj on 2018/4/19.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ZHBaseViewModel.h"
#import "BookRequest.h"
@interface ZHTableViewViewModel : ZHBaseViewModel
@property (nonatomic,strong) BookRequest *netRequest;
@end
