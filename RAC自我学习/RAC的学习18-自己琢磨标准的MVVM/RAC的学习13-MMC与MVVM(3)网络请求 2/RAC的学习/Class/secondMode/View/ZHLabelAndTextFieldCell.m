//
//  ZHLabelAndTextFieldCell.m
//  RAC的学习
//
//  Created by xyj on 2018/4/21.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "ZHLabelAndTextFieldCell.h"
#import "ZHLabelAndTextFieldViewModel.h"
@interface ZHLabelAndTextFieldCell ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation ZHLabelAndTextFieldCell

-(void)bindViewWithViewModel:(ZHBaseViewModel *)cellViewModel{
    ZHLabelAndTextFieldViewModel *cellVM = (ZHLabelAndTextFieldViewModel *)cellViewModel;
    RACChannelTerminal *channelTerminal = self.textField.rac_newTextChannel;
    RACChannelTerminal *channelTerminal2 = RACChannelTo(cellVM,inputText);
    [channelTerminal subscribe:channelTerminal2];
    [channelTerminal2 subscribe:channelTerminal];
}

@end
