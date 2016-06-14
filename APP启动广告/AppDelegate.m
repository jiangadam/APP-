//
//  AppDelegate.m
//  APP启动广告
//
//  Created by 蒋永忠 on 16/6/14.
//  Copyright © 2016年 chinamyo. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "AdView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    [self.window makeKeyAndVisible];
    
    
    // 判断沙盒是否有图片
    NSString *filePath = [self getFilePathWithImageName:[UserDefault objectForKey:adImageName]];
    NSLog(@"1----%@", filePath);
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (isExist) {
        // 图片存在
        AdView *adView = [[AdView alloc] initWithFrame:self.window.bounds];
        adView.filePath = filePath;
        [adView show];
        NSLog(@"123");
    }
    
    // 无论沙盒是否存在文件，都需要更新广告接口，判断广告是否更新
    [self getAdImage];
    
    return YES;
}

- (void) getAdImage
{
    // 固定图片
    NSArray *imageArray = @[@"http://imgsrc.baidu.com/forum/pic/item/9213b07eca80653846dc8fab97dda144ad348257.jpg", @"http://pic.paopaoche.net/up/2012-2/20122220201612322865.png", @"http://img5.pcpop.com/ArticleImages/picshow/0x0/20110801/2011080114495843125.jpg", @"http://www.mangowed.com/uploads/allimg/130410/1-130410215449417.jpg"];
    NSString *imageUrl = imageArray[arc4random() % imageArray.count];
    
    // 获取一个地址
    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
    NSString *imageName = [stringArr lastObject];
    
    // 沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];
    NSLog(@"2----%@", filePath);
    BOOL isExise = [self isFileExistWithFilePath:filePath];
    
    if (!isExise) {
        [self downloadImageWithUrl:imageUrl imageName:imageName];
    }
}

// 下载图片
- (void) downloadImageWithUrl:(NSString *)url imageName:(NSString *)imageName
{
    // 异步下载图片
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [self getFilePathWithImageName:imageName];
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {
            NSLog(@"write success");
            [self deleteOldImage];
            [UserDefault setValue:imageName forKey:adImageName];
            [UserDefault synchronize];
        }else{
            NSLog(@"error");
        }
        
    });
}

- (void) deleteOldImage
{
    NSString *imageName = [UserDefault valueForKey:adImageName];
    
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

// 判断文件是否存在
- (BOOL) isFileExistWithFilePath:(NSString *)filePath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDirectory = FALSE;
    
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

// 根据文件名拼接文件路径
- (NSString *) getFilePathWithImageName:(NSString *)imageName
{
    if(imageName){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
        
        return filePath;
    }
    
    return nil;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
