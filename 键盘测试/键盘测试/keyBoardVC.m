//
//  keyBoardVC.m
//  键盘测试
//
//  Created by Gopay_y on 20/07/2017.
//  Copyright © 2017 Gopay_y. All rights reserved.
//

#import "keyBoardVC.h"
#import "BlockTestVC.h"

@interface keyBoardVC ()<UIAlertViewDelegate>
{
    UITextField *_tf;
}
@end

@implementation keyBoardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tf = [[UITextField alloc] initWithFrame:CGRectMake(100, 50, 200, 50)];
    _tf.backgroundColor = [UIColor redColor];
    [self.view addSubview:_tf];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 150, 200, 50);
    [btn setTitle:@"View" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(100, 250, 200, 50);
    [btn1 setTitle:@"VC" forState:UIControlStateNormal];
    btn1.backgroundColor = [UIColor greenColor];
    [btn1 addTarget:self action:@selector(btnAction1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];

    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(100, 350, 200, 50);
    [btn2 setTitle:@"Block" forState:UIControlStateNormal];
    btn2.backgroundColor = [UIColor blackColor];
    [btn2 addTarget:self action:@selector(btnAction2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

-(void)btnAction:(UIButton *)btn {

    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"alertView" message:@"1111" delegate:self cancelButtonTitle:@"哦" otherButtonTitles:nil, nil];
    
    [av show];

    [_tf resignFirstResponder];
}

-(void)btnAction1:(UIButton *)btn {
    
    [self.view endEditing:YES];
    
    UIAlertController *avc = [UIAlertController alertControllerWithTitle:@"vcvc" message:@"ooooooo" preferredStyle:UIAlertControllerStyleAlert];
    [avc addAction:[UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        [self dismissViewControllerAnimated:NO completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }]];
    [self presentViewController:avc animated:NO completion:nil];
}

-(void)btnAction2:(UIButton *)btn {
    BlockTestVC *bvc = [[BlockTestVC alloc] init];
    
    [self.navigationController pushViewController:bvc animated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self.navigationController popViewControllerAnimated:YES];
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
