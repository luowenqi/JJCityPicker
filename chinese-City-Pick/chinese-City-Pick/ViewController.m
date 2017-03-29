//
//  ViewController.m
//  chinese-City-Pick
//
//  Created by 罗文琦 on 2017/3/29.
//  Copyright © 2017年 罗文琦. All rights reserved.
//

#import "ViewController.h"
#import "JJCityPickView.h"

@interface ViewController ()<JJCityPickViewDelegate>


/**
 显示选择的结果
 */
@property(nonatomic , weak) UILabel * cityLable;

/**
 省市选择视图
 */
@property(nonatomic , weak) JJCityPickView * cityPickView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 //创建lab和btn
    UILabel* cityLable = [[UILabel alloc] initWithFrame:CGRectMake(100, 50, 300, 38)];
    _cityLable  =cityLable;
    _cityLable.text = @"所选的城市：";
    [self.view addSubview:_cityLable];
    UIButton *chooseCityBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    chooseCityBtn.frame = CGRectMake(100,100, 100, 44);
    chooseCityBtn.backgroundColor = [UIColor lightGrayColor];
    [chooseCityBtn setTitle:@"选择城市" forState: UIControlStateNormal];
    [chooseCityBtn addTarget:self action:@selector(chooseCity) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:chooseCityBtn];
}


#pragma mark - 点击选择城市按钮
-(void)chooseCity{
    if (_cityPickView == nil)//懒加载,节省内存
    {
        JJCityPickView* cityPickView = [[JJCityPickView alloc] initWithFrame:self.view.bounds];
        _cityPickView = cityPickView;
        _cityPickView.delegate = self;
        [self.view addSubview:_cityPickView];
        [_cityPickView show];
    }
    else
    {
        [_cityPickView show];
    }
}

#pragma mark 如果需要拿到选择的结果,那么实现代理方法
-(void)pickerDidSelectProvince:(NSString *)province city:(NSString *)city{
    _cityLable.text = [NSString stringWithFormat:@"所选的城市：%@ %@",province,city];
}

@end
