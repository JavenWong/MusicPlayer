//
//  lyricManager.m
//  MusicPlay8-1下午
//
//  Created by JavenWong on 16/1/27.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "lyricManager.h"
#import "lyricModel.h"

@implementation lyricManager

+ (instancetype)shareManager
{
    static lyricManager *manager = nil;
    static dispatch_once_t onceTaken;
    dispatch_once(&onceTaken, ^{
        if (manager == nil) {
            manager = [[lyricManager alloc] init];
        }
    });
    return manager;
}

- (void)setlyricDataArrayWithlyricStr:(NSString *)lyricstr
{
    NSArray *array = [lyricstr componentsSeparatedByString:@"\n"];
    for (int i = 0; i < array.count - 1; i++) {
        NSString *str = array[i];
        NSArray *arr1 = [str componentsSeparatedByString:@"]"];
        NSString *leftStr = arr1[0];
        NSString *rightStr = arr1[1];
        lyricModel *model = [lyricModel new];
        model.lyricstr = rightStr;
        NSString *timeStr = [leftStr substringFromIndex:1];
        NSArray *timeArray = [timeStr componentsSeparatedByString:@":"];
        int minute = [timeArray[0] intValue];
        float second = [timeArray[1] floatValue];
        model.currentTime = minute * 60 + second;
        
        [self.modelDataArr addObject:model];
    }
}

- (NSMutableArray *)modelDataArr
{
    if (_modelDataArr == nil) {
        _modelDataArr = [NSMutableArray array];
        
    }
    return _modelDataArr;
}

- (NSInteger)lyricIndexWithCurrentImte:(float)time
{
    NSInteger indexInArr = 0;
    for (int i = 1; i < [lyricManager shareManager].modelDataArr.count; i++) {
        lyricModel *model = [lyricManager shareManager].modelDataArr[i];
        lyricModel *model1 = [lyricManager shareManager].modelDataArr[i - 1];
        if (time < model.currentTime - 1.4 && time > model1.currentTime - 1.4) {
            indexInArr = [[lyricManager shareManager].modelDataArr indexOfObject:model1];
            
        }
    }
    return indexInArr;
}

@end
