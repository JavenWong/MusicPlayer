//
//  MusicDetailsViewController.m
//  MusicPlay8-1下午
//
//  Created by JavenWong on 16/1/25.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "MusicDetailsViewController.h"
#import "MusicAudioManager.h"
#import "MusicInfoModel.h"
#import "MusicManager.h"
#import "UIImageView+WebCache.h"
#import "lyricManager.h"
#import "lyricModel.h"

#define kScreenWidth self.view.bounds.size.width
#define kScreenHeight self.view.bounds.size.height

@interface MusicDetailsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *setBtnArr;
@property (nonatomic, strong) NSTimer *rotateTimer;
@property (nonatomic, strong) NSTimer *progressTimer;
@property (nonatomic, assign) NSInteger indexPathRow;


@end

@implementation MusicDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MusicAudioManager shareManager].vc = self;
    
    [self setMusicView];
    
    [self reloadViewData];
    
}

#pragma mark - event Response
- (void)getBackTapHandle:(UIButton *)button
{
    // 传回去index使第一个页面的返回为本index
    [self.rotateTimer invalidate];
//    [self.progressTimer invalidate];
//    if (<#condition#>) {
//        <#statements#>
//    }
//    self.indexBlock();

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)setBtnTapHandle:(UIButton *)sender
{
    for (UIButton *btn in self.setBtnArr) {
        btn.selected = NO;
        
    }
    NSInteger index = [_setBtnArr indexOfObject:sender];
//    [[NSUserDefaults standardUserDefaults] setInteger:index forKey:@"setIndex"];
//    [MusicAudioManager shareManager].index = index;
    [MusicAudioManager shareManager].runModel = index;
    sender.selected = YES;
}

#pragma mark - slider
- (void)updateProgress:(NSTimer *)timer
{
    CMTime cmtime = [[MusicAudioManager shareManager] cmtime];
    float currentTime = cmtime.value / cmtime.timescale;
    self.progressSlider.value = currentTime;
    self.maxTimeLabel.text = [self timeFormatted:(self.duration / 1000 - currentTime) * 1000];
    self.minTimeLabel.text = [self timeFormatted:currentTime * 1000];
}

- (void)progressSlider:(UISlider *)slider
{
    [[MusicAudioManager shareManager] seekToTimePlay:slider.value];
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    totalSeconds /= 1000;
    int seconds = totalSeconds % 60;
    int minutes = totalSeconds / 60;
    return [NSString stringWithFormat:@"-%d:%02d", minutes, seconds];
}

- (void)volumeChange:(UISlider *)slider
{
    [[MusicAudioManager shareManager] setVolume:slider.value];
}

#pragma mark - play or pause or next or before
- (void)playOrPause:(UIButton *)button
{
    MusicAudioManager *manager = [MusicAudioManager shareManager];
    if (manager.isPlaying == YES) {
        [manager pause];
        self.rotateTimer.fireDate = [NSDate distantFuture];
        [button setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"play_h"] forState:UIControlStateHighlighted];
    }
    else
    {
        [manager play];
        self.rotateTimer.fireDate = [NSDate distantPast];
        [button setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"pause_h"] forState:UIControlStateHighlighted];
    }
}

- (void)forwardBtn
{
    self.index--;
    if (self.index < 0) {
        self.index = [[MusicManager shareManager] returnModelArrayCount] - 1;
    }
    [self.rotateTimer invalidate];
    [self reloadViewData];
}

- (void)nextBtn
{
    NSInteger index = [MusicAudioManager shareManager].runModel;
    switch (index) {
        case MusicRunModelCurrentLoop:
            
            break;
        case MusicRunModelListLoop:
            [self listrunloop];
            break;
        case MusicRunModelRandomLoop:
            self.index = arc4random() % 200;
            break;
        case MusicRunModelSingleLoop:
            [[MusicAudioManager shareManager] seekToTimePlay:0];
            break;
        default:
            break;
    }
    
//    [lyricManager shareManager].modelDataArr = nil;
    [self.rotateTimer invalidate];
    [self reloadViewData];
}

