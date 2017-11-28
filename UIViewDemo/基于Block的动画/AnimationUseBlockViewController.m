//
//  AnimationUseBlockViewController.m
//  UIViewDemo
//
//  Created by 讯心科技 on 2017/11/28.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "AnimationUseBlockViewController.h"

@interface AnimationUseBlockViewController ()

@property (weak, nonatomic) IBOutlet UIView *targetView;

@end

@implementation AnimationUseBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    CGPoint location = [touches.allObjects.lastObject locationInView:self.view];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.targetView.center = location;
        
    } completion:^(BOOL finished) {
        
       
        if (finished)
        {
            
        }
    }];
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
