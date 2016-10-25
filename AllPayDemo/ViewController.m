//
//  ViewController.m
//  AllPayDemo
//
//  Created by JGPeng on 16/10/24.
//  Copyright © 2016年 彭金光. All rights reserved.
//

#import "ViewController.h"
/** 微信 */
#import "WeiXinPayTool.h"
/** 支付宝 */
#import "AlipayTool.h"
/** 银联 */
#import "UPPayTool.h"
/** 弹窗 */
#import "UIView+Toast.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat btnWH = screenW/3;
    [self CreateButtonWithTitle:@"支付宝" Frame:CGRectMake(btnWH/3, btnWH/3, btnWH, btnWH) Action:@selector(AliPay1)];
    [self CreateButtonWithTitle:@"支付宝境外" Frame:CGRectMake(btnWH/3*5, btnWH/3, btnWH, btnWH) Action:@selector(AliPay2)];
    [self CreateButtonWithTitle:@"微信" Frame:CGRectMake(btnWH/3, btnWH/3*5, btnWH, btnWH) Action:@selector(weixin)];
    [self CreateButtonWithTitle:@"银联" Frame:CGRectMake(btnWH/3*5, btnWH/3*5, btnWH, btnWH) Action:@selector(upPay)];
    [self CreateButtonWithTitle:@"苹果" Frame:CGRectMake(btnWH/3, btnWH/3*9, btnWH, btnWH) Action:@selector(apPay)];
}
/** 支付宝 */
- (void)AliPay1{
    [AlipayTool sendAlipayWithOrderSn:@"9876543210" orderName:@"测试1" orderDescription:@"测试1描述" orderPrice:@"0.01" SuccessBlock:^{
        [self showMessage:@"支付成功！" target:nil];
    } FailedBlock:^(NSString *desc) {
        [self showMessage:desc target:nil];
    }];

}
/** 支付宝境外 */
- (void)AliPay2{
    [AlipayTool OutsideAlipayWithOrderSn:@"98765432100" orderName:@"测试2" orderDescription:@"测试2描述" orderPrice:@"0.01" SuccessBlock:^{
        [self showMessage:@"支付成功！" target:nil];
    } FailedBlock:^(NSString *desc) {
        [self showMessage:desc target:nil];
    }];

}
/** 微信 */
- (void)weixin{
    [[WeiXinPayTool shareTool] PayWithGoodname:@"测试3" OrderId:@"9876543210" GoodPrice:@"1" WeiXinPaySuccess:^{
        [self showMessage:@"支付成功！" target:nil];
    } WeiXinPayFailed:^(WeixinPayErrorCode code) {
        [self showMessage:@"支付失败或取消！" target:nil];
    }];

}
/** 银联 */
- (void)upPay{
    [[UPPayTool shareTool] startPay:@"201610251408254584338" viewController:self SuccessBlock:^{
        [self showMessage:@"支付成功！" target:nil];
    } FailedBlock:^(NSString *desc) {
        [self showMessage:desc target:nil];
    }];

}
/** 苹果 */
- (void)apPay{
    [[UPPayTool shareTool] startApplePay:@"201610251413334612818" viewController:self ApplePayCallBack:^(UPPayResult *payResult) {
        if (payResult.paymentResultStatus == UPPaymentResultStatusSuccess) {
            [self showMessage:@"支付成功！" target:nil];
        }else{
            [self showMessage:@"支付失败！" target:nil];
        }
    }];
}

/** 创建按钮的方法 */
- (void)CreateButtonWithTitle:(NSString *)title Frame:(CGRect)frame Action:(SEL)action{

    UIButton * button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundColor:[UIColor colorWithRed:0.915 green:0.653 blue:1.000 alpha:1.000]];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.layer.cornerRadius = frame.size.width/2;
    button.layer.masksToBounds = YES;
    [self.view addSubview:button];
}
/** 简单弹窗功能 */
- (void)showMessage:(NSString *)msg target:(id)target{
    [self.view makeToast:msg duration:2.0 position:CSToastPositionCenter
                   title:nil image:nil style:nil completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
