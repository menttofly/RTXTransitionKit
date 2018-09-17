//
//  UIViewController+RTXTransitionKit.h
//  RTXTransitionKit <https://github.com/menttofly/RTXTransitionKit>
//
//  Created by menttofly on 2018/9/15.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RTXTransitionKit)

@property (nonatomic) BOOL rtx_pushTransitionDisabled;  ///< Determine custom push transition disabled or not.
@property (nonatomic) BOOL rtx_popTransitionDisabled;  ///< Determine custom pop transition disabled or not.
@property (nonatomic) BOOL rtx_interactivePopDisabled;  ///< Determine interactive pop gesture enable or not.
@property (nonatomic) BOOL rtx_isTransitionViewController;  ///< Whether is transition view controller or not.
@property (nonatomic) UIScreenEdgePanGestureRecognizer *rtx_gesture;  /// Custome edge interacive pop gesture.

/// If your project contain 'FDFullscreenPopGesture', you have to handle it by using this in viewDidAppear.
- (void)rtx_processMultiGestureRecognizer;

@end
