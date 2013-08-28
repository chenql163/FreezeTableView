//
//  FreezeMultiColumnTableView.h
//  GSManager
//
//  Created by apple on 13-8-19.
//  Copyright (c) 2013年 Gemstar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kScrollMethodWithLeft = 0,//左边滚动
    kScrollMethodWithRight,//右边滚动
    kScrollMethodWithAll
}ScrollMethod;

@class FreezeMultiColumnTableView;

@protocol freezeMultiColumnTableViewDataSource <NSObject>

//返回总列数
-(NSInteger)numberOfColumnsForMultiColumnTableView:(FreezeMultiColumnTableView*)tableView;
//返回冻结列数,0-小于总列数的值范围内取值,为0表示不冻结
-(NSInteger)numberOfFreezeColumnsForMultiColumnTableView:(FreezeMultiColumnTableView*)tableView;
//获取每一列的宽度
-(float)freezeMultiColumnTableView:(FreezeMultiColumnTableView*)tableView widthForColumnAtIndex:(NSInteger)index;
//返回总行数
-(NSInteger)numberOfRowsForMultiColumnTableview:(FreezeMultiColumnTableView*)tableView;
//设置每一列的标题
-(void)freezemultiColumnTableView:(FreezeMultiColumnTableView*)tableView setContentForColumn:(NSInteger)column inView:(UIView*)view;
//设置每一单元格的内容
-(void)freezeMultiColumnTableview:(FreezeMultiColumnTableView*)tableView setContentAtRow:(NSInteger)row andcolumn:(NSInteger)column inView:(UIView*)view;

@end

@interface FreezeMultiColumnTableView : UIView<UITableViewDataSource,UITableViewDelegate>
@property(assign,nonatomic) ScrollMethod scrollMethod;
@property(weak,nonatomic) id<freezeMultiColumnTableViewDataSource> dataSource;
-(void)reloadData;
@end
