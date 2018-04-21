//
//  BookViewCell.m
//  RAC的学习
//
//  Created by xyj on 2018/1/25.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "BookViewCell.h"
#import "ZHBooklistCellViewModel.h"
@interface BookViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceAndPubLabel;

@end

@implementation BookViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
//-(void)setCellViewModel:(ZHBooklistCellViewModel *)cellViewModel{
//    _cellViewModel = cellViewModel;
//    _titleLabel.text = cellViewModel.title;
//    _subtitleLabel.text = cellViewModel.subtitle;
//    _priceAndPubLabel.text = cellViewModel.priceAndPubdate;
//}
-(void)bindViewWithViewModel:(ZHBaseViewModel *)cellViewModel{
   ZHBooklistCellViewModel * xcellViewModel = (ZHBooklistCellViewModel *)cellViewModel;
    //单向绑定!!!!
    //rac_prepareForReuseSignal: 专门用于cell的解绑
    RAC(self.titleLabel,text) = [RACObserve(xcellViewModel, title) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.subtitleLabel,text) = [RACObserve(xcellViewModel, subtitle) takeUntil:self.rac_prepareForReuseSignal];
    RAC(self.priceAndPubLabel,text) = [RACObserve(xcellViewModel, priceAndPubdate) takeUntil:self.rac_prepareForReuseSignal];
}

@end
