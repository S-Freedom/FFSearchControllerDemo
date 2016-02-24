//
//  FirstViewController.m
//  BindVCDemo
//
//  Created by 黄鹏飞 on 16/2/23.
//  Copyright © 2016年 黄鹏飞. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#import "FFSearchDisplayController.h"

@interface FFSearchDisplayController () <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) UISearchDisplayController *searchDisplayController;
@property (strong,nonatomic) UISearchBar *searchBar;
@property (strong,nonatomic) NSMutableArray *dataList;
@property (strong,nonatomic) NSMutableArray *searchList;
@end

@implementation FFSearchDisplayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"FFSearchDisplayController(DEPRECATED)";
    for (int i=0; i<100; i++) {
        [self.dataList addObject:[NSString stringWithFormat:@"我是-%i",i]];
    }
    self.tableView.tableHeaderView = self.searchBar;
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.searchDisplayController.searchResultsTableView == tableView)
        return self.searchList.count;
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    if(self.searchDisplayController.searchResultsTableView == tableView){
        if(indexPath.row <= self.searchList.count)
            cell.textLabel.text = self.searchList[indexPath.row];
        else
            cell.textLabel.text = self.dataList[indexPath.row];
    }
    else
        cell.textLabel.text = self.dataList[indexPath.row];
    return cell;
}

#pragma mark --UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    NSLog(@"%s",__func__);
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    NSLog(@"%s",__func__);
    return  YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(nullable NSString *)searchString NS_DEPRECATED_IOS(3_0,8_0){
    NSLog(@"%s",__func__);
     NSString *searchStr = self.searchDisplayController.searchBar.text;
    if(searchStr.length > 0){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchStr];
        if(self.searchList != nil){
            [self.searchList removeAllObjects];
        }
        self.searchList = [NSMutableArray arrayWithArray:[self.dataList filteredArrayUsingPredicate:predicate]];
        [self.tableView reloadData];
    }

    return YES;
}

- (UISearchController *)searchDisplayController{
    if(!_searchDisplayController)
    {
        _searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self];
        _searchDisplayController.searchResultsDelegate = self;
        _searchDisplayController.searchResultsDataSource = self;
        _searchDisplayController.delegate = self;
    }
    return _searchDisplayController;
}

- (UISearchBar *)searchBar{
    if(!_searchBar){
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        _searchBar.delegate = self;
    }
    return _searchBar;
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
