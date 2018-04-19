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
    // Initialization code
}
-(void)setCellViewModel:(ZHBooklistCellViewModel *)cellViewModel{
    _cellViewModel = cellViewModel;
    _titleLabel.text = cellViewModel.title;
    _subtitleLabel.text = cellViewModel.subtitle;
    _priceAndPubLabel.text = cellViewModel.priceAndPubdate;
}


@end
