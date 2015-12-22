//
//  ViewController.m
//  WPTimeSelectPicker
//
//  Created by 王鹏 on 15/12/22.
//  Copyright © 2015年 wangpeng. All rights reserved.
//


#import "ViewController.h"

@interface ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
/** 时间显示Lable*/
@property (strong, nonatomic) UILabel *timeLable;
/** 存储数据数组*/
@property (nonatomic,strong)NSMutableArray *dateArray;
/** 存储字典*/
@property (nonatomic,strong)NSDictionary *dataDic;
/** 显示pickerView*/
@property (nonatomic,strong)UIPickerView *pickerView;
/** 记录时间字符串*/
@property (nonatomic,copy)NSString *yearStr;
@property (nonatomic,copy)NSString *monthStr;
@property (nonatomic,copy)NSString *dayStr;
@property (nonatomic,copy)NSString *hourStr;
@property (nonatomic,copy)NSString *minuteStr;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    /** 设置显示Lable的frame，并添加到View*/
    self.timeLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, self.view.frame.size.width, 30)];
    [self.view addSubview:self.timeLable];
    
    /** 设置picker的Lable，及其相关属性*/
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, 300)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pickerView];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    /** 初始化存储时间数组*/
    self.dateArray = [NSMutableArray array];
    
    /** 存储年份的数组*/
    NSMutableArray *yearArray = [[NSMutableArray alloc] initWithCapacity:50];
    for (int i = 0; i < 100; i ++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d年", 1970 + i]];
    }
    /** 存储月份的数组*/
    NSMutableArray *monthArray = [[NSMutableArray alloc] initWithCapacity:12];
    for (int i = 0; i < 12; i ++)
    {
        [monthArray addObject:[NSString stringWithFormat:@"%02d月", i + 1]];
    }
    /** 存储天数的数组*/
    NSMutableArray *dayArray = [[NSMutableArray alloc] initWithCapacity:31];
    for (int i = 0; i < 31; i ++)
    {
        [dayArray addObject:[NSString stringWithFormat:@"%02d日", i + 1]];
    }
    /** 存储小时的数组*/
    NSMutableArray *timeArray = [[NSMutableArray alloc] initWithCapacity:23];
    for (int i = 0; i < 23; i ++)
    {
        [timeArray addObject:[NSString stringWithFormat:@"%02d", i + 1]];
    }
    /** 存储分的数组*/
    NSMutableArray *partArray = [[NSMutableArray alloc] initWithCapacity:59];
    for (int i = 0; i < 59; i ++)
    {
        [partArray addObject:[NSString stringWithFormat:@"%02d", i + 1]];
    }
    [self.dateArray addObject:yearArray];
    [self.dateArray addObject:monthArray];
    [self.dateArray addObject:dayArray];
    [self.dateArray addObject:timeArray];
    [self.dateArray addObject:partArray];
    
    
    
    /** 将年、月、日都存放进字典*/
    self.dataDic = [[NSDictionary alloc] initWithObjectsAndKeys:timeArray, @"time",partArray, @"part",dayArray, @"day", yearArray, @"year", monthArray, @"month", nil];
    
    /** 计算今天的日期*/
    NSDate *date = [NSDate date];
    /** 简单粗暴的转换为东八区*/
    date = [date dateByAddingTimeInterval:8 * 60 * 60];
    NSString *today = [date description];
    /** 截取字符串中的对应的时间数据*/
    int yearNow = [[today substringToIndex:4] intValue];
    int monthNow = [[today substringWithRange:NSMakeRange(5, 2)] intValue];
    int dayNow = [[today substringWithRange:NSMakeRange(8, 2)] intValue];
    int timeNow = [[today substringWithRange:NSMakeRange(11, 2)]intValue];
    int partNow = [[today substringWithRange:NSMakeRange(14, 2)]intValue];
    /** 日期指定到今天，让日历默认显示今天的日期*/
    [self.pickerView selectRow:(yearNow - 1970) inComponent:0 animated:NO];
    [self.pickerView selectRow:(monthNow - 1) inComponent:1 animated:NO];
    [self.pickerView selectRow:(dayNow - 1) inComponent:2 animated:NO];
    [self.pickerView selectRow:(timeNow - 1) inComponent:3 animated:NO];
    [self.pickerView selectRow:(partNow - 1) inComponent:4 animated:NO];
    /** 初始化Lable赋值*/
    self.timeLable.text = [NSString stringWithFormat:@"%02d-%02d-%02d %02d:%d",yearNow,monthNow,dayNow,timeNow,partNow];
    
    self.yearStr = [NSString stringWithFormat:@"%d",yearNow];
    self.monthStr = [NSString stringWithFormat:@"%02d",monthNow];
    self.dayStr = [NSString stringWithFormat:@"%02d",dayNow];
    self.hourStr = [NSString stringWithFormat:@"%02d",timeNow];
    self.minuteStr = [NSString stringWithFormat:@"%02d",partNow];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return self.dataDic.count; //设置选择器的列数，即显示年、月、日三列
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *keyArray = [self.dataDic allKeys];
    NSArray *contentArray = [self.dataDic objectForKey:keyArray[component]];
    //显示每月的天数跟年份和月份都有关系，所以需要判断条件
    if (component == 2)
    {
        NSInteger month = [self.pickerView selectedRowInComponent:1] + 1;
        NSInteger year = [self.pickerView selectedRowInComponent:0] + 1970;
       /** 每个月的天数不一样*/
        switch (month)
        {
                /** 4、6、9、11月的天数是30天*/
            case 4: case 6: case 9: case 11:
            {
                contentArray = [contentArray subarrayWithRange:NSMakeRange(0, 30)];                return contentArray.count;
            }
                /** 2月特殊处理*/
            case 2:
            {
                if ( [self isLeapYear:year])
                {
                    //如果是闰年，二月有 29 天
                    contentArray = [contentArray subarrayWithRange:NSMakeRange(0, 29)];
                }
                else
                {
                    //不是闰年，二月只有 28 天
                    contentArray = [contentArray subarrayWithRange:NSMakeRange(0, 28)];
                }
                
                return contentArray.count;
            }
                /** 1、3、5、7、8、10、12 月的天数都是31天*/
            default:
                return contentArray.count;
        }
    }
    
    /** 返回每行列数*/
    return contentArray.count;
}
//返回高度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0) {
        return 100;
    }
    return (self.view.frame.size.width - 20 - 100)/ 4; //设置每列的宽度
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50; //设置每行的高度
}

