//
//  MusicInfoModel.h
//  MusicPlay8-1下午
//
//  Created by JavenWong on 16/1/21.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicInfoModel : NSObject

@property (nonatomic, copy) NSString *mp3Url;       // 音频url
@property (nonatomic, copy) NSString *identify;     // 标识符
@property (nonatomic, copy) NSString *name;          // 歌曲名称
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *blurPicUrl;   // 模糊
@property (nonatomic, copy) NSString *album;        // 专辑
@property (nonatomic, copy) NSString *singer;       //演唱者名称
@property (nonatomic, copy) NSString *duration;      // 时间
@property (nonatomic, copy) NSString *artists_name;  // 作曲人
@property (nonatomic, copy) NSString *lyric;         // 歌词

+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
