//
//  AutoresizingMaskViewController.m
//  UIViewDemo
//
//  Created by 讯心科技 on 2017/11/24.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "AutoresizingMaskViewController.h"

@interface AutoresizingMaskViewController ()

@property (weak, nonatomic) IBOutlet UILabel *target;

@end

@implementation AutoresizingMaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 自动调整宽度，以保证左边距和右边距不变
    self.target.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    
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
