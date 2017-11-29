//
//  AnimationUseBeginCommitViewController.m
//  UIViewDemo
//
//  Created by 讯心科技 on 2017/11/29.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "AnimationUseBeginCommitViewController.h"

@interface AnimationUseBeginCommitViewController ()

@property (weak, nonatomic) IBOutlet UILabel *targetLabel;

@end

@implementation AnimationUseBeginCommitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [touches.allObjects.lastObject locationInView:self.view];
    
    [UIView beginAnimations:@"animationA" context:nil];
    
    [UIView setAnimationDuration:0.6];
    
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    self.targetLabel.center = location;
    
    [UIView beginAnimations:@"animationB" context:nil];
    
    [UIView setAnimationDelay:0.2];
    
    [UIView setAnimationDuration:0.2];
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationRepeatCount:1];
    
    [UIView setAnimationRepeatAutoreverses:YES];
    
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    self.targetLabel.alpha = 0.5;
    
    [UIView commitAnimations];
    
    [UIView commitAnimations];
}


- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if ([animationID isEqualToString:@"animationA"])
    {
        if ([finished boolValue])
        {
            [UIView beginAnimations:@"animationC" context:nil];
            
            [UIView setAnimationDuration:0.2];
            
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            
            [UIView setAnimationRepeatAutoreverses:YES];
            
            [UIView setAnimationRepeatCount:1];
            
            [UIView setAnimationDelegate:self];
            
            [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
            
            self.targetLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
            
            [UIView commitAnimations];
        }
    }
    
    if ([animationID isEqualToString:@"animationB"])
    {
        if ([finished boolValue])
        {
            self.targetLabel.alpha = 1.0;
        }
    }
    
    if ([animationID isEqualToString:@"animationC"])
    {
        if ([finished boolValue])
        {
            self.targetLabel.transform = CGAffineTransformIdentity;
        }
    }
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
