//
//  RequestModel.h
//  RAC的学习
//
//  Created by xyj on 2018/1/8.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
@interface RequestModel : NSObject
/*网络请求命令*/
@property (nonatomic,strong) RACCommand *requestCommand;
//模型数组
@property (nonatomic, strong) NSArray *models;
@end
