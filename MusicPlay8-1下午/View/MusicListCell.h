//
//  MusicListCell.h
//  MusicPlay8-1下午
//
//  Created by JavenWong on 16/1/21.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicInfoModel.h"

@interface MusicListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) UILabel *musicNameLabel;
@property (nonatomic, strong) UILabel *singerNameLabel;

- (void)cellWithModel:(MusicInfoModel *)model;

@end
