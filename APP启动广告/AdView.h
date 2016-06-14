//
//  AdView.h
//  APP启动广告
//
//  Created by 蒋永忠 on 16/6/14.
//  Copyright © 2016年 chinamyo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define JScreenWidth [UIScreen mainScreen].bounds.size.width
#define JScreenHeight [UIScreen mainScreen].bounds.size.height

#define UserDefault [NSUserDefaults standardUserDefaults]


static NSString *const adImageName = @"adImageName";
static NSString *const adUrl = @"adUrl";

@interface AdView : UIView

// 显示广告
- (void) show;

// 图片路径
@property (nonatomic, copy) NSString *filePath;


@end