//设置所在列每行的显示标题，与设置所在列的行数一样，天数的标题设置仍旧需要非一番功夫
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *keyArray = [self.dataDic allKeys];
    NSArray *contentArray = [self.dataDic objectForKey:keyArray[component]];
    
    if (component == 2)
    {
        NSInteger month = [pickerView selectedRowInComponent:1] + 1;
        NSInteger year = [pickerView selectedRowInComponent:0] +1970;
        switch (month)
        {
            case 4: case 6: case 9: case 11:
            {
                contentArray = [contentArray subarrayWithRange:NSMakeRange(0, 30)];
                return contentArray[row];
            }
            case 2:
            {
                if ( [self isLeapYear:(int)year])
                {
                    //闰年
                    contentArray = [contentArray subarrayWithRange:NSMakeRange(0, 29)];
                }
                else
                {
                    contentArray = [contentArray subarrayWithRange:NSMakeRange(0, 28)];
                }
                
                return contentArray[row];
            }
            default:
                return contentArray[row];
        }
    }
    return contentArray[row];
}

//当选择的行数改变时触发的方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSString *name = self.dateArray[component][row];
    //第一列的被选择行变化，即年份改变，则刷新月份和天数
    if (component == 0)
    {
        [pickerView reloadAllComponents]; //刷新月份与日期
        //下面是将月份和天数都定位到第一行
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        self.yearStr = name;
        [self.pickerView reloadAllComponents];
    }
    //第二列的被选择行变化，即月份发生变化，刷新天这列的内容
    if (component == 1)
    {
        [pickerView reloadAllComponents];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        self.monthStr = name;
    }//需要这些条件的原因是年份和月份的变化，都会引起每月的天数的变化，他们之间是有联系的，要掌握好他们之间的对应关系
    if (component == 2) {
        self.dayStr = name;
        
    }if (component == 3) {
        self.hourStr = name;
    }if (component == 4) {
        self.minuteStr = name;
    }
    self.timeLable.text = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",self.yearStr,self.monthStr,self.dayStr,self.hourStr,self.minuteStr];
    
}

/** 判断是否为闰年*/
- (BOOL)isLeapYear:(NSInteger )year
{
    if ((year % 400 == 0) || ((year % 4 == 0) && (year % 100 != 0)))
    {
        /** 闰年返回YES*/
        return YES;
    }
    
    return NO;
}

/** 设置pickerView显示字体*/
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    
    if (!pickerLabel){
    
        pickerLabel = [[UILabel alloc] init];
        
        pickerLabel.minimumScaleFactor = 8.0;
        
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        
        pickerLabel.textAlignment = NSTextAlignmentLeft;
        
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        
        [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}


@end


