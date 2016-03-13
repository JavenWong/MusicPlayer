//
//  MusicManager.h
//  MusicPlay8-1下午
//
//  Created by JavenWong on 16/1/22.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicInfoModel.h"
#import "UIViewController+HUD.h"

typedef void(^dataBlock)(int);
@interface MusicManager : NSObject

@property (nonatomic, assign) NSInteger index;

// 初始化一个单利对象
+ (instancetype)shareManager;

- (void)requestDataWithBlock:(dataBlock)myBlock withVC:(UIViewController *)vc;
- (void)requestDataWithGCD;


- (NSInteger)returnModelArrayCount;

// 返回index对应的model
- (MusicInfoModel *)modelAtIndex:(NSInteger)indexPathrow;
@end
