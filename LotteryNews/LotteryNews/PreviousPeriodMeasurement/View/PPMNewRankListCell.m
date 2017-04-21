//
//  PPMNewRankListCell.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/4/17.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "PPMNewRankListCell.h"
#import "LNCircularProgressView.h"
@interface PPMNewRankListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLable;
@property (weak, nonatomic) IBOutlet LNCircularProgressView *userProgress;
@property (weak, nonatomic) IBOutlet UILabel *userInfoMayLable;

@property (nonatomic, strong)RankListModel *rankListModel;
@end
@implementation PPMNewRankListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)reloadScrollerView:(RankListModel *)rankListModel{
    
    _rankListModel = rankListModel;
   
    [self layoutSubviews];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    [_userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:_rankListModel.images_url] placeholderImage:[UIImage imageNamed:@"Icon-Small"] options:SDWebImageRefreshCached];
    _userNameLable.text = _rankListModel.nickname;
    
    
    
    self.userProgress.tintColor = [UIColor colorWithRed:5/255.0 green:204/255.0 blue:197/255.0 alpha:1.0];
    self.userProgress.borderWidth = 2.0;
    self.userProgress.lineWidth = 2.0;
    self.userProgress.fillOnTouch = YES;
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60.0, 32.0)];
    textLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:12];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.textColor = [UIColor redColor];
    textLabel.backgroundColor = [UIColor clearColor];
    self.userProgress.centralView = textLabel;
    //两个空格
    NSArray *foreArray = [_rankListModel.fore_data componentsSeparatedByString:@"  "];
    NSString * progressValue  = [foreArray objectAtIndex:1];
    NSString *may = [foreArray objectAtIndex:0];
    _userInfoMayLable.text = may;
    textLabel.text = progressValue;
    CGFloat value = [progressValue floatValue];
    self.userProgress.progress = value/100;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
