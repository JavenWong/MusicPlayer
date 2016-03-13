//
//  MusicAudioManager.m
//  MusicPlay8-1下午
//
//  Created by JavenWong on 16/1/26.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "MusicAudioManager.h"
#import <AVFoundation/AVFoundation.h>

@interface MusicAudioManager () 

@property (nonatomic, strong) AVPlayer *avplayer;
@property (nonatomic, strong) AVPlayerItem *item;
@property (nonatomic, strong) NSTimer *timer;

@end


@implementation MusicAudioManager

+ (instancetype)shareManager
{
    static MusicAudioManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[MusicAudioManager alloc] init];
        }
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioEndHandle) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

- (void)audioEndHandle
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPlayEndTime)]) {
        [self.delegate audioPlayEndTime];
    }
}

- (void)play
{
//    if ([_timer isValid]) {
//        return;
//    }
    [self.avplayer play];
    self.isPlaying = YES;
//    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerHandle) userInfo:nil repeats:YES];
}

- (void)pause
{
    [self.avplayer pause];
    self.isPlaying = NO;
//    [_timer invalidate];
    _timer = nil;
}

- (void)timerHandle
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(audioPlayWithProgress:)]) {
        float second = [self cmtime].value / [self cmtime].timescale;
        // 响应代理方法
        [self.delegate audioPlayWithProgress:second];
    }
}

- (void)setMusicAudioWithUrl:(NSString *)musicUrl
{
    if (self.avplayer.currentItem) {
        [self.avplayer.currentItem removeObserver:self forKeyPath:@"status"];
    }
    _item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:musicUrl]];
    [_item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [self.avplayer replaceCurrentItemWithPlayerItem:_item];
    
}

- (AVPlayer *)avplayer
{
    if (_avplayer == nil) {
        _avplayer = [[AVPlayer alloc] init];
    }
    return _avplayer;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSInteger new = [change[@"new"] integerValue];
    switch (new) {
        case AVPlayerItemStatusFailed:
            NSLog(@"AVPlayerItemStatusFailed");
            break;
        case AVPlayerItemStatusReadyToPlay:
            NSLog(@"AVPlayerItemStatusReadyToPlay");
            [self play];
            
            break;
        case AVPlayerItemStatusUnknown:
            NSLog(@"AVPlayerItemStatusUnknown");
            break;
        default:
            break;
    }
}

- (BOOL)isPlayCurrentAudioWithUrl:(NSString *)url
{
    NSString *currentURL = [[(AVURLAsset *)self.avplayer.currentItem.asset URL] absoluteString];
    return [currentURL isEqualToString:url];
}

// 属性setter getter方法
- (void)setVolume:(float)volume
{
    self.avplayer.volume = volume;
}

- (float)volume
{
    return self.avplayer.volume;
}

// 跳到指定时间播放
- (void)seekToTimePlay:(float)time
{
    [self pause];
    [self.avplayer seekToTime:CMTimeMakeWithSeconds(time, self.avplayer.currentTime.timescale)];
    [self play];
}

- (CMTime)cmtime
{
    return self.avplayer.currentTime;
}

@end
