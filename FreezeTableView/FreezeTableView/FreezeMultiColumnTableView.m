//
//  FreezeMultiColumnTableView.m
//  GSManager
//
//  Created by apple on 13-8-19.
//  Copyright (c) 2013年 Gemstar. All rights reserved.
//

#import "FreezeMultiColumnTableView.h"

#define normalSeperatorLineWidth 1.0f
#define normalSeperatorLineColor [UIColor colorWithWhite:223.0f/255.0f alpha:1.0]
#define HeightForSectionHeader 46

@interface FreezeMultiColumnTableView()
@property(strong,nonatomic) UIScrollView *leftScrollView,*rightScrollView;
@property(strong,nonatomic) UITableView *leftTableView,*rightTableView;
@end

@implementation FreezeMultiColumnTableView
-(void)layoutSubviews{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.backgroundColor = [UIColor clearColor];
    
    float leftWidth = 0;//左边tableview的宽度
    float rightWidth = 0;//右边tableview的宽度
    int count = [self.dataSource numberOfColumnsForMultiColumnTableView:self];
    int freezeCount = [self.dataSource numberOfFreezeColumnsForMultiColumnTableView:self];
    for (int i = 0; i<count; i++) {
        float columnWidth = [self.dataSource freezeMultiColumnTableView:self widthForColumnAtIndex:i];
        if (i<freezeCount) {
            leftWidth += columnWidth;
        }else{
            rightWidth += columnWidth;
        }
    }
    
    //scrollview
    float leftScrollWidth = 0;
    float rightScrollWidth = 0;
    CGSize size = self.frame.size;
    @try {
        if (self.scrollMethod == kScrollMethodWithLeft) {
            if (rightWidth > size.width) {
                @throw [NSException exceptionWithName:@"width small" reason:@"" userInfo:nil];
            }
            rightScrollWidth = rightWidth;
            leftScrollWidth = size.width - rightScrollWidth;
        } else if (self.scrollMethod == kScrollMethodWithRight) {
            if (leftWidth > size.width) {
                @throw [NSException exceptionWithName:@"width small" reason:@"" userInfo:nil];
            }
            leftScrollWidth = leftWidth;
            rightScrollWidth = size.width - leftScrollWidth;
        } else {
            leftScrollWidth = rightScrollWidth = size.width / 2.0 ;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"ERROR:%@", exception.name);
        NSAssert(false, @"width small");
    }
    
    UIScrollView *leftScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, leftScrollWidth, size.height)];
    [leftScrollView setShowsHorizontalScrollIndicator:FALSE];
    [leftScrollView setShowsVerticalScrollIndicator:FALSE];
    self.leftScrollView = leftScrollView;
    
    UIScrollView *rightScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(leftScrollWidth, 0, rightScrollWidth, size.height)];
    [rightScrollView setShowsHorizontalScrollIndicator:FALSE];
    [rightScrollView setShowsVerticalScrollIndicator:FALSE];
    self.rightScrollView = rightScrollView;
    
    //tableView
    UITableView *leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, leftWidth, size.height)];
    leftTableView.delegate = self;
    leftTableView.dataSource = self;
    [leftTableView setShowsHorizontalScrollIndicator:NO];
    [leftTableView setShowsVerticalScrollIndicator:NO];
    leftTableView.sectionHeaderHeight = HeightForSectionHeader;
    leftTableView.backgroundColor = [UIColor clearColor];
    self.leftTableView = leftTableView;
    
    UITableView *rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, rightWidth, size.height)];
    rightTableView.delegate = self;
    rightTableView.dataSource = self;
    [rightTableView setShowsHorizontalScrollIndicator:NO];
    [rightTableView setShowsVerticalScrollIndicator:NO];
    rightTableView.sectionHeaderHeight = HeightForSectionHeader;
    rightTableView.backgroundColor = [UIColor clearColor];
    self.rightTableView = rightTableView;
    
    [self.leftScrollView addSubview:_leftTableView];
    [self.rightScrollView addSubview:_rightTableView];
    [self.leftScrollView setContentSize:_leftTableView.frame.size];
    [self.rightScrollView setContentSize:_rightTableView.frame.size];
    
    [self addSubview:_leftScrollView];
    [self addSubview:_rightScrollView];
}
-(void)reloadData{
    [self layoutSubviews];
    [self.leftTableView reloadData];
    [self.rightTableView reloadData];
}

