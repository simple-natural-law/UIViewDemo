//
//  ViewTransitionViewController.m
//  UIViewDemo
//
//  Created by 讯心科技 on 2017/11/29.
//  Copyright © 2017年 讯心科技. All rights reserved.
//

#import "ViewTransitionViewController.h"

@interface ViewTransitionViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textViewA;

@property (weak, nonatomic) IBOutlet UITextView *textViewB;

@end


@implementation ViewTransitionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 30);
    [button setTitle:@"下一页" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(nextPageAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
    self.textViewA.text = @"\n\n点击右上角按钮触发动画\n\n\n\n惠公曰：寡人有甲车六百乘，足以待君。君若退师，寡人之愿；若其不退，寡人即欲避君，其奈此三军之士何！\n\n穆公笑曰：孺子何骄也？君欲国，寡人纳之。君欲粟，寡人给之。今君欲战，寡人敢拒命乎？";
    
    self.textViewB.text = @"\n\n点击右上角按钮触发动画\n\n\n\n林中两路分，可惜难兼行。游子久伫立，极目望一径。蜿蜒复曲折，隐与丛林中。我选另一途，合理亦公正。草密人迹罕，正待人通行。足迹踏过处，两路皆相同。两路林中伸，落叶无人踪。我选一路走，深知路无穷。我疑从今后，能否转回程。数十年之后，谈起常叹息。林中两路分，一路人迹稀。我独选此路，境遇乃相异。";
}


- (void)nextPageAction
{
    [UIView transitionWithView:self.view duration:1.0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
        
        self.textViewA.hidden = !self.textViewA.hidden;
        
        self.textViewB.hidden = !self.textViewB.hidden;
        
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
