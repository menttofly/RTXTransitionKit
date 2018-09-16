//
//  RTXViewController.h
//  RTXTransitionKitDemo
//
//  Created by menttofly on 2018/9/16.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTXNavigationBar.h"

@interface RTXViewController : UIViewController

@property (nonatomic, readonly) RTXNavigationBar *navigationBar; ///< The navigation bar held by every single view controller itself.
@property (nonatomic) BOOL showNavigationBar;  ///< Use this to decide show navigation bar or not.
@property (nonatomic) BOOL preferNavigationItem;  ///< Prefer to use custome navigation item rather than override.
@property (nonatomic) UINavigationItem *rtx_navigationItem;

@end
