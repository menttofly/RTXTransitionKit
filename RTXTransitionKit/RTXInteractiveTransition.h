//
//  RTXInteractiveTransition.h
//  RTXTransitionKit <https://github.com/menttofly/RTXTransitionKit>
//
//  Created by menttofly on 2018/9/16.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTXInteractiveTransition : UIPercentDrivenInteractiveTransition

/// Indicates whether an interactive transition is in progress.
@property (nonatomic) BOOL interactionProcessing;

/// Wire interactive transition to the view controller.
- (void)wireToViewController:(UIViewController *)viewController;

@end
