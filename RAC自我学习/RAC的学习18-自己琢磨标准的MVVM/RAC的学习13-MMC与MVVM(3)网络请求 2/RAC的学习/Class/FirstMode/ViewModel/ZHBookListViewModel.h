//
//  ZHBookListViewModel.h
//  RAC的学习
//
//  Created by xyj on 2018/4/19.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ZHTableViewViewModel.h"
@class RACCommand;
@interface ZHBookListViewModel : ZHTableViewViewModel
/*网络请求命令*/
@property (nonatomic, strong) RACCommand *requestCommand;
//模型数组
@property (nonatomic, strong) NSArray *dataSource;
@end
