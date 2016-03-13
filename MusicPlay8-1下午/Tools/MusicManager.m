//
//  MusicManager.m
//  MusicPlay8-1下午
//
//  Created by JavenWong on 16/1/22.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "MusicManager.h"
#import "MusicInfoModel.h"
#import "Reachability.h"

@interface MusicManager ()
@property (nonatomic, strong) NSMutableArray *modelDataArr;
@end




@implementation MusicManager

+ (instancetype)shareManager
{
    static MusicManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[MusicManager alloc] init];
        }
    });
    return manager;
    
//    @synchronized(self) {
//        if (manager == nil) {
//            manager = [[MusicManager alloc] init];
//        }
//        return manager;
//    }
}

- (void)requestDataWithBlock:(dataBlock)myBlock withVC:(UIViewController *)vc
{
    if ([self isNetWork]) {
        NSArray *array = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:@"http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist"]];
        for (int i = 0; i < array.count; i++) {
//            MusicInfoModel *model = [MusicInfoModel modelWithDic:array[i]];
            MusicInfoModel *model = [[MusicInfoModel alloc] init];
            [model setValuesForKeysWithDictionary:array[i]];
            [self.modelDataArr addObject:model];
        }
        MBProgressHUD *hud = [vc showHUDwith:@"wait a minute"];
        [vc hideHUD:hud];
        myBlock(1);
    }
}

- (void)requestDataWithGCD
{
    if ([self isNetWork]) {
        NSArray *array = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:@"http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist"]];
        for (int i = 0; i < array.count; i++) {
            MusicInfoModel *model = [MusicInfoModel modelWithDic:array[i]];
            [self.modelDataArr addObject:model];
        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//        });
    }
}

#pragma mark - netWork
- (BOOL)isNetWork
{
    BOOL isNetWork;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            NSLog(@"没有网络");
            isNetWork = NO;
            break;
        case ReachableViaWiFi:
            isNetWork = YES;
            break;
        case ReachableViaWWAN:
            isNetWork = YES;
            break;
        default:
            break;
    }
    return isNetWork;
}

- (NSInteger)returnModelArrayCount
{
    return self.modelDataArr.count;
}

- (MusicInfoModel *)modelAtIndex:(NSInteger)indexPathrow
{
    return self.modelDataArr[indexPathrow];
}

- (NSMutableArray *)modelDataArr
{
    if (_modelDataArr == nil) {
        _modelDataArr = [NSMutableArray array];
    }
    return _modelDataArr;
}


@end
