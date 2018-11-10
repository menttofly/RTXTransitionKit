//
//  UIViewController+RTXTransitionKit.h
//  RTXTransitionKit <https://github.com/menttofly/RTXTransitionKit>
//
//  Created by menttofly on 2018/9/15.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IPHONEXSERIES \
({ \
    BOOL IPhoneXSeries = NO; \
    if (@available(iOS 11, *)) { \
        UIWindow *keyWindow = UIApplication.sharedApplication.keyWindow; \
        CGFloat bottomSafeInset = keyWindow.safeAreaInsets.bottom; \
        IPhoneXSeries = bottomSafeInset == 34.f || bottomSafeInset == 21.f; \
    } \
    (IPhoneXSeries); \
}) \

#define RTXSafeAreaTop \
({ \
    CGFloat topAreaHeight = RTXNavigationBarHeight; \
    if (IPHONEXSERIES) { \
        topAreaHeight += RTXIPhoneXStatusBarHeight; \
    } else { \
        topAreaHeight += RTXRegularStatusBarHeight; \
    } \
    (topAreaHeight); \
}) \

static const CGFloat RTXRegularStatusBarHeight = 20.f;
static const CGFloat RTXHotSpotStatusBarHeight = 40.f;
static const CGFloat RTXIPhoneXStatusBarHeight = 44.f;
static const CGFloat RTXNavigationBarHeight = 44.f;

@interface UIViewController (RTXTransitionKit)

@property (nonatomic) BOOL rtx_pushTransitionDisabled;  ///< Determine custom push transition disabled or not.
@property (nonatomic) BOOL rtx_popTransitionDisabled;  ///< Determine custom pop transition disabled or not.
@property (nonatomic) BOOL rtx_interactivePopDisabled;  ///< Determine interactive pop gesture enable or not.
@property (nonatomic) BOOL rtx_isTransitionViewController;  ///< Whether is transition view controller or not.
@property (nonatomic, readonly) CGRect rtx_safeAreaFrame;  ///< Safe area for view controller.
@property (nonatomic) UIScreenEdgePanGestureRecognizer *rtx_gesture;  /// Custome edge interacive pop gesture.

/// If your project contain 'FDFullscreenPopGesture', you have to handle it by using this in viewDidAppear.
- (void)rtx_processMultiGestureRecognizer;

@end
