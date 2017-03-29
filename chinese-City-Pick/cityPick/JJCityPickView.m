//
//  JJCityPickView.m
//  chinese-City-Pick
//
//  Created by 罗文琦 on 2017/3/29.
//  Copyright © 2017年 罗文琦. All rights reserved.
//

#import "JJCityPickView.h"

//屏幕宽度
#define Screen_Width  [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define Screen_Height  [UIScreen mainScreen].bounds.size.height

@interface JJCityPickView ()
@property(nonatomic,strong)NSArray *areaArray;
@property(nonatomic,strong)NSArray *provinceArray;
@property(nonatomic,strong)NSArray *cityArray;
@property(nonatomic,weak)UIView *pickerBgView;
@property(nonatomic,weak)UIPickerView *areaPicker;
@property(nonatomic,copy)NSString *cityStr;
@property(nonatomic,copy)NSString *provinceStr;
@property(nonatomic,copy)NSString *selectedProvince;
@end


@implementation JJCityPickView



-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self createAreaPicker];
    }
    return self;
}
-(void)createAreaPicker
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:@"city" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    _areaArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    //获取省份数组
    NSMutableArray *provinceTmp = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in _areaArray)
    {
        NSString *_province = [dict objectForKey:@"p"];
        [provinceTmp addObject:_province];
    }
    _provinceArray = [[NSArray alloc] initWithArray: provinceTmp];
    
    //获取城市数组
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *cityArray = [[_areaArray firstObject] objectForKey:@"c"];
    for (NSDictionary *d in cityArray)
    {
        NSString *city = [d objectForKey:@"n"];
        [array addObject:city];
    }
    _cityArray = [[NSArray alloc] initWithArray: array];
    
    self.hidden = YES;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height, Screen_Width, 220)];
    bgView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(areaTap)];
    [self addGestureRecognizer:tap];
    _pickerBgView = bgView;
    [self addSubview:_pickerBgView];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,Screen_Width, 40)];
    topView.backgroundColor = [UIColor whiteColor];
    [_pickerBgView addSubview:topView];
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0,40,Screen_Width, 180)];
    picker.dataSource = self;
    picker.delegate = self;
    picker.showsSelectionIndicator = YES;
    picker.backgroundColor = [UIColor whiteColor];
    [picker selectRow:0 inComponent:0 animated:YES];
    [picker selectRow:0 inComponent:1 animated:YES];
    _areaPicker = picker;
    [_pickerBgView addSubview:self.areaPicker];
    
    UIButton *dateFinishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    dateFinishBtn.frame = CGRectMake(Screen_Width - 50, 0, 40, 40);
    [dateFinishBtn setTitle:@"完成"  forState:UIControlStateNormal];
    [dateFinishBtn setTitleColor:[UIColor colorWithRed:74/255 green:144/255 blue:226/255 alpha:1] forState:UIControlStateNormal];
    [dateFinishBtn addTarget:self action:@selector(areaTap) forControlEvents:UIControlEventTouchUpInside];
    dateFinishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [topView addSubview:dateFinishBtn];
    
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 40)];
    timeLabel.text = @"所在地";
    timeLabel.font = [UIFont systemFontOfSize:14];
    timeLabel.textColor = [UIColor blackColor];
    [topView addSubview:timeLabel];
    
    //分割线
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.5, Screen_Width, 1)];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:bottomLineView];
}
-(void)areaTap
{
    if (_provinceStr.length == 0 )
    {
        _provinceStr = @"北京";
        if (_cityStr.length == 0)
        {
            _cityStr = @"东城区";
        }
        
    }
    
    [_delegate pickerDidSelectProvince:_provinceStr city:_cityStr];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
    [UIView animateWithDuration:0.4 animations:^{
        _pickerBgView.transform = CGAffineTransformIdentity;
        
    }];
}
-(void)show
{
    
    self.hidden = NO;
    [UIView animateWithDuration:0.4 animations:^{
        _pickerBgView.transform = CGAffineTransformMakeTranslation(0,- _pickerBgView.frame.size.height);
        
    }];
}
#pragma mark- Picker Delegate Methods
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 2;
    
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [_provinceArray count];
    }
    else
    {
        return [_cityArray count];
    }
    
}
//每一行的内容
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        return [_provinceArray objectAtIndex: row];
    }
    else
    {
        return [_cityArray objectAtIndex:row];
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView == _areaPicker)
    {
        if (component == 0) {
            
            _selectedProvince = [_provinceArray objectAtIndex: row];
            
            NSDictionary *cityDict = [_areaArray objectAtIndex:row];
            NSArray *cityArray = [cityDict objectForKey:@"c"];
            NSMutableArray *tempCityArr = [[NSMutableArray alloc] init];
            for (NSDictionary *d in cityArray)
            {
                NSString *city = [d objectForKey:@"n"];
                [tempCityArr addObject:city];
            }
            
            _cityArray = [[NSArray alloc] initWithArray: tempCityArr];
            
            _provinceStr =  [_provinceArray objectAtIndex:row];
            _cityStr =  [_cityArray firstObject];
            //刷新城市列表
            [_areaPicker reloadComponent: 1];
            
        }
        else if (component == 1)
        {
            _cityStr = [_cityArray objectAtIndex:row];
        }
        
    }
    
}
//选中行的高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}
//列宽
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return Screen_Width/2;
    
}


@end
