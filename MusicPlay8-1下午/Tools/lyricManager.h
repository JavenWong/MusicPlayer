//
//  lyricManager.h
//  MusicPlay8-1下午
//
//  Created by JavenWong on 16/1/27.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lyricManager : NSObject

@property (nonatomic, strong) NSMutableArray *modelDataArr;

+ (instancetype)shareManager;
// 从大德数据模型传进来歌词信息去做处理
- (void)setlyricDataArrayWithlyricStr:(NSString *)lyricstr;
// 把当前播放时间传进来, 与model的时间作对比, 最终得到index
- (NSInteger)lyricIndexWithCurrentImte:(float)time;

@end
