//
//  FirstViewController.m
//  BindVCDemo
//
//  Created by 黄鹏飞 on 16/2/23.
//  Copyright © 2016年 黄鹏飞. All rights reserved.
//

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#import "BaseViewController.h"

@interface BaseViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) UITableView *tableView;
@property (strong,nonatomic) NSArray *dataArray;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索控件";
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *className = self.dataArray[indexPath.row];
    Class class = NSClassFromString(className);
    UIViewController *viewController = class.new;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (NSArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSArray arrayWithObjects:@"FFSearchController",@"FFSearchDisplayController", nil];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}
@end
