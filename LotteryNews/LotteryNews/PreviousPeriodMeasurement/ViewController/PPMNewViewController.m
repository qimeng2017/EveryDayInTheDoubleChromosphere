//
//  PPMNewViewController.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/3/28.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "PPMNewViewController.h"
#import "LNScrollerView.h"
#import "UserStore.h"
#import "TriolionTopAdModel.h"
#import "LNLotteryCategories.h"
#import "PPMNewTableViewCell.h"
#import "PPMViewController.h"
#import "RankListModel.h"
#import "TriolionFootCell.h"
#import "PersonalHomePageViewController.h"
#import "LoginViewController.h"
#import "LNLottoryConfig.h"
#import "HRSystem.h"
#import "PPMNewRankListView.h"
static CGFloat const TimerIntervals = 3.0;
static NSString *ppmNewCellIdentifier = @"ppmNewCellIdentifier";
static NSString *ppmNewFootCellWithIdentifier = @"ppmNewFootCellWithIdentifier";
@interface PPMNewViewController ()<LNScrollerViewDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,PPMNewTableViewCellDelegate,TriolionFootCellDelagate,PPMNewRankListViewDelegate>
@property (nonatomic, strong)LNScrollerView *topAdScrollerView;
@property (nonatomic, strong)NSMutableArray *topAdArray;
@property (nonatomic, strong)UITableView *ppmTableView;
@property (nonatomic, strong)NSMutableArray * rankListArray;
@property(nonatomic,strong) NSTimer *timer;
@property (nonatomic, strong)TriolionFootCell *triolionFootCell;
@property (nonatomic, strong)PPMNewRankListView *rankListView;
@end

@implementation PPMNewViewController
- (NSMutableArray *)topAdArray{
    if (_topAdArray == nil) {
        _topAdArray = [NSMutableArray array];
    }
    return _topAdArray;
}
- (NSMutableArray *)rankListArray{
    if (_rankListArray == nil) {
        _rankListArray = [NSMutableArray array];
    }
    return _rankListArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setBasice];
   
    [self getTopAD];
    self.kNavigationOpenTitle = YES;
    self.navigationItemTitle = [HRSystem appName];
    [self rankList];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//适配
- (void)setBasice{
    if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)])
        
    {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.ppmTableView.contentInset;
        
        insets.top =self.navigationController.navigationBar.bounds.size.height;
        
        self.ppmTableView.contentInset =insets;
        
        self.ppmTableView.scrollIndicatorInsets = insets;
        
    }
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 350)];
    _topAdScrollerView = [[LNScrollerView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 150)];
    _topAdScrollerView.delegate = self;
    [headerView addSubview:_topAdScrollerView];
    _rankListView = [[PPMNewRankListView alloc]initWithFrame:CGRectMake(0, 180, kScreenWidth, 170) style:UITableViewStylePlain];
    _rankListView.rankListViewdelegate = self;
    [headerView addSubview:_rankListView];
    _ppmTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-tabBarHeight) style:UITableViewStylePlain];
    _ppmTableView.delegate = self;
    _ppmTableView.dataSource = self;
    _ppmTableView.tableHeaderView = headerView;
    _ppmTableView.rowHeight = 100;
    _ppmTableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_ppmTableView];
    [_ppmTableView registerNib:[UINib nibWithNibName:NSStringFromClass([PPMNewTableViewCell class]) bundle:nil] forCellReuseIdentifier:ppmNewCellIdentifier];
    [_ppmTableView registerClass:[TriolionFootCell class] forCellReuseIdentifier:ppmNewFootCellWithIdentifier];
    
}
- (void)rankList{
    NSDictionary *dict = @{@"playtype":@"1039",@"caipiaoid":@"1001",@"jisu_api_id":@"11"};
    
    kWeakSelf(self);
    
    [[UserStore sharedInstance]expert_rank:dict sucess:^(NSURLSessionDataTask *task, id responseObject) {
        
        //NSLog(@"%@",responseObject);
        NSNumber *codeNum = [responseObject objectForKey:@"code"];
        NSInteger code= [codeNum integerValue];
        if (code == 1) {
            NSArray *datas = [responseObject objectForKey:@"data"];
            if (datas.count > 0) {
                if (_rankListArray.count > 0) {
                    [_rankListArray removeAllObjects];
                }
            }
            for (NSDictionary *dict in datas) {
                RankListModel *model = [[RankListModel alloc]initWithDictionary:dict error:nil];
                [weakself.rankListArray addObject:model];
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            weakself.rankListView.rankListArr = weakself.rankListArray;
            //[self startTimer];
           
            
        });
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"热门彩种";
    }else{
       return @"";
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 120;
    }else{
        return 140;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        NSInteger count = [LNLotteryCategories sharedInstance].categoryArray.count;
        if (count > 0) {
            if (count%2==0) {
                return count/2;
            }else{
                return count/2+1;
            }
        }else{
            return 0;
        }
    }else{
        return 1;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        TriolionFootCell *cell = [tableView dequeueReusableCellWithIdentifier:ppmNewFootCellWithIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.rankListArray.count > 0) {
            [cell reloadScrollerView:[self generateRandArray:3]];
        }
        _triolionFootCell = cell;
        return cell;
    }else{
        PPMNewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ppmNewCellIdentifier];
        cell.delegate = self;
        [cell setContent:[LNLotteryCategories sharedInstance].categoryArray atIndexPath:indexPath rankArray:_rankListArray];
        return cell;
    }
    
}

