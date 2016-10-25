//
//  UPPayTool.m
//  AllPayDemo
//
//  Created by JGPeng on 16/10/24.
//  Copyright © 2016年 彭金光. All rights reserved.
//

#import "UPPayTool.h"
#import "UPPaymentControl.h"

@interface UPPayTool ()<UPAPayPluginDelegate>
/** 银联 */
@property (nonatomic,strong)SuccessBlock success;
@property (nonatomic,strong)FailedBlock failed;
/** 银联苹果 */
@property (nonatomic,strong)ApplePayCallBack appleCallBack;

@end


@implementation UPPayTool

/**
 *  单类方法
 */
+ (instancetype)shareTool{

    static UPPayTool *_tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[UPPayTool alloc]init];
    });
    return _tool;
}
/**
 －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
 写在application:(UIApplication *)application openURL:(NSURL *)url sourceApp      |
 lication:(NSString *)sourceApplication annotation:(id)annotation  方法           ｜
 －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
 */
- (BOOL)handleOpenURL:(NSURL *)url{
    if ([url.host isEqualToString:@"safepay"]) {
        //支付宝
    }
    else if ([url.host isEqualToString:@"pay"]) {
        //微信
    }else{
        //银联支付结果回调
        [[UPPaymentControl defaultControl] handlePaymentResult:url completeBlock:^(NSString *code, NSDictionary *data) {
            
            NSDictionary * dict = data;
            NSString * result = dict[@"code"];
            if ([result isEqualToString:@"success"]) {
                if (self.success) {
                    self.success();
                }
            } else if ([result isEqualToString:@"cancel"]) {
                if (self.failed) {
                    self.failed(@"用户中途取消支付！");
                }
            } else {
                if (self.failed) {
                    self.failed(@"支付失败！");
                }
            }
        }];
      
    }
  return YES;
}

/**
 *  掉起银联支付
 *
 *  @param tn             订单信息
 *  @param schemeStr      调用支付的app注册在info.plist中的scheme
 *  @param viewController 掉起的控制器
 *  @param success        成功回调
 *  @param failed         失败回调
 */
- (void)startPay:(NSString*)tn
  viewController:(UIViewController*)viewController
    SuccessBlock:(SuccessBlock)success
     FailedBlock:(FailedBlock)failed{

    self.success = success;
    self.failed = failed;
    [[UPPaymentControl defaultControl]startPay:tn fromScheme:UPPScheme mode:PayModeType viewController:viewController];
    
}

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
     ApplePayCallBack:(ApplePayCallBack)back{
    self.appleCallBack = back;
   [UPAPayPlugin startPay:tn mode:PayModeType viewController:viewController delegate:self andAPMechantID:APMechantID];
}
/**
 *  支付结果回调函数
 *
 *  @param payResult   以UPPayResult结构向商户返回支付结果
 */
-(void) UPAPayPluginResult:(UPPayResult *) payResult{
    
    if (self.appleCallBack) {
        self.appleCallBack(payResult);
    }
}


@end
