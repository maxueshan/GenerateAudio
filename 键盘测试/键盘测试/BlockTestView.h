//
//  BlockTestView.h
//  键盘测试
//
//  Created by Gopay_y on 21/07/2017.
//  Copyright © 2017 Gopay_y. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^testBlock)(NSString *ttt);


@interface BlockTestView : UIView

@property (nonatomic,copy)testBlock testBlock;

@property (nonatomic,strong)UILabel *label;

@end
