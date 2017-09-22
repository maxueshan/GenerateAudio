//
//  BlockTestView2.m
//  键盘测试
//
//  Created by Gopay_y on 21/07/2017.
//  Copyright © 2017 Gopay_y. All rights reserved.
//

#import "BlockTestView2.h"

@implementation BlockTestView2

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.frame];
        label.text = @"可以释放";
        [self addSubview:label];
    }
    
    return self;
}

-(void)dealloc{
    
    NSLog(@"BlockTestView2  dealloc");
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
