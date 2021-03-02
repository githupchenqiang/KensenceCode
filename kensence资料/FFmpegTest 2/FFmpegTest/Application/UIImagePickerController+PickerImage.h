//
//  UIImagePickerController+PickerImage.h
//  N-mix
//
//  Created by chenq@kensence.com on 16/8/2.
//  Copyright © 2016年 times. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImagePickerController (PickerImage)
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation;
- (BOOL)shouldAutorotate;
- (NSUInteger) supportedInterfaceOrientations;



@end
