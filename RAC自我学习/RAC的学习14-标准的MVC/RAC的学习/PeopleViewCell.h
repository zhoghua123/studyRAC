//
//  PeopleViewCell.h
//  RAC的学习
//
//  Created by xyj on 2018/1/25.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PersonModel;
@interface PeopleViewCell : UITableViewCell
@property (nonatomic,strong) PersonModel *model;
@end
