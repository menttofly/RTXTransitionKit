//
//  RTXTabBarController.m
//  RTXTransitionKitDemo
//
//  Created by menttofly on 2018/9/16.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import "RTXTabBarController.h"
#import "RTXBaseViewController.h"
#import "RTXNavigationController.h"

@interface RTXTabBarController ()

@end

@implementation RTXTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBar.translucent = NO;
    [UITabBar.appearance setShadowImage:UIImage.new];
    
    RTXNavigationController *nav1 = [[RTXNavigationController alloc] initWithRootViewController:RTXBaseViewController.new];
    nav1.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostRecent tag:0];
    [nav1.tabBarItem setBadgeValue:@"3"];
    
    RTXNavigationController *nav2 = [[RTXNavigationController alloc] initWithRootViewController:RTXBaseViewController.new];
    nav2.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:1];
    
    RTXNavigationController *nav3 = [[RTXNavigationController alloc] initWithRootViewController:RTXBaseViewController.new];
    nav3.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:2];
    
    self.viewControllers = @[nav1, nav2, nav3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
