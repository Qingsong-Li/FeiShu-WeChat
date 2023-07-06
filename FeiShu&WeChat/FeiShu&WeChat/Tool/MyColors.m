//
//  MyColors.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/6/29.
//

#import "MyColors.h"

@interface MyColors ()


@end

@implementation MyColors

+ (UIColor *)getRandomColor{
    UIColor *color1 = [UIColor colorWithRed:244/255.0 green:208/255.0 blue:0/255.0 alpha:1];
    UIColor *color2 = [UIColor colorWithRed:149/255.0 green:0/255.0 blue:234/255.0 alpha:1];
    UIColor *color3 = [UIColor colorWithRed:255/255.0 green:140/255.0 blue:0/255.0 alpha:1];
    UIColor *color4 = [UIColor colorWithRed:107/255.0 green:194/255.0 blue:53/255.0 alpha:1];
    UIColor *color5 = [UIColor colorWithRed:0/255.0 green:47/255.0 blue:167/255.0 alpha:1];
    UIColor *color6 = [UIColor colorWithRed:213/255.0 green:26/255.0 blue:33/255.0 alpha:1];
    NSMutableArray *colorsArray = [NSMutableArray arrayWithObjects:color1, color2, color3, color4,color5,color6, nil];
    NSUInteger randomIndex = arc4random_uniform((uint32_t)colorsArray.count);
    UIColor *randomColor = colorsArray[randomIndex];
    return randomColor;
}

@end
