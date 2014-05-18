//
//  UIColor+HexColor.h
//  BellyTask
//
//  Created by Nan Wang on 5/18/14.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (HexColor)

+ (UIColor*)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;
+ (UIColor*)colorWithHex:(NSString*)hex alpha:(CGFloat)alpha;

@end
