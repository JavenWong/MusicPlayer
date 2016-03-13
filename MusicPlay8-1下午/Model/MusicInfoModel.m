//
//  MusicInfoModel.m
//  MusicPlay8-1下午
//
//  Created by JavenWong on 16/1/21.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "MusicInfoModel.h"

@implementation MusicInfoModel

+ (instancetype)modelWithDic:(NSDictionary *)dic
{
    MusicInfoModel *model = [MusicInfoModel new];
    model.mp3Url = dic[@"mp3Url"];
    model.identify = dic[@"id"];
    model.name = dic[@"name"];
    model.picUrl = dic[@"picUrl"];
    model.blurPicUrl = dic[@"blurPicUrl"];
    model.album = dic[@"album"];
    model.singer = dic[@"singer"];
    model.duration = dic[@"duration"];
    model.artists_name = dic[@"artists_name"];
    model.lyric = dic[@"lyric"];
    return model;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
