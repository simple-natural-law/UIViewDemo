//
//  ReplaceTransitionViewController.m
//  UIViewDemo
//
//  Created by 讯心科技 on 2017/11/29.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "ReplaceTransitionViewController.h"

@interface ReplaceTransitionViewController ()
{
    BOOL _isDisplayingViewA;
}
@property (nonatomic, strong) UIView *viewA;

@property (nonatomic, strong) UIView *viewB;

@end

@implementation ReplaceTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 30);
    [button setTitle:@"切换" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.view addSubview:self.viewA];
    
    _isDisplayingViewA = YES;
}

- (void)changeAction
{
    [UIView transitionFromView:(_isDisplayingViewA ? self.viewA : self.viewB) toView:(_isDisplayingViewA ? self.viewB : self.viewA) duration:1.0 options:(_isDisplayingViewA ? UIViewAnimationOptionTransitionFlipFromRight : UIViewAnimationOptionTransitionFlipFromLeft) completion:^(BOOL finished) {
        
        if (finished)
        {
            _isDisplayingViewA = !_isDisplayingViewA;
        }
    }];
}



- (UIView *)viewA
{
    if (_viewA == nil)
    {
        _viewA = [[UIView alloc] initWithFrame:self.view.bounds];
        _viewA.backgroundColor = [UIColor greenColor];
    }
    return _viewA;
}

- (UIView *)viewB
{
    if (_viewB == nil)
    {
        _viewB = [[UIView alloc] initWithFrame:self.view.bounds];
        _viewB.backgroundColor = [UIColor orangeColor];
    }
    return _viewB;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
