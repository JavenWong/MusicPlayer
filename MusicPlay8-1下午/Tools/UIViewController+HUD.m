//
//  UIViewController+HUD.m
//  MusicPlay8-1下午
//
//  Created by JavenWong on 16/1/22.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "UIViewController+HUD.h"
#import "MBProgressHUD.h"

@implementation UIViewController (HUD)

- (MBProgressHUD *)showHUDwith:(NSString *)str
{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithFrame:self.view.bounds];
    hud.labelText = str;
    hud.mode = MBProgressHUDModeText;
    [hud show:YES];
    [self.view addSubview:hud];
    
    hud.tag = 100;
    return hud;
}

- (void)hideHUD:(MBProgressHUD *)hud
{
    [hud hide:YES afterDelay:1];
}

- (void)AlertOnlyLabelWithStr:(NSString *)str
{
    
}


@end
