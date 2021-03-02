//
//  UIImagePickerController+PickerImage.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/8/2.
//  Copyright © 2016年 times. All rights reserved.
//

#import "UIImagePickerController+PickerImage.h"

@implementation UIImagePickerController (PickerImage)

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return UIInterfaceOrientationIsLandscape( interfaceOrientation );
}
-(BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger) supportedInterfaceOrientations{
#ifdef __IPHONE_6_0
    return UIInterfaceOrientationMaskAllButUpsideDown;
    //return UIInterfaceOrientationMaskLandscape;
#endif
}
@end
