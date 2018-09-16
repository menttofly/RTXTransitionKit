//
//  RTXViewController.m
//  RTXTransitionKitDemo
//
//  Created by menttofly on 2018/9/16.
//  Copyright © 2018年 menttofly. All rights reserved.
//

#import "RTXViewController.h"
#import "UIViewController+RTXTransitionKit.h"

@interface RTXViewController () <UINavigationBarDelegate>

/// Rewrite
@property (nonatomic, readwrite) RTXNavigationBar *navigationBar;

@end

@implementation RTXViewController

#pragma mark - Initializer

- (instancetype)init {
    return [self initWithNibName:nil bundle:nil];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _showNavigationBar = YES;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _showNavigationBar = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self navigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_navigationBar && !_navigationBar.superview) {
        [self.view addSubview:_navigationBar];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self rtx_processMultiGestureRecognizer];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if (_navigationBar) [self.view bringSubviewToFront:_navigationBar];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (_navigationBar) [_navigationBar relayout];
}

#pragma mark - Setter & Getter

- (RTXNavigationBar *)navigationBar {
    if (!_navigationBar && _showNavigationBar) {
        _navigationBar = [RTXNavigationBar isolatedNavigationBar];
        _navigationBar.delegate = self;
        _navigationBar.topItem.title = self.title;
        [self.view addSubview:_navigationBar];
    }
    return _navigationBar;
}

- (UINavigationItem *)navigationItem {
    if (self.viewLoaded && !self.preferNavigationItem) {
        return self.navigationBar.topItem;
    }
    /// Do not return nil, because even you hide the system naviation bar, it may still call navigationItem inside.
    return [super navigationItem];
}

- (UINavigationItem *)rtx_navigationItem {
    if (self.viewLoaded) {
        return self.navigationBar.topItem;
    }
    return UINavigationItem.new;
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    /// If view not load yet, simply call super setTitle:
    if (self.isViewLoaded) self.navigationBar.topItem.title = title;
}

#pragma mark - UINavigationBarDelegate

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar {
    return UIBarPositionTop;
}

- (void)setShowNavigationBar:(BOOL)showNavigationBar {
    _showNavigationBar = showNavigationBar;
    if (showNavigationBar && self.isViewLoaded) {
        [self navigationBar];
    } else {
        [_navigationBar removeFromSuperview];
        _navigationBar = nil;
    }
}

@end
