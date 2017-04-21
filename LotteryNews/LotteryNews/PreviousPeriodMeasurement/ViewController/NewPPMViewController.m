//
//  NewPPMViewController.m
//  LotteryNews
//
//  Created by 邹壮壮 on 2017/4/19.
//  Copyright © 2017年 邹壮壮. All rights reserved.
//

#import "NewPPMViewController.h"
#import "LNScrollerView.h"
#import "PPMNewRankListView.h"
#import "UserStore.h"
@interface NewPPMViewController ()
@property (strong, nonatomic)  LNScrollerView *topAdScrollerView;
@property (strong, nonatomic)  UIView *lottoryTypeView;
@property (strong, nonatomic)  PPMNewRankListView *recommendView;


@end

@implementation NewPPMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self rankList];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initUI{
    _topAdScrollerView = [[LNScrollerView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    [self.view addSubview:_topAdScrollerView];
    
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_topAdScrollerView.frame), kScreenWidth, 40)];
    [self.view addSubview:centerView];
    
    UILabel *lable1 = [self create:@"彩票种类"];
    lable1.textAlignment = NSTextAlignmentLeft;
    [centerView addSubview:lable1];
    [lable1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(centerView.mas_left).with.offset(8);
        make.centerY.mas_equalTo(centerView.mas_centerY);
    }];
    UILabel *lable2 = [self create:@"推荐专家"];
    lable2.textAlignment = NSTextAlignmentRight;
    [centerView addSubview:lable2];
    [lable2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(centerView.mas_right).with.offset(-8);
        make.centerY.mas_equalTo(centerView.mas_centerY);
    }];
    
    UIView *bottomView = [[UIView alloc]init];
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(centerView.mas_bottom);
    }];
    _lottoryTypeView = [[UIView alloc]init];
    _lottoryTypeView.backgroundColor = [UIColor redColor];
    [bottomView addSubview:_lottoryTypeView];
    [_lottoryTypeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(bottomView);
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(bottomView.mas_height);
    }];
    _recommendView = [[PPMNewRankListView alloc]init];
    [bottomView addSubview:_recommendView];
    [_recommendView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(bottomView);
        make.width.mas_equalTo(kScreenWidth/2);
        make.height.mas_equalTo(bottomView.mas_height);
    }];
    
}
- (UILabel *)create:(NSString *)text{
    UILabel *lable = [[UILabel alloc]init];
    lable.text = text;
    lable.textColor = [UIColor grayColor];
    lable.font = [UIFont systemFontOfSize:16];
    [lable sizeToFit];
    return lable;
}
- (void)rankList{
    NSDictionary *dict = @{@"playtype":@"1039",@"caipiaoid":@"1001",@"jisu_api_id":@"11"};
    kWeakSelf(self);
    
    [[UserStore sharedInstance]expert_rank:dict sucess:^(NSURLSessionDataTask *task, id responseObject) {
        
        //NSLog(@"%@",responseObject);
        NSNumber *codeNum = [responseObject objectForKey:@"code"];
        NSInteger code= [codeNum integerValue];
        NSMutableArray *array = [NSMutableArray array];
        if (code == 1) {
            NSArray *datas = [responseObject objectForKey:@"data"];
            if (datas.count > 0) {
                
                for (NSDictionary *dict in datas) {
                    RankListModel *model = [[RankListModel alloc]initWithDictionary:dict error:nil];
                    [array addObject:model];
                }
            }
            
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (array.count > 0) {
              weakself.recommendView.rankListArr = array;
            }
            
          
        });
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
