//
//  RTXTransitionAnimation.m
//  RTXTransitionKitDemo
//
//  Created by menttofly on 2018/9/16.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import "RTXTransitionAnimation.h"
#import <objc/runtime.h>

static void *RTXSnapshotViewKey;
static const NSTimeInterval RTXPushTransitionDuration = 0.25;
static const NSTimeInterval RTXPopTransitionDuration = 0.25;

@implementation RTXTransitionAnimation

- (instancetype)init {
    if (self = [super init]) {
        _style = RTXTransitionStylePush;
    }
    return self;
}

+ (instancetype)transitionAnimation {
    RTXTransitionAnimation *transitionAnimation = [[RTXTransitionAnimation alloc] init];
    return transitionAnimation;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return _style == RTXTransitionStylePush ? RTXPushTransitionDuration : RTXPopTransitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    [self _transtionAnimation:transitionContext reverse:_style == RTXTransitionStylePop];
}

#pragma mark - Private

- (void)_applyAntiAliasing:(BOOL)should forView:(UIView *)view {
    if (should) {
        /// process anti-aliasing on layer.
        view.layer.edgeAntialiasingMask = kCALayerTopEdge | kCALayerBottomEdge;
        view.layer.allowsEdgeAntialiasing = YES;
    } else {
        view.layer.edgeAntialiasingMask = kNilOptions;
        view.layer.allowsEdgeAntialiasing = NO;
    }
}

- (void)_applyTransform:(UIView *)view {
    
    CATransform3D transform3D = CATransform3DIdentity;
    transform3D.m34 = -1.0 / 2000.0;
    transform3D = CATransform3DScale(transform3D, 1, 0.99, 1);
    transform3D = CATransform3DRotate(transform3D, -5 * M_PI / 180.f, 0, 1, 0);
    view.layer.transform = transform3D;
    view.alpha = 0.8f;
}

- (void)_revertTransform:(UIView *)view {
    view.layer.transform = CATransform3DIdentity;
    view.alpha = 1.0;
}

- (void)_processTabBar:(UIViewController *)vc view:(UIView *)view frame:(CGRect)frame {
    if (!self.pushFromRoot) return;
    
    UIView *snapshot = [vc.tabBarController.tabBar snapshotViewAfterScreenUpdates:NO];
    snapshot.frame = CGRectMake(0, frame.size.height - snapshot.frame.size.height, frame.size.width, snapshot.frame.size.height);
    [view addSubview:snapshot];
    objc_setAssociatedObject(view, &RTXSnapshotViewKey, snapshot, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)_transtionAnimation:(nullable id <UIViewControllerContextTransitioning>)transitionContext reverse:(BOOL)reverse{
    if (!transitionContext) return;
    
    /// Fetch view controller from transition context.
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    /// Fetch view from transition context.
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = transitionContext.containerView;
    
    CGRect initFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
    
    /// Process from view and to view.
    if (reverse) {
        toView.frame = initFrame;
        [containerView addSubview:toView];
        [containerView sendSubviewToBack:toView];
        [self _applyAntiAliasing:YES forView:toView];
        [self _applyTransform:toView];
    } else {
        [self _processTabBar:fromVC view:fromView frame:finalFrame];
        
        toView.frame = CGRectOffset(finalFrame, finalFrame.size.width, 0);
        [containerView addSubview:toView];
        fromView.layer.anchorPoint = CGPointMake(1, 0.5);
        fromView.frame = finalFrame;
    }
    fromVC.tabBarController.tabBar.hidden = YES;
    
    /// Important! Ensure transition by interactive gesture timing function is linear!
    UIViewAnimationOptions option;
    if (@available(ios 10.0, *)) {
        option = transitionContext.isInteractive ? UIViewAnimationOptionCurveLinear : UIViewAnimationOptionCurveEaseOut;
    } else {
        option = self.rtx_isInteractive ? UIViewAnimationOptionCurveLinear : UIViewAnimationOptionCurveEaseOut;
    }
    
    /// Start transition animation.
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        if (reverse) {
            fromView.frame = CGRectOffset(initFrame, initFrame.size.width, 0);
            [self _revertTransform:toView];
        } else {
            toView.frame = finalFrame;
            [self _applyTransform:fromView];
        }
    } completion:^(BOOL finished) {
        if (reverse) {
            if (transitionContext.transitionWasCancelled) {
                [self _applyAntiAliasing:NO forView:toView];
                [self _revertTransform:toView];
            } else {
                [self _applyAntiAliasing:NO forView:toView];
                toVC.tabBarController.tabBar.hidden = !self.popToRoot;
                UIView *snapshot = objc_getAssociatedObject(toView, &RTXSnapshotViewKey);
                if (snapshot) [snapshot removeFromSuperview];
            }
        } else {
            [self _revertTransform:fromView];
        }
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

@end
