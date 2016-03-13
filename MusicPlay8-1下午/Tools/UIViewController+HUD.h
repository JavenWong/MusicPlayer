//
//  UIViewController+HUD.h
//  MusicPlay8-1下午
//
//  Created by JavenWong on 16/1/22.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Reachability.h"

@interface UIViewController (HUD)

// 显示菊花加文字
- (MBProgressHUD *)showHUDwith:(NSString *)str;

// 隐藏菊花
- (void)hideHUD:(MBProgressHUD *)hud;

// 只显示文字和提示
- (void)AlertOnlyLabelWithStr:(NSString *)str;


@end
