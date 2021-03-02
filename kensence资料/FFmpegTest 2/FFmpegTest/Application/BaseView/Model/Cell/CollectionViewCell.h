//
//  CollectionViewCell.h
//  N-mix
//
//  Created by chenq@kensence.com on 16/7/27.
//  Copyright © 2016年 times. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *ItemLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ItemImageView;

@end
