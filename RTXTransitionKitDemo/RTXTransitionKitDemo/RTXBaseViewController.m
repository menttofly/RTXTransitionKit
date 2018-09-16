//
//  RTXBaseViewController.m
//  RTXTransitionKitDemo
//
//  Created by menttofly on 2018/9/16.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import "RTXBaseViewController.h"

@interface RTXBaseViewController ()

@end

@implementation RTXBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [self _randomColor];
    self.navigationBar.barTintColor = [self _randomColor];
    
    [self _setBackItem];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(_pushAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)_setBackItem {
    if (self.navigationController.viewControllers.firstObject != self) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 40, 40);
        [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(_popAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = backItem;
    } else {
        self.title = @"RootVC";
    }
}

#pragma mark - Event Response

- (void)_pushAction:(UIButton *)sender {
    RTXBaseViewController *vc = RTXBaseViewController.new;
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = @"VC";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)_popAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIColor *)_randomColor {
    UInt8 r = arc4random() % 256;
    UInt8 g = arc4random() % 256;
    UInt8 b = arc4random() % 256;
    return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1];
}

@end
