//
//  TableViewController.m
//  ListLinkageDemo
//
//  Created by Orient on 2018/1/31.
//  Copyright © 2018年 Orient. All rights reserved.
//

#import "TableViewController.h"
#import "LeftTableViewCell.h"
#import "RightTableViewCell.h"
#import "TableViewHeaderView.h"
#import "CategoryModel.h"
#import "NSObject+Property.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


static NSString * leftCellID = @"leftCell";
static NSString * rightCellID = @"rightCell";
@interface TableViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)UITableView *leftTableView;
@property (nonatomic, strong)UITableView *rightTableView;

@property (nonatomic, strong)NSMutableArray * leftDataSource;
@property (nonatomic, strong)NSMutableArray * rightDataSource;
@end

@implementation TableViewController
{
    NSInteger _selectIndex;
    BOOL _isScrollDown;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor cyanColor]];
    
    
    _selectIndex = 0;
    _isScrollDown = YES;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"meituan" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSArray *foods = dict[@"data"][@"food_spu_tags"];
    
    for (NSDictionary *dict in foods)
    {
        CategoryModel *model = [CategoryModel objectWithDictionary:dict];
        [self.rightDataSource addObject:model];
        
        NSMutableArray *datas = [NSMutableArray array];
        for (FoodModel *f_model in model.spus)
        {
            [datas addObject:f_model];
        }
        [self.leftDataSource addObject:datas];
    }
    
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightTableView];
    
    [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    
}



#pragma mark ---- 懒加载

- (UITableView *)leftTableView{
    if(!_leftTableView){
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 80, SCREEN_HEIGHT)];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.rowHeight = 55.0f;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.separatorColor = [UIColor clearColor];
        [_leftTableView registerClass:[LeftTableViewCell class] forCellReuseIdentifier:leftCellID];
    }
    return _leftTableView;
}

- (UITableView *)rightTableView{
    if(!_rightTableView){
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(80, 64, SCREEN_WIDTH - 80, SCREEN_HEIGHT-64)];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.rowHeight = 80;
        _rightTableView.showsVerticalScrollIndicator = NO;
        [_rightTableView registerClass:[RightTableViewCell class] forCellReuseIdentifier:rightCellID];
        
    }
    return _rightTableView;
}

- (NSMutableArray *)leftDataSource{
    if(!_leftDataSource){
        _leftDataSource = [NSMutableArray array];
    }
    return _leftDataSource;
}
- (NSMutableArray *)rightDataSource{
    if(!_rightDataSource){
        _rightDataSource = [NSMutableArray array];
    }
    return _rightDataSource;
}

#pragma mark --- tableView delegate datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_leftTableView==tableView){
        return 1;
    }else{
        return self.rightDataSource.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_leftTableView==tableView){
        return self.rightDataSource.count;
    }else{
        return [self.leftDataSource[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_leftTableView == tableView){
        LeftTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:leftCellID forIndexPath:indexPath];
        FoodModel * model = self.rightDataSource[indexPath.row];
        cell.name.text = model.name;
        return cell;
    }else{
        RightTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:rightCellID forIndexPath:indexPath];
        FoodModel * model = self.leftDataSource[indexPath.section][indexPath.row];
        cell.model = model;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(_rightTableView == tableView){
        return 30;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(_rightTableView == tableView){
        TableViewHeaderView * view = [[TableViewHeaderView alloc]initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
        FoodModel * model = self.rightDataSource[section];
        view.name.text = model.name;
        return view;
    }
    return nil;
}
//往下拖动的时候
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    if((_rightTableView == tableView) && !_isScrollDown && _rightTableView.dragging){
        [self selectRowAtIndexPath:section];
    }
}
//往上拖动的时候
- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section{
    if((_rightTableView == tableView) && _isScrollDown && _rightTableView.dragging){
        [self selectRowAtIndexPath:section + 1];
    }
}
//左边tableview被点击的时候
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(_leftTableView == tableView){
        _selectIndex = indexPath.row;
        [_rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:_selectIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void)selectRowAtIndexPath:(NSInteger)index{
    [_leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark - scrollViewdelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    static CGFloat lastOffsetY = 0;
    UITableView * tableView = (UITableView *)scrollView;
    if(_rightTableView == tableView){
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}


@end