- (void)listrunloop
{
    self.index++;
    if (self.index > [[MusicManager shareManager] returnModelArrayCount] - 1) {
        self.index = 0;
    }
    
}

#pragma mark - rotate
- (void)rotateAction:(UIButton *)button
{
    self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI / 8);
    CMTime cmtime = [[MusicAudioManager shareManager] cmtime];
    float currentTime = cmtime.value / cmtime.timescale;
    self.progressSlider.value = currentTime;
    self.maxTimeLabel.text = [self timeFormatted:(self.duration / 1000 - currentTime) * 1000];
    self.minTimeLabel.text = [self timeFormatted:currentTime * 1000];
    if (currentTime >= (int)self.duration / 1000 - 1) {
        [self nextBtn];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"musicDetailsIndex" object:@(self.index)];
    }
    #pragma mark - wrong!!!!!!!
//    lyricModel *lyricmodel = [lyricManager shareManager].modelDataArr[self.indexPathRow];
//    if (lyricmodel != [[lyricManager shareManager].modelDataArr lastObject]) {
//        NSInteger indexInArr = [[lyricManager shareManager].modelDataArr indexOfObject:lyricmodel];
//        if (currentTime >= lyricmodel.currentTime - 1.4) {
//            UITableViewCell *cell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.indexPathRow - 1 inSection:0]];
//            cell2.selected = NO;
//            self.tableView.contentOffset = CGPointMake(0, self.tableView.rowHeight * (indexInArr - 1));
//            self.indexPathRow++;
//            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.indexPathRow - 1 inSection:0]];
//            cell.selected = YES;
//        }
//    }
    
    for (int i = 1; i < [lyricManager shareManager].modelDataArr.count; i++) {
        lyricModel *model = [lyricManager shareManager].modelDataArr[i];
        lyricModel *model1 = [lyricManager shareManager].modelDataArr[i - 1];
        lyricModel *model2 = [[lyricManager shareManager].modelDataArr lastObject];
        NSInteger indexInArr = [[lyricManager shareManager].modelDataArr indexOfObject:model1];
        if (currentTime <= model.currentTime && currentTime >= model1.currentTime) {
         
            indexInArr = [[lyricManager shareManager].modelDataArr indexOfObject:model1];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexInArr inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            break;
        }
        if (currentTime > model2.currentTime) {
            indexInArr = [[lyricManager shareManager].modelDataArr indexOfObject:model2];
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:indexInArr inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            break;
        }
    }
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [lyricManager shareManager].modelDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"reuse"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuse"];
    }
    lyricModel *model = [lyricManager shareManager].modelDataArr[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = model.lyricstr;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIView *view = [[UIView alloc] initWithFrame:cell.bounds];
    view.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = view;
    
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
//    self.indexPathRow = indexPath.row;
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    [cell.textLabel sizeToFit];
//    return cell.textLabel.frame.size.height + 10;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 懒加载
- (UIImageView *)backgroundImageView
{
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_backgroundImageView];
        [self.view sendSubviewToBack:_backgroundImageView];
    }
    return _backgroundImageView;
}

