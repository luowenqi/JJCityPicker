//
//  JJCityPickView.h
//  chinese-City-Pick
//
//  Created by 罗文琦 on 2017/3/29.
//  Copyright © 2017年 罗文琦. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JJCityPickViewDelegate <NSObject>

#pragma mark - 代理方法声明
-(void)pickerDidSelectProvince:(NSString *)province city:(NSString *)city;

@end

@interface JJCityPickView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic , weak) id<JJCityPickViewDelegate> delegate;

-(void)show;

@end
