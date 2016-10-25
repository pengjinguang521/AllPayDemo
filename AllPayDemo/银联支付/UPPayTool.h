//
//  UPPayTool.h
//  AllPayDemo
//
//  Created by JGPeng on 16/10/24.
//  Copyright © 2016年 彭金光. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/** 苹果支付头文件 */
#import <PassKit/PassKit.h>
#import "UPAPayPlugin.h"


/**
 *  银联的订单号全部从后台获得，这边保证参数无误即可掉起
 */
#pragma mark - 关于银联支付和苹果支付的一些配置文件
// 01 测试环境  00 正式环境
#define PayModeType    @"01"
// 苹果公司分配的商户号
#define APMechantID    @"merchant.com.am.gu"
// app跳转标示
#define UPPScheme      @"TestUpp"

/**
 *  银联支付成功，和失败的回调
 */
typedef void (^SuccessBlock)();
typedef void (^FailedBlock)(NSString * desc);
/**
 *  苹果支付回调
 */
typedef void (^ApplePayCallBack)(UPPayResult * payResult);

@interface UPPayTool : NSObject

#pragma mark - 下面代码写在appDelegate中
/**
 *  单类方法
 */
+ (instancetype)shareTool;

/**
 －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
 写在application:(UIApplication *)application openURL:(NSURL *)url sourceApp      |
 lication:(NSString *)sourceApplication annotation:(id)annotation  方法           ｜
 －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
 */
- (BOOL)handleOpenURL:(NSURL *)url;

/**************************** 银联支付  ******************************/

/**
 *  掉起银联支付
 *
 *  @param tn             订单信息
 *  @param viewController 掉起的控制器
 *  @param success        成功回调
 *  @param failed         失败回调
 */
- (void)startPay:(NSString*)tn
  viewController:(UIViewController*)viewController
    SuccessBlock:(SuccessBlock)success
     FailedBlock:(FailedBlock)failed;



/**************************** 苹果支付  ******************************/

/**
 *  掉起苹果支付的方法
 *
 *  @param tn             订单号
 *  @param mode           环境类型
 *  @param viewController 控制器
 *  @param back           回调UPPayResult结果
 */
- (void)startApplePay:(NSString *)tn
       viewController:(UIViewController*)viewController
     ApplePayCallBack:(ApplePayCallBack)back;


@end
