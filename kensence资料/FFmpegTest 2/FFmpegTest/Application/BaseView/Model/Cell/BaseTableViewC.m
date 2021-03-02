//
//  BaseTableViewC.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/7/26.
//  Copyright © 2016年 times. All rights reserved.
//

#import "BaseTableViewC.h"
#import "Masonry.h"

@implementation BaseTableViewC

- (void)awakeFromNib {
    // Initialization code
}


- (void)layoutSubviews
{
    
    self.baseNemeLabel.frame = CGRectMake(0, 0, self.contentView.frame.size.width, 30);
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseNemeLabel.mas_bottom).with.offset(1);
        make.left.equalTo(self.baseNemeLabel.mas_left).with.offset(1);
//        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-1);
        make.right.equalTo(self.contentView.mas_right).with.offset(-1);
        make.height.mas_equalTo(self.contentView.frame.size.height - self.baseNemeLabel.frame.size.height);
    }];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
