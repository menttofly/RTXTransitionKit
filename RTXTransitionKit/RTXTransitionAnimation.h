//
//  RTXTransitionAnimation.h
//  RTXTransitionKit <https://github.com/menttofly/RTXTransitionKit>
//
//  Created by menttofly on 2018/9/16.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,RTXTransitionStyle) {
    RTXTransitionStylePush = 0,
    RTXTransitionStylePop = 1,
};

@interface RTXTransitionAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) RTXTransitionStyle style;  ///< The current transition stlyle.
@property (nonatomic) BOOL pushFromRoot;  ///< Indicator whether push from root view controller.
@property (nonatomic) BOOL popToRoot;  ///< Indicator whether pop to root view controller.
@property (nonatomic) BOOL rtx_isInteractive;  /// Process below iOS 10.

/// Fetch transition object.
+ (instancetype)transitionAnimation;

@end
