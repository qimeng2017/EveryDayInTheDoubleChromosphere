//
//  PPMNewTableViewCell.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/3/28.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "PPMNewTableViewCell.h"
#import "LottoryCategoryModel.h"
#import "RankListModel.h"
@interface PPMNewTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageview;
@property (weak, nonatomic) IBOutlet UILabel *leftLable;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightLable;

@property (nonatomic, strong) NSArray *contentArray;
@property (weak, nonatomic) IBOutlet UILabel *leftIntrolLable;
@property (weak, nonatomic) IBOutlet UILabel *rightIntrolLable;

@end
@implementation PPMNewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer *tapLeft = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLeft:)];
    [self.leftView addGestureRecognizer:tapLeft];
    
    UITapGestureRecognizer *tapRight = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickRight:)];
    [self.rightView addGestureRecognizer:tapRight];
}
- (void)setContent:(NSArray *)itemsGroup atIndexPath:(NSIndexPath *)indexPath rankArray:(NSArray *)rankList{
    if (itemsGroup.count > indexPath.row*2) {
        LottoryCategoryModel *model = itemsGroup[indexPath.row*2];
        NSString *caipiao_name = model.caipiao_name;
        _leftView.hidden = NO;
        _leftLable.text = caipiao_name;
        _leftImageview.image = [UIImage imageNamed:[self imageName:caipiao_name]];
        if (rankList.count >indexPath.row*2) {
            _leftIntrolLable.hidden = NO;
            RankListModel *rankModel = rankList[indexPath.row*2];
            _leftIntrolLable.text = [NSString stringWithFormat:@"%@:%@",rankModel.nickname,rankModel.fore_data];
        }
    }
    if (itemsGroup.count > indexPath.row*2 + 1) {
        _rightView.hidden = NO;
       
        LottoryCategoryModel *model = itemsGroup[indexPath.row*2+1];
         NSString *caipiao_name = model.caipiao_name;
        _rightLable.text = caipiao_name;
        _rightImageView.image = [UIImage imageNamed:[self imageName:caipiao_name]];
        if (rankList.count >indexPath.row*2+1) {
            _rightIntrolLable.hidden = NO;
            RankListModel *rankModel = rankList[indexPath.row*2+1];
            _rightIntrolLable.text = [NSString stringWithFormat:@"%@:%@",rankModel.nickname,rankModel.fore_data];
        }
    }
}
- (NSString *)imageName:(NSString *)caipiao_name{
    NSString *imageName;
    if ([caipiao_name isEqualToString:@"大乐透"]) {
        imageName = @"daletou";
    }else if ([caipiao_name isEqualToString:@"福彩3d"]){
        imageName = @"fucai3d";
    }else if ([caipiao_name isEqualToString:@"排列五"]){
        imageName = @"pailie5";
    }else if ([caipiao_name isEqualToString:@"排列三"]){
        imageName = @"pailiesan";
    }else if ([caipiao_name isEqualToString:@"七乐彩"]){
        imageName = @"qilecai";
    }else if ([caipiao_name isEqualToString:@"七星彩"]){
        imageName = @"qixingcai";
    }else{
       imageName = @"shuangseqiu";
    }
    return imageName;
}
- (void)clickLeft:(UITapGestureRecognizer *)tapLeft{
    UIView *left_View = tapLeft.view;
    UILabel *lable = [left_View viewWithTag:112];
    if (_delegate&&[_delegate respondsToSelector:@selector(clickLeft:)]) {
        [_delegate clickLeft:lable.text];
    }
}
- (void)clickRight:(UITapGestureRecognizer *)tapRight{
    UIView *right_View = tapRight.view;
    UILabel *lable = [right_View viewWithTag:122];
    if (_delegate&&[_delegate respondsToSelector:@selector(clickRight:)]) {
        [_delegate clickRight:lable.text];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
