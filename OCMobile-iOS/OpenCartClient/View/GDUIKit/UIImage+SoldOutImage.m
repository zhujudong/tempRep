//
//  UIImage+SoldOutImage.m
//  afterschoollol
//
//  Created by Sam Chen on 04/08/2017.
//  Copyright © 2017 opencart.cn. All rights reserved.
//

#import "UIImage+SoldOutImage.h"

@implementation UIImage (SoldOutImage)

-(UIImage *)drawImageWithSoldOutOverlay:(UIImage *)sourceImage {
    UIImage *soldOutImage = [UIImage imageNamed:@"product-sold-out"];
    CGRect soldOutImageRect = CGRectMake((sourceImage.size.width - soldOutImage.size.width) / 2, (sourceImage.size.height - soldOutImage.size.width) / 2, soldOutImage.size.width, soldOutImage.size.width);

    UIGraphicsBeginImageContextWithOptions(sourceImage.size, NO, 0.0);
    [sourceImage drawInRect:CGRectMake(0.0, 0.0, sourceImage.size.width, sourceImage.size.height)];
    [soldOutImage drawInRect:soldOutImageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
