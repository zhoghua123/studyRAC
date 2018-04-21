//
//  ZHBaseViewCell.h
//  RAC的学习
//
//  Created by xyj on 2018/4/21.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHBaseViewModel;
@interface ZHBaseViewCell : UITableViewCell
-(void)bindViewWithViewModel: (ZHBaseViewModel *)cellViewModel;
@end
