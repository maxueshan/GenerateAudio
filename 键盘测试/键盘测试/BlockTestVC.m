//
//  BlockTestVC.m
//  键盘测试
//
//  Created by Gopay_y on 21/07/2017.
//  Copyright © 2017 Gopay_y. All rights reserved.
//

#import "BlockTestVC.h"
#import "BlockTestView.h"

@interface BlockTestVC ()
{
    BlockTestView *_btv;
}
@end

@implementation BlockTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak BlockTestVC *weakSelf = self;
    
    _btv = [[BlockTestView alloc] initWithFrame:CGRectMake(50, 100, 200, 100)];
    _btv.backgroundColor = [UIColor redColor];
    _btv.label.text = @"私有属性";
    _btv.label.textColor = [UIColor blackColor];
    _btv.userInteractionEnabled = YES;
    
    [self.view addSubview:_btv];
    
    _btv.testBlock = ^(NSString *ttt){
    
        NSLog(@"_btv = %@",ttt);
        
        [weakSelf testSelf];
    };
    
    
    BlockTestView *btv2 = [[BlockTestView alloc] initWithFrame:CGRectMake(50, 300, 200, 100)];
    btv2.backgroundColor = [UIColor blackColor];
    btv2.label.text = @"临时变量";
    btv2.label.textColor = [UIColor whiteColor];
    btv2.userInteractionEnabled = YES;
    
    [self.view addSubview:btv2];
    
    btv2.testBlock = ^(NSString *ttt){
        NSLog(@"btv2 = %@",ttt);
        
//        weakSelf.title = @"12321312";
        
        [weakSelf testSelf];
    };
}

-(void)testSelf {
    
    static int i = 0;
    
    i ++;
    
    self.title = [NSString stringWithFormat:@"***  %d  ***",i];
    
}

-(void)testLog {
    NSLog(@"testLog ...");
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
