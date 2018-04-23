//
//  ZHHotelResultCell.m
//  RAC的学习
//
//  Created by xyj on 2018/4/21.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ZHHotelResultCell.h"
#import "ZHHotelResultViewModel.h"

@interface ZHHotelResultCell ()
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end
@implementation ZHHotelResultCell

-(void)bindViewWithViewModel:(ZHBaseViewModel *)cellViewModel{
    ZHHotelResultViewModel * ResultVM = (ZHHotelResultViewModel *)cellViewModel;
    RAC(self.resultLabel,text) = RACObserve(ResultVM, resultStr);
}

@end
