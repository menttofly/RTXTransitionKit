//
//  RTXNavigationController.m
//  RTXTransitionKitDemo
//
//  Created by menttofly on 2018/9/16.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import "RTXNavigationController.h"
#import "UIViewController+RTXTransitionKit.h"
#import "RTXInteractiveTransition.h"
#import "RTXTransitionAnimation.h"
#import "RTXViewController.h"

@interface RTXNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) RTXTransitionAnimation *transitionAnimation;  ///< Transition for animation.
@property (nonatomic) RTXInteractiveTransition *rtx_interactiveTransition;  ///< Interactive transititon.

@end

@implementation RTXNavigationController

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"rtx_interactiveTransition.interactionProcessing"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.delegate = self;
    [self setNavigationBarHidden:YES animated:NO];
    [self.rtx_interactiveTransition wireToViewController:self];
    [self addObserver:self forKeyPath:@"rtx_interactiveTransition.interactionProcessing" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_setup {
    _transitionAnimation = [[RTXTransitionAnimation alloc] init];
    _rtx_interactiveTransition = [[RTXInteractiveTransition alloc] init];
}

- (RTXTransitionAnimation *)transitionAnimation {
    if (!_transitionAnimation) {
        _transitionAnimation = RTXTransitionAnimation.new;
    }
    return _transitionAnimation;
}

- (RTXInteractiveTransition *)rtx_interactiveTransition {
    if (!_rtx_interactiveTransition) {
        _rtx_interactiveTransition = RTXInteractiveTransition.new;
    }
    return _rtx_interactiveTransition;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (!self.isViewLoaded) return;
    if ([keyPath isEqualToString:@"rtx_interactiveTransition.interactionProcessing"]) {
        self.transitionAnimation.rtx_isInteractive = self.rtx_interactiveTransition.interactionProcessing;
    }
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated {
    viewController.rtx_isTransitionViewController = YES;
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(nonnull UIViewController *)viewController animated:(BOOL)animated {
    
    BOOL isRootVC = viewController == navigationController.viewControllers.firstObject;
    if (![viewController isKindOfClass:RTXViewController.class]) {
        navigationController.rtx_gesture.enabled = NO;
        self.interactivePopGestureRecognizer.delegate = self;
        self.interactivePopGestureRecognizer.enabled = !isRootVC;
    } else {
        [self rtx_processMultiGestureRecognizer];
    }
}

#pragma mark - Transition

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    BOOL from = [fromVC isKindOfClass:RTXViewController.class];
    BOOL to = [toVC isKindOfClass:RTXViewController.class];
    if (!(from && to)) return nil;
    
    if (operation == UINavigationControllerOperationPush) {
        if (fromVC.rtx_pushTransitionDisabled) return nil;
        
        BOOL pushFromRoot = navigationController.viewControllers.firstObject == fromVC;
        self.transitionAnimation.pushFromRoot = pushFromRoot;
        self.transitionAnimation.style = RTXTransitionStylePush;
        return self.transitionAnimation ?: nil;
    } else if (operation == UINavigationControllerOperationPop) {
        if (fromVC.rtx_popTransitionDisabled) return nil;
        
        BOOL popToRoot = navigationController.viewControllers.firstObject == toVC;
        self.transitionAnimation.popToRoot = popToRoot;
        self.transitionAnimation.style = RTXTransitionStylePop;
        return self.transitionAnimation ?: nil;
    } else {
        return nil;
    }
}

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    if ([animationController isKindOfClass:RTXTransitionAnimation.class]) {
        return self.rtx_interactiveTransition.interactionProcessing ? self.rtx_interactiveTransition : nil;
    }
    return nil;
}

@end
