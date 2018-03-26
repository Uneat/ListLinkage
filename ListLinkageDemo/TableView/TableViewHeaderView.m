//
//  TableViewHeaderView.m
//  ListLinkageDemo
//
//  Created by Orient on 2018/1/31.
//  Copyright © 2018年 Orient. All rights reserved.
//

#import "TableViewHeaderView.h"

@implementation TableViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:0.8];
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 30)];
        self.name.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.name];
    }
    return self;
}

@end
