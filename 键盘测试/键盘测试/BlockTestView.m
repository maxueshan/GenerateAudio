//
//  BlockTestView.m
//  键盘测试
//
//  Created by Gopay_y on 21/07/2017.
//  Copyright © 2017 Gopay_y. All rights reserved.
//

#import "BlockTestView.h"

@implementation BlockTestView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        [self addSubview:self.label];
        
        
        self.userInteractionEnabled = YES;
        
        UIGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesAction)];
        [self addGestureRecognizer:ges];
    }
    
    return self;
}

-(void)gesAction {
    if (_testBlock) {
        _testBlock([NSString stringWithFormat:@"手势 %@",self.label.text]);
    }
}

-(void)dealloc{
    
    NSLog(@"%@  dealloc",self.label.text);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
