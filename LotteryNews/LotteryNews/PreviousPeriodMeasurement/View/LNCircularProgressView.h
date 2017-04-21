//
//  LNCircularProgressView.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/4/17.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LNCircularProgressView : UIView
@property (nonatomic, copy) void (^fillChangedBlock)(LNCircularProgressView *progressView, BOOL filled, BOOL animated);
@property (nonatomic, copy) void (^didSelectBlock)(LNCircularProgressView *progressView);
@property (nonatomic, copy) void (^progressChangedBlock)(LNCircularProgressView *progressView, CGFloat progress);
@property (nonatomic, strong) UIView *centralView;
@property (nonatomic, assign) BOOL fillOnTouch UI_APPEARANCE_SELECTOR;


@property (nonatomic, assign) CGFloat borderWidth UI_APPEARANCE_SELECTOR;


@property (nonatomic, assign) CGFloat lineWidth UI_APPEARANCE_SELECTOR;

@property (nonatomic, strong) UIColor *tintColor;


@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) CFTimeInterval animationDuration UI_APPEARANCE_SELECTOR;


- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;
@end
