//
//  PPMNewRankListView.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/4/17.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankListModel.h"

@protocol PPMNewRankListViewDelegate <NSObject>
- (void)selectedImageView:(RankListModel *)model;

@end
@interface PPMNewRankListView : UITableView<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak)id<PPMNewRankListViewDelegate>rankListViewdelegate;
@property (nonatomic, strong)NSArray *rankListArr;
@end