#pragma mark - TableView DataSource Methods

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:_leftTableView]) {
        return [self leftViewTableView:tableView viewForHeaderInSection:section];
    } else {
        return [self contentTableView:tableView viewForHeaderInSection:section];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_leftTableView]) {
        return [self leftViewTableView:tableView cellForRowAtIndexPath:indexPath];
    } else {
        return [self contentTableView:tableView cellForRowAtIndexPath:indexPath];
    }
}
-(UIView*)leftViewTableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HeightForSectionHeader)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:headerView.frame];
    imgView.image = [UIImage imageNamed:@"titleBg.png"];
    [headerView addSubview:imgView];
    
    int count = [self.dataSource numberOfFreezeColumnsForMultiColumnTableView:self];
    CGFloat locationX = 0;
    
    for (int i = 0; i < count; i++) {
        
        CGFloat cellW = [self.dataSource freezeMultiColumnTableView:self widthForColumnAtIndex:i];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(locationX, 0, cellW, headerView.frame.size.height)];
        locationX += cellW;
        
        [self.dataSource freezemultiColumnTableView:self setContentForColumn:i inView:view];
        
        [headerView addSubview:view];
    }
    
    //    AddHeightTo(cell, normalSeperatorLineWidth);
    
    return headerView;
}

-(UIView*)contentTableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HeightForSectionHeader)];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:headerView.frame];
    imgView.image = [UIImage imageNamed:@"titleBg.png"];
    [headerView addSubview:imgView];
    
    int count = [self.dataSource numberOfColumnsForMultiColumnTableView:self];
    int freezeCount = [self.dataSource numberOfFreezeColumnsForMultiColumnTableView:self];
    
    float locationX=0;
    for (int i = freezeCount; i < count; i++) {
        
        CGFloat cellW = [self.dataSource freezeMultiColumnTableView:self widthForColumnAtIndex:i];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(locationX, 0, cellW, headerView.frame.size.height)];
        locationX += cellW;
        
        [self.dataSource freezemultiColumnTableView:self setContentForColumn:i inView:view];
        
        [headerView addSubview:view];
    }
    
    //    AddHeightTo(cell, normalSeperatorLineWidth);
    
    return headerView;
}
- (UITableViewCell *)leftViewTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"leftHeaderTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell addBottomLineWithWidth:normalSeperatorLineWidth bgColor:normalSeperatorLineColor];
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int count = [self.dataSource numberOfFreezeColumnsForMultiColumnTableView:self];
    CGFloat locationX = 0;
    
    for (int i = 0; i < count; i++) {
        
        CGFloat cellW = [self.dataSource freezeMultiColumnTableView:self widthForColumnAtIndex:i];
        CGFloat cellH = [self cellHeightInIndexPath:indexPath];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(locationX, 0, cellW, cellH)];
        locationX += cellW;
        
        [self.dataSource freezeMultiColumnTableview:self setContentAtRow:indexPath.row andcolumn:i inView:view];
        
        [cell.contentView addSubview:view];
    }
    
//    AddHeightTo(cell, normalSeperatorLineWidth);
    
    return cell;
}
- (UITableViewCell *)contentTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    static NSString *cellID = @"contentTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        [cell addBottomLineWithWidth:normalSeperatorLineWidth bgColor:normalSeperatorLineColor];
    }
    
    [[cell.contentView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    int count = [self.dataSource numberOfColumnsForMultiColumnTableView:self];
    int freezeCount = [self.dataSource numberOfFreezeColumnsForMultiColumnTableView:self];
    
    float locationX=0;
    for (int i = freezeCount; i < count; i++) {
        
        CGFloat cellW = [self.dataSource freezeMultiColumnTableView:self widthForColumnAtIndex:i];
        CGFloat cellH = [self cellHeightInIndexPath:indexPath];
                
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(locationX, 0, cellW, cellH)];
        locationX += cellW;
        
        [self.dataSource freezeMultiColumnTableview:self setContentAtRow:indexPath.row andcolumn:i inView:view];
        
        [cell.contentView addSubview:view];
    }
    
//    AddHeightTo(cell, normalSeperatorLineWidth);
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource numberOfRowsForMultiColumnTableview:self];
}

- (CGFloat)cellHeightInIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
#pragma mark - TableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellHeightInIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_leftTableView]) {
        [self.rightTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    } else {
        [self.leftTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:_leftTableView]) {
        self.rightTableView.contentOffset = _leftTableView.contentOffset;
    } else {
        self.leftTableView.contentOffset = _rightTableView.contentOffset;
    }
}
#pragma mark 表格线
- (void)addBottomLineWithWidth:(CGFloat)width bgColor:(UIColor *)color {
    CGRect f = self.frame;
    f.size.height += width;
    self.frame = f;
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height - width, self.frame.size.width, width)];
    bottomLine.backgroundColor = color;
    bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self addSubview:bottomLine];
}

- (UIView *)addVerticalLineWithWidth:(CGFloat)width bgColor:(UIColor *)color atX:(CGFloat)x {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, 0.0f, width, self.bounds.size.height)];
    line.backgroundColor = color;
    line.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:line];
    return line;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