- (void)setMusicView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight / 2 - 30)];
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 2, self.scrollView.bounds.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.imageView.center = self.scrollView.center;
    self.imageView.layer.cornerRadius = 100;
    self.imageView.clipsToBounds = YES;
    self.imageView.layer.borderWidth = 2;
    self.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.scrollView addSubview:self.imageView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(kScreenWidth, 60, kScreenWidth, self.scrollView.frame.size.height - 120) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 50;
    [self.scrollView addSubview:self.tableView];
    
    self.getBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getBackBtn.frame = CGRectMake(20, 20, 30, 30);
    self.getBackBtn.layer.cornerRadius = 15;
    self.getBackBtn.backgroundColor = [UIColor whiteColor];
    [self.getBackBtn setBackgroundImage:[UIImage imageNamed:@"arrowdown.png"] forState:UIControlStateNormal];
    [self.getBackBtn addTarget:self action:@selector(getBackTapHandle:) forControlEvents:UIControlEventTouchUpInside];
    self.getBackBtn.clipsToBounds = YES;
    [self.view addSubview:self.getBackBtn];
    
    self.progressSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.size.height, kScreenWidth, 10)];
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"thumb@2x.png"] forState:UIControlStateNormal];
    [self.progressSlider setMinimumTrackTintColor:[UIColor redColor]];
    
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, self.progressSlider.center.y, kScreenWidth, kScreenHeight - self.progressSlider.center.y)];
    alphaView.backgroundColor = [UIColor lightGrayColor];
    alphaView.alpha = 0.5;
    [self.view addSubview:alphaView];
    
    [self.view addSubview:self.progressSlider];
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.size.height - 15, kScreenWidth, 10)];
    self.pageControl.numberOfPages = 2;
    self.pageControl.currentPage = 0;
    [self.view addSubview:self.pageControl];
    
    self.minTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.scrollView.bounds.size.height + 30, 60, 30)];
    [self.view addSubview:self.minTimeLabel];
    
    self.maxTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 48, self.progressSlider.frame.origin.y + 30, 60, 30)];
    [self.view addSubview:self.maxTimeLabel];
    
    self.musicNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.minTimeLabel.frame.origin.y + 25, 300, 50)];
    self.musicNameLabel.center = CGPointMake(kScreenWidth / 2, self.musicNameLabel.center.y);
    self.musicNameLabel.text = @"qqqq";
    self.musicNameLabel.font = [UIFont systemFontOfSize:25];
    self.musicNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.musicNameLabel];
    
    self.singerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.musicNameLabel.frame.origin.y + 70, 300, 30)];
    self.singerNameLabel.text = @"qwerqwerqwer";
    self.singerNameLabel.center = CGPointMake(kScreenWidth / 2, self.singerNameLabel.center.y);
    self.singerNameLabel.textAlignment = NSTextAlignmentCenter;
    self.singerNameLabel.textColor = [UIColor darkGrayColor];
    [self.view addSubview:self.singerNameLabel];
    
    self.lastSongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lastSongBtn.frame = CGRectMake(50, self.singerNameLabel.frame.origin.y + 50, 50, 25);
    [self.lastSongBtn setBackgroundImage:[UIImage imageNamed:@"rewind.png"] forState:UIControlStateNormal];
    [self.lastSongBtn addTarget:self action:@selector(forwardBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.lastSongBtn];
    
    self.nextSongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextSongBtn.frame = CGRectMake(kScreenWidth - 105, self.singerNameLabel.frame.origin.y + 50, 50, 25);
    [self.nextSongBtn setBackgroundImage:[UIImage imageNamed:@"forward.png"] forState:UIControlStateNormal];
    [self.nextSongBtn addTarget:self action:@selector(nextBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextSongBtn];
    
    self.waitingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.waitingBtn.frame = CGRectMake(kScreenWidth - 105, self.singerNameLabel.frame.origin.y + 50, 25, 25);
    self.waitingBtn.center = CGPointMake(kScreenWidth / 2, self.waitingBtn.center.y);
    [self.waitingBtn setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    [self.waitingBtn addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.waitingBtn];
    
    self.voiceSlider = [[UISlider alloc] initWithFrame:CGRectMake(25, self.nextSongBtn.frame.origin.y + 50, kScreenWidth - 50, 15)];
    [self.voiceSlider setMinimumValueImage:[UIImage imageNamed:@"volumelow@2x.png"]];
    [self.voiceSlider setMaximumValueImage:[UIImage imageNamed:@"volumehigh@2x.png"]];
    [self.voiceSlider setMinimumTrackTintColor:[UIColor blackColor]];
    [self.voiceSlider setThumbImage:[UIImage imageNamed:@"volumn_slider_thumb@2x.png"] forState:UIControlStateNormal];
    self.voiceSlider.value = 0.9;
    [self.view addSubview:self.voiceSlider];
    
    
    // calculate the width of four buttons
    float buttonWidth = (kScreenWidth - 40 - 30 * 4) / 3 + 30;
    /*
     self.firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     self.firstBtn.frame = CGRectMake(20, kScreenHeight - 70, 30, 30);
     [self.firstBtn setBackgroundImage:[UIImage imageNamed:@"loop.png"] forState:UIControlStateNormal];
     [self.view addSubview:self.firstBtn];
     
     self.secBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     self.secBtn.frame = CGRectMake(buttonWidth + 20, kScreenHeight - 70, 30, 30);
     [self.secBtn setBackgroundImage:[UIImage imageNamed:@"shuffle.png"] forState:UIControlStateNormal];
     [self.view addSubview:self.secBtn];
     
     self.thirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     self.thirdBtn.frame = CGRectMake(buttonWidth * 2 + 20, kScreenHeight - 70, 30, 30);
     [self.thirdBtn setBackgroundImage:[UIImage imageNamed:@"singleloop.png"] forState:UIControlStateNormal];
     [self.view addSubview:self.thirdBtn];
     
     self.fourBtn = [UIButton buttonWithType:UIButtonTypeCustom];
     self.fourBtn.frame = CGRectMake(buttonWidth * 3 + 20, kScreenHeight - 70, 30, 30);
     [self.fourBtn setBackgroundImage:[UIImage imageNamed:@"music.png"] forState:UIControlStateNormal];
     [self.view addSubview:self.fourBtn];
     */
    
    self.setBtnArr = [NSMutableArray array];
    
    NSArray *nomalPicname = @[@"loop", @"shuffle", @"singleloop", @"music"];
    for (int i = 0; i < 4; i++) {
        UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [setBtn setImage:[UIImage imageNamed:nomalPicname[i]] forState:UIControlStateNormal];
        [setBtn addTarget:self action:@selector(setBtnTapHandle:) forControlEvents:UIControlEventTouchUpInside];
        NSString *highName = [NSString stringWithFormat:@"%@-s", nomalPicname[i]];
        [setBtn setImage:[UIImage imageNamed:highName] forState:UIControlStateSelected];
        
        setBtn.frame = CGRectMake(20 + buttonWidth * i, kScreenHeight - 70, 30, 30);
        [self.view addSubview:setBtn];
        [self.setBtnArr addObject:setBtn];
    }
    
}

- (void)reloadViewData
{
    MusicAudioManager *manager = [MusicAudioManager shareManager];
    MusicInfoModel *model = [[MusicManager shareManager] modelAtIndex:self.index];
    [MusicManager shareManager].index = self.index;
    // 每次传进来不一样的url的时候才会重新加载音频
    if (![manager isPlayCurrentAudioWithUrl:model.mp3Url]) {
        [manager setMusicAudioWithUrl:model.mp3Url];
    }
    
    // 用系统单例去做
//    NSInteger index = [[NSUserDefaults standardUserDefaults] integerForKey:@"setIndex"];
//    NSInteger index = [MusicAudioManager shareManager].index;
    NSInteger index = [MusicAudioManager shareManager].runModel;
    if (!index) {
        index = 0;
    }
    ((UIButton *)self.setBtnArr[index]).selected = YES;
        
    [self.voiceSlider addTarget:self action:@selector(volumeChange:) forControlEvents:UIControlEventValueChanged];
    
    [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:model.blurPicUrl]];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    self.musicNameLabel.text = model.name;
    self.singerNameLabel.text = [NSString stringWithFormat:@"%@-%@", model.singer, model.album];
    self.duration = model.duration.intValue;
    
    
    
    
    self.progressSlider.maximumValue = model.duration.intValue / 1000;
    [self.progressSlider addTarget:self action:@selector(progressSlider:) forControlEvents:UIControlEventValueChanged];
    
    [lyricManager shareManager].modelDataArr = nil;

    self.indexPathRow = 0;
    [[lyricManager shareManager] setlyricDataArrayWithlyricStr:model.lyric];
    [self.tableView reloadData];
    
    self.rotateTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(rotateAction:) userInfo:nil repeats:YES];
    [self.rotateTimer fire];
    
//    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
//    [self.progressTimer fire];
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
