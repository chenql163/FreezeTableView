//
//  ViewController.m
//  FreezeTableView
//
//  Created by apple on 13-8-19.
//  Copyright (c) 2013年 Gemstar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    FreezeMultiColumnTableView *tableView = [[FreezeMultiColumnTableView alloc] initWithFrame:self.view.frame];
    tableView.dataSource = self;
    tableView.scrollMethod = kScrollMethodWithRight;
    [self.view addSubview:tableView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark freezeTableViewDataSource

//返回总列数
-(NSInteger)numberOfColumnsForMultiColumnTableView:(FreezeMultiColumnTableView*)tableView{
    return 10;
}
//返回冻结列数,0-小于总列数的值范围内取值,为0表示不冻结
-(NSInteger)numberOfFreezeColumnsForMultiColumnTableView:(FreezeMultiColumnTableView*)tableView{
    return 2;
}
//获取每一列的宽度
-(float)freezeMultiColumnTableView:(FreezeMultiColumnTableView*)tableView widthForColumnAtIndex:(NSInteger)index{
    return 70;
}
//返回总行数
-(NSInteger)numberOfRowsForMultiColumnTableview:(FreezeMultiColumnTableView*)tableView{
    return 50;
}
//设置每一列的标题
-(void)freezemultiColumnTableView:(FreezeMultiColumnTableView*)tableView setContentForColumn:(NSInteger)column inView:(UIView*)view{
    CGRect frame = view.frame;
    float width = CGRectGetWidth(frame);
    float height = CGRectGetHeight(frame);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    label.backgroundColor = [UIColor clearColor];
    label.text = [NSString stringWithFormat:@"Col %d",column+1];
    
    [view addSubview:label];
    view.backgroundColor = [UIColor grayColor];    
}
//设置每一单元格的内容
-(void)freezeMultiColumnTableview:(FreezeMultiColumnTableView*)tableView setContentAtRow:(NSInteger)row andcolumn:(NSInteger)column inView:(UIView*)view{
    CGRect frame = view.frame;
    float width = CGRectGetWidth(frame);
    float height = CGRectGetHeight(frame);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    label.backgroundColor = [UIColor clearColor];
    label.text = [NSString stringWithFormat:@"%d:%d",row+1,column+1];
    
    [view addSubview:label];    
}
@end
