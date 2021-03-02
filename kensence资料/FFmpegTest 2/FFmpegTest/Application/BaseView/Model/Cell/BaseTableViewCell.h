//
//  BaseTableViewCell.h
//  N-mix
//
//  Created by chenq@kensence.com on 16/5/17.
//  Copyright © 2016年 times. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TViewModel.h"
@interface BaseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *baseNemeLabel;
@property (nonatomic ,strong)TViewModel *model;

@end
