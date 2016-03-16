//
//  RMCalendarController.m
//  RMCalendar
//
//  Created by 迟浩东 on 15/7/15.
//  Copyright © 2015年 迟浩东(http://www.ruanman.net). All rights reserved.
//

#import "RMCalendarController.h"
#import "RMCalendarCollectionViewLayout.h"
#import "RMCalendarMonthHeaderView.h"
#import "RMCalendarLogic.h"
#import "NoneToDoubleCollectionCell.h"
#import "ThreeCollectionCell.h"
#import "FourCollectionCell.h"
#import "CalendarCollectionReusableView.h"

@interface RMCalendarController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation RMCalendarController

static NSString *MonthHeader = @"MonthHeaderView";
static NSString *topHeader = @"topHeader";
static NSString *DayCellOne = @"DayCell1";
static NSString *DayCellTwo = @"DayCell2";
static NSString *DayCellThree = @"DayCell3";


/**
 *  初始化模型数组对象
 */
- (NSMutableArray *)calendarMonth {
    if (!_calendarMonth) {
        _calendarMonth = [NSMutableArray array];
    }
    return _calendarMonth;
}

- (RMCalendarLogic *)calendarLogic {
    if (!_calendarLogic) {
        _calendarLogic = [[RMCalendarLogic alloc] init];
    }
    return _calendarLogic;
}

- (instancetype)initWithDays:(int)days showType:(CalendarShowType)type modelArrar:(NSMutableArray *)modelArr {
    self = [super init];
    if (!self) return nil;
    self.days = days;
    self.type = type;
    self.modelArr = modelArr;
    return self;
}

- (instancetype)initWithDays:(int)days showType:(CalendarShowType)type {
    self = [super init];
    if (!self) return nil;
    self.days = days;
    self.type = type;
    return self;
}

+ (instancetype)calendarWithDays:(int)days showType:(CalendarShowType)type modelArrar:(NSMutableArray *)modelArr {
    return [[self alloc] initWithDays:days showType:type modelArrar:modelArr];
}

+ (instancetype)calendarWithDays:(int)days showType:(CalendarShowType)type {
    return [[self alloc] initWithDays:days showType:type];
}

- (void)setModelArr:(NSMutableArray *)modelArr {
 
    _modelArr = modelArr;
   

}

-(void)setIsEnable:(BOOL)isEnable {
    _isEnable = isEnable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 定义Layout对象
    RMCalendarCollectionViewLayout *layout = [[RMCalendarCollectionViewLayout alloc] init];
    
    // 初始化CollectionView
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionView.scrollEnabled = NO;
    
#if !__has_feature(objc_arc)
    [layout release];
#endif
    
    // 注册CollectionView的Cell
    
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([NoneToDoubleCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:DayCellOne];
//    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ThreeCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:DayCellTwo];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([FourCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:DayCellThree];
    [self.collectionView registerClass:[RMCalendarMonthHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CalendarCollectionReusableView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:topHeader];
    
    //    self.collectionView.bounces = NO;//将网格视图的下拉效果关闭
    
    self.collectionView.delegate = self;//实现网格视图的delegate
    
    self.collectionView.dataSource = self;//实现网格视图的dataSource
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.collectionView];
    
    self.calendarMonth = [self getMonthArrayOfDays:self.days showType:self.type isEnable:self.isEnable modelArr:self.modelArr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  获取Days天数内的数组
 *
 *  @param days 天数
 *  @param type 显示类型
 *  @param arr  模型数组
 *  @return 数组
 */
- (NSMutableArray *)getMonthArrayOfDays:(int)days showType:(CalendarShowType)type isEnable:(BOOL)isEnable modelArr:(NSArray *)arr
{
    NSDate *date = [NSDate date];
    
    NSDate *selectdate  = [NSDate date];
    //返回数据模型数组
    return [self.calendarLogic reloadCalendarView:date selectDate:selectdate needDays:days showType:type isEnable:isEnable priceModelArr:arr];
}

#pragma mark - CollectionView 数据源

// 返回组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.calendarMonth.count;
}
// 返回每组行数
- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *arrary = [self.calendarMonth objectAtIndex:section];
    return arrary.count;
}

#pragma mark - CollectionView 代理

- (UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSArray *months = [self.calendarMonth objectAtIndex:indexPath.section];
    RMCalendarModel *model = [months objectAtIndex:indexPath.row];
     
 
    if (model.picModel.picArray.count < 3) {
        
        NoneToDoubleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DayCellOne forIndexPath:indexPath];
        cell.model = model;
        return cell;
    }
//    }else if(model.picModel.picArray.count >= 3){
//        
//        ThreeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DayCellTwo forIndexPath:indexPath];
//        cell.model = model;
//        return cell;
//    }
        FourCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DayCellThree forIndexPath:indexPath];
        cell.model = model;
        
        return cell;
  
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader && indexPath.section == 0){
        
      
            CalendarCollectionReusableView *topheader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:topHeader forIndexPath:indexPath];
            reusableview = topheader;
            return  reusableview;
    }else if(kind == UICollectionElementKindSectionHeader){
        

    
        NSMutableArray *month_Array = [self.calendarMonth objectAtIndex:indexPath.section];
        RMCalendarModel *model = [month_Array objectAtIndex:15];
        
        RMCalendarMonthHeaderView *monthHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader forIndexPath:indexPath];
        monthHeader.masterLabel.text = [NSString stringWithFormat:@"%lu月",(unsigned long)model.month];//@"日期";
        monthHeader.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8f];
        reusableview = monthHeader;
            }
    return reusableview;
    

 
    
}

- (void)collectionView:(nonnull UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSArray *months = [self.calendarMonth objectAtIndex:indexPath.section];
    RMCalendarModel *model = [months objectAtIndex:indexPath.row];
  
    if (model.style == CellDayTypeEmpty|| model.picModel.picArray.count == 0) {
        
    }else{
    NSLog(@"%@",model.picModel.picArray[0]);
    }
 
    
}


- (BOOL)collectionView:(nonnull UICollectionView *)collectionView shouldSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return YES;
}

-(void)dealloc {
#if !__has_feature(objc_arc)
    [self.collectionView release];
    [super dealloc];
#endif
}


@end
