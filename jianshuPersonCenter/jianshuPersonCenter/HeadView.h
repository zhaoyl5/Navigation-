//
//  HeadView.h
//  jianshuPersonCenter
//
//  Created by tianfeng on 16/10/11.
//  Copyright © 2016年 zyl. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeadView;
@protocol headViewDelegate <NSObject>
-(void)headViewButtonClicked:(UIButton *)btn;
@end

@interface HeadView : UIView
@property (nonatomic,assign) id<headViewDelegate> delegate;
@end
