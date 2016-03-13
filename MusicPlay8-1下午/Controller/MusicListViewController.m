//
//  MusicListViewController.m
//  MusicPlay8-1下午
//
//  Created by JavenWong on 16/1/21.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "MusicListViewController.h"
#import "MusicListCell.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "MusicInfoModel.h"
#import "UIImageView+WebCache.h"
#import "MusicDetailsViewController.h"
#import "UIViewController+HUD.h"
#import "MusicManager.h"

@interface MusicListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *modelArr;
@property (nonatomic, assign) NSInteger musicDetailsIndex;

@end

@implementation MusicListViewController

#pragma mark - lifeCicle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    MusicDetailsViewController *musicDetailsVC = [[MusicDetailsViewController alloc] init];
//    __weak typeof(musicDetailsVC)weakSelf = musicDetailsVC;
//    weakSelf.indexBlock = ^() {
//        self.tableView.backgroundColor = [UIColor redColor];
//        self.musicDetailsIndex = weakSelf.index;
//    };
    
    
    self.musicDetailsIndex = [MusicManager shareManager].index;
    MusicInfoModel *model = [[MusicManager shareManager] modelAtIndex:self.musicDetailsIndex];
    [(UIImageView *)self.tableView.backgroundView sd_setImageWithURL:[NSURL URLWithString:model.blurPicUrl]];
}

- (void)selectIndexNotifiHandle:(NSNotification *)notifi
{
    self.musicDetailsIndex = [notifi.object integerValue];
    MusicInfoModel *model = [[MusicManager shareManager] modelAtIndex:self.musicDetailsIndex];
    [(UIImageView *)self.tableView.backgroundView sd_setImageWithURL:[NSURL URLWithString:model.blurPicUrl]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"音乐列表";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectIndexNotifiHandle:) name:@"musicDetailsIndex" object:nil];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    // 设置背景图片
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    backImage.image = [UIImage imageNamed:@"1"];
//
//    // visual光学的视觉的
//    UIVisualEffectView *visual = [[UIVisualEffectView alloc] initWithFrame:self.view.bounds];
//    // blur 模糊的
//    visual.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    [backImage addSubview:visual];
    
//    [self.view addSubview:backImage];
    
    UIButton *customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [customBtn setImage:[UIImage imageNamed:@"music-s"] forState:UIControlStateNormal];
    [customBtn setImage:[UIImage imageNamed:@"music"] forState:UIControlStateHighlighted];
    [customBtn addTarget:self action:@selector(RightBtnTapHandle) forControlEvents:UIControlEventTouchUpInside];
    customBtn.frame = CGRectMake(0, 0, 30, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customBtn];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 64) style:UITableViewStylePlain];
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.tableFooterView = [UIView new];
    
    // 下面这句话的作用: 当有导航的时候, 00点 顶着导航往下 2.没有档函的时候是顶着屏幕的00点及最高点
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = backImage;
    
    
//    self.tableView.backgroundColor = [UIColor yellowColor];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UITableView new];
    
    [self.tableView registerClass:[MusicListCell class] forCellReuseIdentifier:@"musicreusecell"];
    
    
    
    // category
//    NSLog(@"isnetwork_______%d", [self isNetWork]);
//    if ([self isNetWork]) {
//        MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:self.view.bounds];
//        hud.labelText = @"正在加载数据";
//        hud.mode = MBProgressHUDModeCustomView;
//        [hud show:YES];
//        [self.view addSubview:hud];
        
//        float progress = 0;
//        while (progress < 1.0f) {
//            progress += 0.01;
//            hud.progress = progress;
//            usleep(5000);
//        }
        
        
//        MBProgressHUD *hud = [self showHUDwith:@"正在加载"];
//        
//        NSArray *array = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:@"http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist"]];
//        for (int i = 0; i < array.count; i++) {
//            MusicInfoModel *model = [MusicInfoModel modelWithDic:array[i]];
//            [self.modelArr addObject:model];
//        }
////        [hud hide:YES];
//        [self.tableView reloadData];
//        [self hideHUD:hud];
//    }
//    else {
    
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"当前无网络";
//        [self.view addSubview:hud];
//        [hud hide:YES afterDelay:2];
        
//        [self AlertOnlyLabelWithStr:@"当前无网络"];
//    }
    MusicManager *manager = [MusicManager shareManager];
    [manager requestDataWithBlock:^(int num) {
        
        [self.tableView reloadData];
        
    } withVC:self];
     //    [manager requestDataWithGCD];
    
    
    
}

- (NSMutableArray *)modelArr
{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

#pragma mark - TapHandle
- (void)RightBtnTapHandle
{
    MusicDetailsViewController *musicDetailsVC = [[MusicDetailsViewController alloc] init];
    
    musicDetailsVC.index = self.musicDetailsIndex;
    [self presentViewController:musicDetailsVC animated:YES completion:^{
        
    }];
    
}

#pragma mark - TableViewDelegate TableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.modelArr.count;
    MusicManager *manager = [MusicManager shareManager];
    return [manager returnModelArrayCount];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"musicreusecell" forIndexPath:indexPath];
    [cell cellWithModel:[[MusicManager shareManager] modelAtIndex:indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

#pragma mark - netWork
//- (BOOL)isNetWork
//{
//    BOOL isNetWork;
//    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
//    switch ([reach currentReachabilityStatus]) {
//        case NotReachable:
//            NSLog(@"没有网络");
//            isNetWork = NO;
//            break;
//        case ReachableViaWiFi:
//            isNetWork = YES;
//            break;
//        case ReachableViaWWAN:
//            isNetWork = YES;
//            break;
//        default:
//            break;
//    }
//    return isNetWork;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicDetailsViewController *musicDetailsVC = [[MusicDetailsViewController alloc] init];
    
//    MusicListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    UIImageView *backImage = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    backImage.image = cell.picImageView.image;
//    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithFrame:self.view.bounds];
//    visualEffectView.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    [backImage addSubview:visualEffectView];
//    
//    self.tableView.backgroundView = backImage;
    
    
    musicDetailsVC.index = indexPath.row;
    
    
//    __weak typeof(musicDetailsVC)weakSelf = musicDetailsVC;
//    weakSelf.indexBlock = ^() {
//        self.tableView.backgroundColor = [UIColor redColor];
//        self.musicDetailsIndex = weakSelf.index;
//    };
    #pragma mark - cell选中后灰色去掉
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self presentViewController:musicDetailsVC animated:YES completion:^{
        
    }];
}

#pragma mark - change the color of the cell's textfield of text
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MusicListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    cell.singerNameLabel.textColor = [UIColor purpleColor];
//    cell.musicNameLabel.textColor = [UIColor redColor];
    
}

//- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    MusicListCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    cell.singerNameLabel.textColor = [UIColor lightGrayColor];
//    cell.musicNameLabel.textColor = [UIColor whiteColor];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
