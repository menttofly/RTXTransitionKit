//
//  RTXNavigationBar.h
//  RTXTransitionKit <https://github.com/menttofly/RTXTransitionKit>
//
//  Created by menttofly on 2018/9/16.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RTXNavigationBar : UINavigationBar

@property (nonatomic) BOOL includeStatusBar;
+ (RTXNavigationBar *)isolatedNavigationBar;
- (void)relayout;

@end
