//
//  UIColor+Custom.m
//  AlfrescoApp
//
//  Created by Tauseef Mughal on 16/01/2014.
//  Copyright (c) 2014 Alfresco. All rights reserved.
//

#import "UIColor+Custom.h"

@implementation UIColor (Custom)

+ (UIColor *)mainMenuBackgroundColor
{
    return [UIColor colorWithRed:(CGFloat)53.0/255.0 green:(CGFloat)53.0/255.0 blue:(CGFloat)55.0/255.0 alpha:1.0];
}

+ (UIColor *)mainMenuLabelColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)appTintColor
{
    return [UIColor colorWithRed:(CGFloat)56.0/255.0 green:(CGFloat)170.0/255.0 blue:(CGFloat)218.0/255.0 alpha:1.0];
}

+ (UIColor *)documentActionsTintColor
{
    return [UIColor colorWithRed:(CGFloat)53.0/255.0 green:(CGFloat)53.0/255.0 blue:(CGFloat)55.0/255.0 alpha:1.0];
}

+ (UIColor *)borderGreyColor
{
    return [UIColor colorWithRed:(CGFloat)212.0/255.0 green:(CGFloat)212.0/255.0 blue:212.0/255.0 alpha:1.0f];
}

+ (UIColor *)highWorkflowPriorityColor
{
    return [UIColor colorWithRed:(CGFloat)253.0/255.0 green:(CGFloat)137.0/255.0 blue:(CGFloat)156.0/255.0 alpha:1.0];
}

+ (UIColor *)mediumWorkflowPriorityColor
{
    return [UIColor colorWithRed:(CGFloat)56.0/255.0 green:(CGFloat)170.0/255.0 blue:(CGFloat)218.0/255.0 alpha:1.0];
}

+ (UIColor *)lowWorkflowPriorityColor
{
    return [UIColor colorWithRed:(CGFloat)193.0/255.0 green:(CGFloat)192.0/255.0 blue:(CGFloat)192.0/255.0 alpha:1.0];
}

+ (UIColor *)systemNoticeBlue
{
    return [UIColor colorWithRed:(CGFloat)56.0/255.0 green:(CGFloat)170.0/255.0 blue:(CGFloat)218.0/255.0 alpha:1.0];
}

+ (UIColor *)systemNoticeRed
{
    return [UIColor redColor];
}

+ (UIColor *)systemNoticeYellow
{
    return [UIColor yellowColor];
}

@end
