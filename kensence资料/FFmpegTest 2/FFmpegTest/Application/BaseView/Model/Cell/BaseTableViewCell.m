//
//  BaseTableViewCell.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/5/17.
//  Copyright © 2016年 times. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "Masonry.h"

@implementation BaseTableViewCell

- (void)setModel:(TViewModel *)model
{
    self.baseNemeLabel.text = model.name;
    self.baseNemeLabel.textColor = WhiteColor;
    self.baseNemeLabel.backgroundColor = [UIColor colorWithRed:25/255.0 green:25/255.0 blue:25/255.0 alpha:1];
 

}

- (void)layoutSubviews
{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseNemeLabel.mas_bottom).with.offset(1);
        make.left.equalTo(self.baseNemeLabel.mas_left).with.offset(1);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-1);
        make.right.equalTo(self.contentView.mas_right).with.offset(-1);
    }];
}




- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
