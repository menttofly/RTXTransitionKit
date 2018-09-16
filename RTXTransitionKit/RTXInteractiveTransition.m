//
//  RTXInteractiveTransition.m
//  RTXTransitionKitDemo
//
//  Created by menttofly on 2018/9/16.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import "RTXInteractiveTransition.h"
#import "UIViewController+RTXTransitionKit.h"

@interface RTXInteractiveTransition () <UIGestureRecognizerDelegate>

@property (nonatomic) BOOL shouldEndInteraction;  ///< Determine interaction should end.
@property (nonatomic, weak) __kindof UIViewController *targetVC;  ///< View controller for interaction.

@end

@implementation RTXInteractiveTransition

- (void)wireToViewController:(UIViewController *)viewController {
    _targetVC = viewController;
    [self _prepareInView:viewController.view];
}

- (void)_prepareInView:(UIView *)view {
    UIScreenEdgePanGestureRecognizer *gesture = _targetVC.rtx_gesture;
    if (gesture) {
        [view removeGestureRecognizer:gesture];
        gesture = nil;
    }
    gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(_handleGesture:)];
    gesture.delegate = self;
    gesture.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:gesture];
    
    _targetVC.rtx_gesture = gesture;
}

- (CGFloat)completionSpeed {
    return 1;
}

/**
 Important! Ensure transition behavior same as system pop gesture.
 */
- (UIViewAnimationCurve)completionCurve {
    return _interactionProcessing ? UIViewAnimationCurveLinear : UIViewAnimationCurveEaseOut;
}

- (void)_handleGesture:(UIScreenEdgePanGestureRecognizer *)gestureRecognizer {
    
    CGPoint velocity = [gestureRecognizer velocityInView:gestureRecognizer.view];
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    UINavigationController *navigationController = self.targetVC;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.interactionProcessing = YES;
            [navigationController popViewControllerAnimated:YES];
            break;
        case UIGestureRecognizerStateChanged:
            if (_interactionProcessing) {
                /// compute the current position
                CGFloat width = _targetVC.view.frame.size.width;
                CGFloat fraction = translation.x / (float)width;
                fraction = fminf(fmaxf(fraction, 0.0), 1.0);
                
                /// Totally similar to system behavior.
                if (fraction >= 0.1 && velocity.x > 200) {
                    _shouldEndInteraction = YES;
                } else {
                    _shouldEndInteraction = (fraction >= 0.5);
                }
                if (fraction >= 1.0) fraction = 0.99;
                [self updateInteractiveTransition:fraction];
            }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
            if (_interactionProcessing) {
                self.interactionProcessing = NO;
                if (!_shouldEndInteraction || gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
                    [self cancelInteractiveTransition];
                } else {
                    [self finishInteractiveTransition];
                }
            }
            break;
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    /// Ensure the pop gesture has the highest priority.
    UIScreenEdgePanGestureRecognizer *gesture = _targetVC.rtx_gesture;
    UIGestureRecognizer *systemGesture = _targetVC.navigationController.interactivePopGestureRecognizer;
    return (gestureRecognizer == gesture || gestureRecognizer == systemGesture);
}

@end
