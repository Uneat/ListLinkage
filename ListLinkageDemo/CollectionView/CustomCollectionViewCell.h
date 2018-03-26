//
//  CustomCollectionViewCell.h
//  ListLinkageDemo
//
//  Created by Orient on 2018/1/29.
//  Copyright © 2018年 Orient. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SubCategoryModel;
@interface CustomCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) SubCategoryModel *model;
@end
