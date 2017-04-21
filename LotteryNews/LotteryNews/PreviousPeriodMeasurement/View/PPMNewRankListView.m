//
//  PPMNewRankListView.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/4/17.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "PPMNewRankListView.h"
#import "PPMNewRankListCell.h"

@interface PPMNewRankListView ()
@property (nonatomic, strong)NSMutableArray *rankLists;
@property(nonatomic,strong) NSTimer *timer;
@property (nonatomic, assign)NSInteger index;
@end
NSString *const PPMNewRankListCellIdentifier = @"PPMNewRankListCellIdentifier";
static CGFloat const RankListTimerIntervals = 3.0;
@implementation PPMNewRankListView
- (NSMutableArray *)rankLists{
    if (_rankLists == nil) {
        _rankLists = [NSMutableArray array];
    }
    return _rankLists;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self initBasic];
}
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initBasic];
    }
    return self;
}
- (void)initBasic{
    self.delegate = self;
    self.dataSource = self;
    self.tableFooterView = [[UIView alloc]init];
    [self registerNib:[UINib nibWithNibName:NSStringFromClass([PPMNewRankListCell class]) bundle:nil] forCellReuseIdentifier:PPMNewRankListCellIdentifier];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _rankLists.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PPMNewRankListCell *cell = [tableView dequeueReusableCellWithIdentifier:PPMNewRankListCellIdentifier];
    if (_rankListArr.count > indexPath.row) {
        RankListModel *model = [_rankLists objectAtIndex:indexPath.row];
        [cell reloadScrollerView:model];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RankListModel *model = [_rankLists objectAtIndex:indexPath.row];
    if (_rankListViewdelegate &&[_rankListViewdelegate respondsToSelector:@selector(selectedImageView:)]) {
        [_rankListViewdelegate selectedImageView:model];
    }
}
- (void)setRankListArr:(NSArray *)rankListArr{
    _rankListArr = rankListArr;
    NSInteger count;
    if (_rankListArr.count >= 5) {
        count = 5;
    }else{
        count = _rankListArr.count;
    }
    for (NSInteger i = 0; i < count; i++) {
        RankListModel *model = [_rankListArr objectAtIndex:i];
        [self.rankLists addObject:model];
    }
    _index = 4;
    [self reloadData];
    if (rankListArr.count > 5) {
      [self startTimer];
    }else{
        [_timer invalidate];
        _timer = nil;
    }
    
}
#pragma mark - 私有方法
- (void)startTimer
{
    // 让之前的定时器失效并置为空
    [_timer invalidate];
    _timer = nil;
    
    // 1.创建一个定时器
    NSTimer *timer = [NSTimer timerWithTimeInterval:RankListTimerIntervals target:self selector:@selector(addRankModel) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    _timer = timer;
}
- (void)addRankModel{
    
    _index++;
    if (_rankListArr.count >= 5&&_rankListArr.count > _index) {
        RankListModel *model = [_rankListArr objectAtIndex:_index];
        [self.rankLists addObject:model];
          [self insertCell];
    }else if (_rankLists.count >=_rankListArr.count){
        [_timer invalidate];
        _timer = nil;
    }
  
}
- (void)insertCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.rankLists.count - 1 inSection:0];
    [self insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self scrollTableToFoot:YES];
}
// 滑到最底部
- (void)scrollTableToFoot:(BOOL)animated
{
    NSInteger r = [self numberOfRowsInSection:0]; //最后一组有多少行
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:0];  //取最后一行数据
    [self scrollToRowAtIndexPath:ip
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
}
- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
}
@end
