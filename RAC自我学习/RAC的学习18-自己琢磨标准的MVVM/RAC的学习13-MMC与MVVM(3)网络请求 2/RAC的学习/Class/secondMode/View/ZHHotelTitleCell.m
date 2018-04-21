//
//  ZHHotelTitleCell.m
//  RAC的学习
//
//  Created by xyj on 2018/4/20.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ZHHotelTitleCell.h"
#import "ZHHotelTitleViewModel.h"
@interface ZHHotelTitleCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
@implementation ZHHotelTitleCell

-(void)bindViewWithViewModel:(ZHBaseViewModel *)cellViewModel{
    ZHHotelTitleViewModel *cellVM = (ZHHotelTitleViewModel *)cellViewModel;
    RAC(self.titleLabel,text) = RACObserve(cellVM, title);
}
@end
