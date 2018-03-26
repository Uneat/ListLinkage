//
//  CollectionCellModel.h
//  ListLinkageDemo
//
//  Created by Orient on 2018/1/30.
//  Copyright © 2018年 Orient. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionCellModel : NSObject
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSArray *subcategories;
@end

@interface SubCategoryModel : NSObject

@property (nonatomic, copy)NSString *icon_url;
@property (nonatomic, copy)NSString *name;
@end
