//
//  BookViewCell.m
//  RAC的学习
//
//  Created by xyj on 2018/1/25.
//  Copyright © 2018年 xyj. All rights reserved.
//

#import "BookViewCell.h"
#import "Book.h"
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

-(void)setBookModel:(Book *)bookModel{
    _bookModel = bookModel;
    _titleLabel.text = bookModel.title;
    _subtitleLabel.text = bookModel.subtitle;
    _priceAndPubLabel.text = bookModel.priceAndPubdate;
}

@end
