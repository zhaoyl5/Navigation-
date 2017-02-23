//
//  HeadView.m
//  jianshuPersonCenter
//
//  Created by tianfeng on 16/10/11.
//  Copyright © 2016年 zyl. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView

- (IBAction)clicked:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(headViewButtonClicked:)]) {
        [_delegate headViewButtonClicked:sender];
    }
}

@end
