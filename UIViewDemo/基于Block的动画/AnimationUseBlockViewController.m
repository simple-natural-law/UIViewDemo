//
//  AnimationUseBlockViewController.m
//  UIViewDemo
//
//  Created by 讯心科技 on 2017/11/28.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "AnimationUseBlockViewController.h"

@interface AnimationUseBlockViewController ()

@property (weak, nonatomic) IBOutlet UILabel *targetView;

@end

@implementation AnimationUseBlockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [touches.allObjects.lastObject locationInView:self.view];
    
    [UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.targetView.center = location;
        
        [UIView animateWithDuration:0.2 delay:0.2 options:UIViewAnimationOptionOverrideInheritedCurve | UIViewAnimationOptionOverrideInheritedDuration | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [UIView setAnimationRepeatCount:1];
            
            self.targetView.alpha = 0.5;
            
        } completion:^(BOOL finished) {
            
            if (finished)
            {
                self.targetView.alpha = 1.0;
            }
        }];
        
    } completion:^(BOOL finished) {
        
        if (finished)
        {
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse animations:^{
                
                [UIView setAnimationRepeatCount:1];
                
                self.targetView.transform = CGAffineTransformMakeScale(1.2, 1.2);
                
            } completion:^(BOOL finished) {
                
                if (finished)
                {
                    self.targetView.transform = CGAffineTransformIdentity;
                }
            }];
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
