//
//  CustomTableViewCell.m
//  ListLinkageDemo
//
//  Created by Orient on 2018/1/29.
//  Copyright © 2018年 Orient. All rights reserved.
//

#import "CustomTableViewCell.h"
@interface CustomTableViewCell ()
@property (nonatomic, strong) UIView *yellowView;
@end
@implementation CustomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.name = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 40)];
        self.name.numberOfLines = 0;
        self.name.font = [UIFont systemFontOfSize:12];
        self.name.textColor = [UIColor colorWithRed:130.0/255.0f green:130.0/255.0f blue:130.0/255.0f alpha:1];
        self.name.highlightedTextColor = [UIColor colorWithRed:253.0/255.0f green:212.0/255.0f blue:49.0/255.0f alpha:1];
        [self.contentView addSubview:self.name];
        
        self.yellowView = [[UIView alloc]initWithFrame:CGRectMake(0, 5, 5, 45)];
        [self.yellowView setBackgroundColor:[UIColor yellowColor]];
        [self.contentView addSubview:self.yellowView];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : [UIColor colorWithWhite:0 alpha:0.1];
    self.highlighted = selected;
    self.name.highlighted = selected;
    self.yellowView.hidden = !selected;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


@end
