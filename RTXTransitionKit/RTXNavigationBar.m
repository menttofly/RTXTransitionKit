//
//  RTXNavigationBar.m
//  RTXTransitionKitDemo
//
//  Created by menttofly on 2018/9/16.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import "RTXNavigationBar.h"

@implementation RTXNavigationBar

#pragma mark - Initializer

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _defaults];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _defaults];
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_includeStatusBar) {
        /// Insure _UIBarBackground behavior similar to the UINavigationBar associated with UINavigationController
        CGRect statusBarFrame = UIApplication.sharedApplication.statusBarFrame;
        CGFloat height = statusBarFrame.size.height;
        
        if (height == 0) height = 20;
        
        UIView *barBackground = self.subviews.firstObject;
        CGRect frame = barBackground.frame;
        frame.size.height += height;
        frame.origin.y -= height;
        barBackground.frame = frame;
    }
}

#pragma mark - Private

- (void)_defaults {
    _includeStatusBar = YES;
    CGFloat pix = 1.f / UIScreen.mainScreen.scale;
    UIImage *shadowImage = [self.class _imageWithColor:UIColor.lightGrayColor size:CGSizeMake(pix, pix)];
    [self setShadowImage:shadowImage];
}

+ (UIImage *)_imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - Public

- (void)setIncludeStatusBar:(BOOL)includeStatusBar {
    _includeStatusBar = includeStatusBar;
    CGRect frame = self.frame;
    frame.origin.y = includeStatusBar ? 20 : 0;
    self.frame = frame;
}

+ (RTXNavigationBar *)isolatedNavigationBar {
    
    RTXNavigationBar *navigationBar = [[RTXNavigationBar alloc] init];
    navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [navigationBar relayout];
    
    /// Default attributes of the unique navigation bar.
    navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : UIColor.darkTextColor,
                                          NSFontAttributeName : [UIFont systemFontOfSize:16]};
    navigationBar.barTintColor = UIColor.whiteColor;
    navigationBar.translucent = NO;
    
    /// UINavigationItem of navigation bar.
    UINavigationItem *navigationItem = [[UINavigationItem alloc] init];
    navigationItem.hidesBackButton = NO;
    navigationBar.items = @[navigationItem];
    
    return navigationBar;
}

- (void)relayout {
    CGRect statusBarFrame = UIApplication.sharedApplication.statusBarFrame;
    CGFloat statusBarHeight = statusBarFrame.size.height;
    CGFloat statusBarWidth = statusBarFrame.size.width;
    if (statusBarHeight == 0) statusBarHeight = 20;
    if (statusBarWidth == 0) statusBarWidth = UIScreen.mainScreen.bounds.size.width;
    
    if (_includeStatusBar) {
        self.frame = CGRectMake(0, statusBarHeight, statusBarWidth, 44);
    } else {
        self.frame = CGRectMake(0, 0, statusBarWidth, 44);
    }
}

@end
