//
//  ZHHotelBtnsCell.m
//  RAC的学习
//
//  Created by xyj on 2018/4/21.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ZHHotelBtnsCell.h"
#import "ZHOrderDetailViewModel.h"
@interface ZHHotelBtnsCell ()
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@end

@implementation ZHHotelBtnsCell

-(void)bindViewWithViewModel:(ZHBaseViewModel *)cellViewModel{
    ZHOrderDetailViewModel *VM = (ZHOrderDetailViewModel *)cellViewModel;
    self.clearBtn.rac_command = VM.clearCommand;
    self.submitBtn.rac_command = VM.submitCommand;
}
@end
