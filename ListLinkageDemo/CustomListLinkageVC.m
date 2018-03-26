//
//  CustomListLinkageVC.m
//  ListLinkageDemo
//
//  Created by Orient on 2018/1/29.
//  Copyright © 2018年 Orient. All rights reserved.
//

#import "CustomListLinkageVC.h"
#import "CollectionViewController.h"
#import "TableViewController.h"
#define SCREEN_WIDTH               ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT              ([[UIScreen mainScreen] bounds].size.height)
//
//static NSString *TableViewCell = @"TableViewCell";
//static NSString * CollectionViewCell = @"CollectionViewCell";
//static NSString * CollectionViewHeader = @"CollectionViewHeader";
@interface CustomListLinkageVC ()



@end

@implementation CustomListLinkageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    [self addBtn];
    
}

- (void)addBtn{
    NSInteger marginX = 30 ;
    NSInteger marginY = self.view.center.y;
    NSInteger btnWidth = (SCREEN_WIDTH - 3 * marginX) / 2;
    NSInteger btnHeight = 40;
    
    for (NSInteger i=0; i<2; i++) {
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(marginX + i*(marginX + btnWidth), marginY, btnWidth, btnHeight)];
        [button setTag:100+i];
        if(i){
            [button setTitle:@"Collection" forState:UIControlStateNormal];
        }else{
            [button setTitle:@"TableView" forState:UIControlStateNormal];
        }
        [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
    }
}

- (void)btnClick:(UIButton *)button{
    switch (button.tag) {
        case 100:
        {
            TableViewController * tableViewVC = [[TableViewController alloc]init];
            [self.navigationController pushViewController:tableViewVC animated:YES];
        }
            break;
        case 101:
        {
            CollectionViewController * collectionVC = [[CollectionViewController alloc]init];
            [self.navigationController pushViewController:collectionVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}


@end
