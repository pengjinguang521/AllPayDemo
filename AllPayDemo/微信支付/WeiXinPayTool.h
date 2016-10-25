//
//  WeiXinPayTool.h
//  AllPayDemo
//
//  Created by JGPeng on 16/10/24.
//  Copyright © 2016年 彭金光. All rights reserved.
//


#import <Foundation/Foundation.h>



#pragma mark - 微信支付的配置信息，也是主要修改的地方
//APPID
#define APP_ID          @"wxd8f37269582"
//appsecret
#define APP_SECRET      @"7e7aa98830094de148d449"
//商户号，填写商户对应参数
#define MCH_ID          @"1300124601"
//商户API密钥，填写相应参数
#define PARTNER_ID      @"SDL94P6OUQ1ITP7APCKOF53SQ"
//支付结果回调页面
#define NOTIFY_URL      @"http://101.230.8.68:8082/sgsb/servlet/doWxPayNotify"
//获取服务器端支付数据地址（自定义）
#define SP_URL          @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"

typedef NS_ENUM(NSUInteger, WeixinPayErrorCode) {
    
    ErrorCodeWXAppNotInstalled,         // 未安装微信
    ErrorCodeWxPayError,                // 微信支付失败
    ErrorCodeWxPayCancle,               // 微信支付取消
};


/**
 *  微信支付成功回调
 */
typedef void (^WeiXinPaySuccess)();
/**
 *  微信支付失败回调
 */
typedef void (^WeiXinPayFailed)(WeixinPayErrorCode code);


@interface WeiXinPayTool : NSObject

#pragma mark - 下面代码写在appDelegate中
/**
 *  单类方法
 */
+ (instancetype)shareTool;

/**
 －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
    写在application:(UIApplication *)application didFinishLaun                   ｜
    chingWithOptions:(NSDictionary *)launchOptions 方法                          ｜
 －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
 */
+ (void)RegistApp;

/**
 －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
   写在application:(UIApplication *)application handleOpenURL:(NSURL *)url       ｜
   application:(UIApplication *)app openURL:(NSURL *)url options: 方法           ｜
 －－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－－
 */
- (BOOL)handleOpenURL:(NSURL *)url;
#pragma mark - 下面是掉起支付的核心代码，在需要掉起支付的页面使用


/**************************** 微信支付  ******************************/
/**
 *  本地掉起微信支付的方法
 *
 *  @param goodsName   支付现实的名称
 *  @param orderId     订单id
 *  @param goodPrice   商品价格
 *  @param success     成功回调
 *  @param failed      失败回调
 */
- (void)PayWithGoodname:(NSString *)goodsName
                OrderId:(NSString *)orderId
              GoodPrice:(NSString *)goodPrice
       WeiXinPaySuccess:(WeiXinPaySuccess)success
        WeiXinPayFailed:(WeiXinPayFailed)failed;

/**
 *  后台传参数掉起微信支付
 *
 *  @param programs 后台返回的字典
 *  @param success  成功回调
 *  @param failed   失败回调
 */
- (void)PayWithPrograms:(NSDictionary *)programs
       WeiXinPaySuccess:(WeiXinPaySuccess)success
        WeiXinPayFailed:(WeiXinPayFailed)failed;


@end
