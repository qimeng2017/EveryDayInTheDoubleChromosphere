//
//  PPMNewRankListCell.h
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/4/17.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankListModel.h"
@interface PPMNewRankListCell : UITableViewCell
- (void)reloadScrollerView:(RankListModel *)rankListModel;
@end
