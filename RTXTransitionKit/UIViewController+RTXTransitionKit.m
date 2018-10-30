//
//  UIViewController+RTXTransitionKit.m
//  RTXTransitionKit <https://github.com/menttofly/RTXTransitionKit>
//
//  Created by menttofly on 2018/9/15.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import "UIViewController+RTXTransitionKit.h"
#import <objc/runtime.h>

@implementation UIViewController (RTXTransitionKit)

#pragma mark - Attributes

- (void)setRtx_pushTransitionDisabled:(BOOL)rtx_pushTransitionDisabled {
    objc_setAssociatedObject(self, @selector(rtx_pushTransitionDisabled), @(rtx_pushTransitionDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)rtx_pushTransitionDisabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setRtx_popTransitionDisabled:(BOOL)rtx_popTransitionDisabled {
    objc_setAssociatedObject(self, @selector(rtx_popTransitionDisabled), @(rtx_popTransitionDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)rtx_popTransitionDisabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setRtx_interactivePopDisabled:(BOOL)rtx_interactivePopDisabled {
    objc_setAssociatedObject(self, @selector(rtx_interactivePopDisabled), @(rtx_interactivePopDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)rtx_interactivePopDisabled {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setRtx_isTransitionViewController:(BOOL)rtx_isTransitionViewController {
    objc_setAssociatedObject(self, @selector(rtx_isTransitionViewController), @(rtx_isTransitionViewController), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)rtx_isTransitionViewController {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setRtx_gesture:(UIScreenEdgePanGestureRecognizer *)rtx_gesture {
    objc_setAssociatedObject(self, @selector(rtx_gesture), rtx_gesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIScreenEdgePanGestureRecognizer *)rtx_gesture {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)rtx_processMultiGestureRecognizer {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wcompare-distinct-pointer-types"
    if (self.navigationController.delegate != self.navigationController) {
        self.navigationController.delegate = (id<UINavigationControllerDelegate>)self.navigationController;
    }
#pragma clang diagnostic pop
    
    BOOL isRootVC = self.navigationController.viewControllers.firstObject == self;
    if (isRootVC) {
        self.navigationController.rtx_gesture.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    } else {
        /// Maybe it's a child view controller.
        if (!self.rtx_isTransitionViewController) return;
        
        if (self.rtx_popTransitionDisabled) {
            self.navigationController.rtx_gesture.enabled = NO;
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self.navigationController;
        } else {
            self.navigationController.rtx_gesture.enabled = YES;
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

@end
