//
//  CollectionViewController.m
//  ListLinkageDemo
//
//  Created by Orient on 2018/1/29.
//  Copyright © 2018年 Orient. All rights reserved.
//

#import "CollectionViewController.h"
#import "CustomTableViewCell.h"
#import "CustomCollectionViewCell.h"
#import "CollectionHeaderView.h"
#import "LJCollectionViewFlowLayout.h"
#import "CollectionCellModel.h"
#import "NSObject+Property.h"


#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//
static NSString *TableViewCell = @"TableViewCell";
static NSString * CollectionViewCell = @"CollectionViewCell";
static NSString * CollectionViewHeader = @"CollectionViewHeader";
@interface CollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UICollectionView * collectionView;
@property (nonatomic,strong)UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@property (nonatomic, strong) NSMutableArray * collectionData;

@end

@implementation CollectionViewController
{
     BOOL _isScrollDown;
    NSInteger _selectIndex;
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout=UIRectEdgeNone;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.title = @"联动";
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.tableView];
//    [self.collectionView reloadData];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"liwushuo" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//    NSLog(@"%@",dict);
    NSArray * categories = dict[@"data"][@"categories"];
    
    for (NSDictionary *dict in categories) {
        CollectionCellModel *model = [CollectionCellModel objectWithDictionary:dict];
        [self.dataSource addObject:model];
        
        NSMutableArray * datas = [NSMutableArray array];
        
        for (SubCategoryModel *subModel in model.subcategories) {
            [datas addObject:subModel];
        }
        [self.collectionData addObject:datas];
    }
    [self.tableView reloadData];
    [self.collectionView reloadData];
       [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    
//    [];
    
    
}


#pragma mark --懒加载

- (UICollectionView *)collectionView{
    if(!_collectionView){
        NSInteger marginX = SCREEN_WIDTH/4;
        NSInteger marginY = 0;
        NSInteger W = (SCREEN_WIDTH / 4) * 3;
        NSInteger H = SCREEN_HEIGHT;
        LJCollectionViewFlowLayout * layout = [[LJCollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 4;
        layout.minimumInteritemSpacing = 2;
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(marginX, marginY, W, H) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [_collectionView registerClass:[CustomCollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCell];
        
        [_collectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionViewHeaderView"];
        

        
    }
    
    return _collectionView;
}
- (NSMutableArray *)dataSource{
    if(!_dataSource){
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}

- (NSMutableArray *)collectionData{
    if(!_collectionData){
        _collectionData = [[NSMutableArray alloc]init];
    }
    return _collectionData;
}
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH/ 4, SCREEN_HEIGHT-64)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 55;
        NSLog(@"----------->%ld",(long)SCREEN_HEIGHT);
//        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView registerClass:[CustomTableViewCell class] forCellReuseIdentifier:TableViewCell];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorColor = [UIColor whiteColor];
        
    }
    return _tableView;
}


#pragma  mark -- tableView delegate dataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCell];
    CollectionCellModel *model = self.dataSource[indexPath.row];
    cell.name.text = model.name;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectIndex = indexPath.row;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:_selectIndex] atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
}

#pragma mark -- collectionViewDelegate dataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataSource.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    CollectionCellModel * model = self.dataSource[section];
    return model.subcategories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CustomCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCell forIndexPath:indexPath];
    SubCategoryModel *model = self.collectionData[indexPath.section][indexPath.row];
    cell.model = model;
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 30);
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{

    return CGSizeMake((SCREEN_WIDTH - 80 - 4 - 4) / 3,
                      (SCREEN_WIDTH - 80 - 4 - 4) / 3 + 30);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
     NSString *reuseIdentifier;
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        reuseIdentifier = @"CollectionViewHeaderView";
    }
    
    CollectionHeaderView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    [headerView setBackgroundColor:[UIColor redColor]];
    if([kind isEqualToString:UICollectionElementKindSectionHeader]){
        CollectionCellModel *model = self.dataSource[indexPath.section];
        headerView.title.text = model.name;
    }
    
    return headerView;
}

// CollectionView分区标题即将展示
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    // 当前CollectionView滚动的方向向上，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (!_isScrollDown && collectionView.dragging)
    {
        [self selectRowAtIndexPath:indexPath.section];
    }
}

// CollectionView分区标题展示结束
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(nonnull UICollectionReusableView *)view forElementOfKind:(nonnull NSString *)elementKind atIndexPath:(nonnull NSIndexPath *)indexPath
{
    // 当前CollectionView滚动的方向向下，CollectionView是用户拖拽而产生滚动的（主要是判断CollectionView是用户拖拽而滚动的，还是点击TableView而滚动的）
    if (_isScrollDown && collectionView.dragging)
    {
        [self selectRowAtIndexPath:indexPath.section + 1];
    }
}

// 当拖动CollectionView的时候，处理TableView
- (void)selectRowAtIndexPath:(NSInteger)index
{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}
#pragma mark - UIScrollView Delegate
// 标记一下CollectionView的滚动方向，是向上还是向下
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    static float lastOffsetY = 0;
    
    if (self.collectionView == scrollView)
    {
        _isScrollDown = lastOffsetY < scrollView.contentOffset.y;
        lastOffsetY = scrollView.contentOffset.y;
    }
}

@end
