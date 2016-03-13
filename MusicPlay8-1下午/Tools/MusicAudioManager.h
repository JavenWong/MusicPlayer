//
//  MusicAudioManager.h
//  MusicPlay8-1下午
//
//  Created by JavenWong on 16/1/26.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MusicRunModel) {
    MusicRunModelListLoop,
    MusicRunModelRandomLoop,
    MusicRunModelSingleLoop,
    MusicRunModelCurrentLoop
};


@protocol MusicAudioManagerDelegate <NSObject>

- (void)audioPlayWithProgress:(float)progress;
// 播放结束时的方法, 用于回到vc中播放下一首
- (void)audioPlayEndTime;

@end


@interface MusicAudioManager : NSObject

@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) float volume;
@property (nonatomic, weak) id<MusicAudioManagerDelegate> delegate;
//@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) MusicRunModel runModel;
@property (nonatomic, strong) UIViewController *vc;

+ (instancetype)shareManager;

- (void)setMusicAudioWithUrl:(NSString *)musicUrl;

- (void)play;

- (void)pause;
// 判断当前播放的是否和重新进来的一样
- (BOOL)isPlayCurrentAudioWithUrl:(NSString *)url;
// 跳到指定时间播放
- (void)seekToTimePlay:(float)time;

- (CMTime)cmtime;

@end
