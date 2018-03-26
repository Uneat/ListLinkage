//
//  CategoryModel.m
//  ListLinkageDemo
//
//  Created by Orient on 2018/1/31.
//  Copyright © 2018年 Orient. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

+ (NSDictionary *)objectClassInArray
{
    return @{ @"spus": @"FoodModel" };
}

@end

@implementation FoodModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{ @"foodId": @"id" };
}

@end
