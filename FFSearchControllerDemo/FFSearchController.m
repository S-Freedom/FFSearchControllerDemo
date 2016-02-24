//
//  FirstViewController.m
//  BindVCDemo
//
//  Created by 黄鹏飞 on 16/2/23.
//  Copyright © 2016年 黄鹏飞. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#import "FFSearchController.h"

@interface FFSearchController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchResultsUpdating,UISearchControllerDelegate>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UISearchController *searchController;
@property (strong,nonatomic) NSMutableArray *dataList;
@property (strong,nonatomic) NSMutableArray *searchList;
@end

@implementation FFSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FFSearchController";
    [self loadData];
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.view addSubview:self.tableView];
}

- (void)loadData{
    for (int i=0; i<100; i++) {
        [self.dataList addObject:[NSString stringWithFormat:@"我是-%i",i]];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.searchController.active)
        return self.searchList.count;
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if(self.searchController.active){
        if(indexPath.row <= self.searchList.count)
            cell.textLabel.text = self.searchList[indexPath.row];
        else
            cell.textLabel.text = self.dataList[indexPath.row];
    }
    else
        cell.textLabel.text = self.dataList[indexPath.row];
    return cell;
}

#pragma mark --UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchStr = self.searchController.searchBar.text;
    
    if(searchStr.length > 0){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchStr];
        if(self.searchList != nil){
            [self.searchList removeAllObjects];
        }
        self.searchList = [NSMutableArray arrayWithArray:[self.dataList filteredArrayUsingPredicate:predicate]];
        [self.tableView reloadData];
    }
}

#pragma mark --UISearchControllerDelegate
- (void)willPresentSearchController:(UISearchController *)searchController{
    
}
- (void)didPresentSearchController:(UISearchController *)searchController{
    
}
- (void)willDismissSearchController:(UISearchController *)searchController{
    
}
- (void)didDismissSearchController:(UISearchController *)searchController{
    [self.tableView reloadData];
}

- (UISearchController *)searchController{
    if(!_searchController)
    {
        _searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.delegate = self;
        
        // 很重要, 是否将背景设置为灰色
        _searchController.dimsBackgroundDuringPresentation = YES;
        _searchController.obscuresBackgroundDuringPresentation = NO;
        
        //点击的时候是否隐藏导航栏, 默认是YES
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44);
        
    }
    return _searchController;
}

- (NSMutableArray *)dataList{
    if(!_dataList)
    {
        _dataList = [NSMutableArray arrayWithCapacity:100];
    }
    return _dataList;
}

- (NSMutableArray *)searchList{
    if(!_searchList){
        _searchList = [NSMutableArray arrayWithCapacity:100];
    }
    return _searchList;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
@end