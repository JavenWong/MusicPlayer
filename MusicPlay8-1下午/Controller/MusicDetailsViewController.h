//
//  MusicDetailsViewController.h
//  MusicPlay8-1下午
//
//  Created by JavenWong on 16/1/25.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface MusicDetailsViewController : UIViewController

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *getBackBtn;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *minTimeLabel;
@property (nonatomic, strong) UILabel *maxTimeLabel;
@property (nonatomic, strong) UILabel *singerNameLabel;
@property (nonatomic, strong) UILabel *musicNameLabel;
@property (nonatomic, strong) UIButton *lastSongBtn;
@property (nonatomic, strong) UIButton *nextSongBtn;
@property (nonatomic, strong) UIButton *waitingBtn;
@property (nonatomic, strong) UISlider *voiceSlider;
//@property (nonatomic, strong) UIButton *firstBtn;
//@property (nonatomic, strong) UIButton *secBtn;
//@property (nonatomic, strong) UIButton *thirdBtn;
//@property (nonatomic, strong) UIButton *fourBtn;

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) int duration;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) void(^indexBlock) (void);


@end