- (void)selectedImageView:(RankListModel *)model{
    NSString *userID = UserDefaultObjectForKey(LOTTORY_AUTHORIZATION_UID);
    if (userID) {
        PersonalHomePageViewController *personalHomeVC = [[PersonalHomePageViewController alloc]init];
        personalHomeVC.expert_id = model.expert_id;
        personalHomeVC.nickname = model.nickname;
        personalHomeVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.navigationController pushViewController:personalHomeVC animated:YES];
    }else{
        [self presentViewController:[[LoginViewController alloc]init] animated:YES completion:nil];
    }
    
}

- (void)getTopAD{
    [[UserStore sharedInstance]topAdSucess:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *top_ad_arr = [responseObject objectForKey:@"top_ad"];
        if (top_ad_arr.count > 0) {
            if (self.topAdArray.count > 0) {
                [_topAdArray removeAllObjects];
            }
        }
        for (NSDictionary *dict in top_ad_arr) {
            TriolionTopAdModel *model = [[TriolionTopAdModel alloc]initWithDictionary:dict error:nil];
            [self.topAdArray addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_topAdArray.count>0) {
                _topAdScrollerView.imageArray = _topAdArray;
            }
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
- (void)LNScrollerViewDidClicked:(NSUInteger)index{
    TriolionTopAdModel *model = [_topAdArray objectAtIndex:index];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:model.link]];
}
#pragma mark --PPMNewTableViewCellDelegate
- (void)clickLeft:(NSString *)lottoryName{
    [self pushPPM:lottoryName];
}

- (void)clickRight:(NSString *)lottoryName{
    [self pushPPM:lottoryName];
}
- (void)pushPPM:(NSString *)lottoryName{
    PPMViewController *pp = [[PPMViewController alloc]init];
    pp.hidesBottomBarWhenPushed = YES;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:pp animated:YES];
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset

{
    
    if(velocity.y>0)
        
    {
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
    }
    
    else
        
    {
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
    }
    
}
#pragma mark - 私有方法
- (void)startTimer
{
    // 让之前的定时器失效并置为空
    [_timer invalidate];
    _timer = nil;
    
    // 1.创建一个定时器
    NSTimer *timer = [NSTimer timerWithTimeInterval:TimerIntervals target:self selector:@selector(chang) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
}
- (void)chang{
     NSArray*randomArray = [self generateRandArray:3];
    if (_triolionFootCell) {
        [_triolionFootCell reloadScrollerView:randomArray];
        [self setTransitionAnimations];
    }
    
}
- (void)changAction{
    [_timer invalidate];
    _timer = nil;
    
    NSArray*randomArray = [self generateRandArray:3];
    if (_triolionFootCell) {
        [_triolionFootCell reloadScrollerView:randomArray];
        [self setTransitionAnimations];
    }
    [self startTimer];
}
- (NSArray *)generateRandArray:(NSInteger)count{
    NSMutableSet *randomSet = [[NSMutableSet alloc] init];
    
    while ([randomSet count] < count) {
        int r = arc4random() % [_rankListArray count];
        [randomSet addObject:[_rankListArray objectAtIndex:r]];
    }
    
    NSArray *arr = [randomSet allObjects];
    return arr;
}
// 自定义转场动画
- (void)setTransitionAnimations
{
    self.triolionFootCell.userInteractionEnabled = YES;
    
    CATransition *transition = [CATransition animation];
    transition.duration = TimerIntervals * 0.3;
    transition.type = @"cube";
    transition.subtype = kCATransitionFromRight;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.triolionFootCell.layer addAnimation:transition forKey:kCATransition];
}


@end
