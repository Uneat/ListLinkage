//
//  CustomCollectionViewCell.m
//  ListLinkageDemo
//
//  Created by Orient on 2018/1/29.
//  Copyright © 2018年 Orient. All rights reserved.
//

#import "CustomCollectionViewCell.h"
#import "CollectionCellModel.h"
#import "UIImageView+WebCache.h"
#define SCREEN_WIDTH               ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT              ([[UIScreen mainScreen] bounds].size.height)

@interface CustomCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *name;

@end
@implementation CustomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setBackgroundColor:[UIColor whiteColor]];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, self.frame.size.width - 4, self.frame.size.width - 4)];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageView];
        
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(2, self.frame.size.width + 2, self.frame.size.width - 4, 20)];
        self.name.font = [UIFont systemFontOfSize:13];
        self.name.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.name];
        
    }
    return self;
}

- (void)setModel:(SubCategoryModel *)model
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.icon_url]];
    self.name.text = model.name;
}
@end
