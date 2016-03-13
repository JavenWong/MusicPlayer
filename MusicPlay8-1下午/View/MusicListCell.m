//
//  MusicListCell.m
//  MusicPlay8-1下午
//
//  Created by JavenWong on 16/1/21.
//  Copyright © 2016年 JavenWong. All rights reserved.
//

#import "MusicListCell.h"
#import "UIImageView+WebCache.h"

@interface MusicListCell ()

@end


@implementation MusicListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    
//}

- (UIImageView *)picImageView
{
    if (!_picImageView) {
        _picImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 55, 55)];
        [self.contentView addSubview:_picImageView];
    }
    return _picImageView;
}

- (UILabel *)musicNameLabel
{
    if (!_musicNameLabel) {
        _musicNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.picImageView.frame) + 10, 10, [UIScreen mainScreen].bounds.size.width - 85, 21)];
        _musicNameLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_musicNameLabel];
    }
    return _musicNameLabel;
}

- (UILabel *)singerNameLabel
{
    if (!_singerNameLabel) {
        _singerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.picImageView.frame) + 10, CGRectGetMaxY(self.musicNameLabel.frame) + 10, [UIScreen mainScreen].bounds.size.width - 85, 21)];
        _singerNameLabel.textColor = [UIColor lightGrayColor];
        
        [self.contentView addSubview:_singerNameLabel];
    }
    return _singerNameLabel;
}

- (void)cellWithModel:(MusicInfoModel *)model
{
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    self.singerNameLabel.text = model.singer;
    self.musicNameLabel.text = model.name;
    
}

@end
