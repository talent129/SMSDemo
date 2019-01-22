//
//  ViewController.m
//  SMSDemo
//
//  Created by mac on 17/5/17.
//  Copyright © 2017年 cai. All rights reserved.
//  http://sms.mob.com
//  简书: https://www.jianshu.com/p/e54820c9b93c

#import "ViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "CountButton.h"

#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (nonatomic, strong) CountButton *getSMSBtn;
@property (nonatomic, strong) UIButton *submitSMSBtn;

@property (nonatomic, strong) UILabel *phoneLabel;
@property (nonatomic, strong) UITextField *phoneField;

@property (nonatomic, strong) UILabel *submitLabel;
@property (nonatomic, strong) UITextField *submitField;

@end

@implementation ViewController

#pragma mark -懒加载
- (CountButton *)getSMSBtn
{
    if (!_getSMSBtn) {
        _getSMSBtn = [CountButton countdownButtonWith:@selector(getSMSBtnAction) withTarget:self];
        _getSMSBtn.frame = CGRectMake(15, 80, Screen_Width - 30, 50);
        _getSMSBtn.backgroundColor = [UIColor blueColor];
        _getSMSBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_getSMSBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_getSMSBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    return _getSMSBtn;
}

- (UIButton *)submitSMSBtn
{
    if (!_submitSMSBtn) {
        _submitSMSBtn = [self createUIButtonWithTitle:@"提交验证码" withFrame:CGRectMake(15, 200, Screen_Width - 30, 50) withTitleColor:[UIColor cyanColor] withBackgroundColor:[UIColor purpleColor] withTarget:@selector(submitSMSBtnAction)];
    }
    return _submitSMSBtn;
}

- (UILabel *)phoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [self createUILabelWithText:@"输入手机号:" withFrame:CGRectMake(15, 30, 100, 30) withTextColor:[UIColor purpleColor] withAlignment:NSTextAlignmentLeft withFont:16];
    }
    return _phoneLabel;
}

- (UITextField *)phoneField
{
    if (!_phoneField) {
        _phoneField = [self createUITextFieldWithFrame:CGRectMake(120, 30, 120, 30) withText:nil withTextColor:[UIColor blueColor] withFont:16 withPlaceHolder:@"手机号"];
    }
    return _phoneField;
}

- (UILabel *)submitLabel
{
    if (!_submitLabel) {
        _submitLabel = [self createUILabelWithText:@"输入验证码:" withFrame:CGRectMake(15, 150, 100, 30) withTextColor:[UIColor purpleColor] withAlignment:NSTextAlignmentLeft withFont:16];
    }
    return _submitLabel;
}

- (UITextField *)submitField
{
    if (!_submitField) {
        _submitField = [self createUITextFieldWithFrame:CGRectMake(120, 150, 120, 30) withText:nil withTextColor:[UIColor blueColor] withFont:16 withPlaceHolder:@"验证号"];
    }
    return _submitField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    [self createUI];
    
}

#pragma mark -create UI
-(void)createUI
{
    [self.view addSubview:self.getSMSBtn];
    [self.view addSubview:self.submitSMSBtn];
    
    [self.view addSubview:self.phoneLabel];
    [self.view addSubview:self.phoneField];
    
    [self.view addSubview:self.submitLabel];
    [self.view addSubview:self.submitField];
}

- (void)getSMSBtnAction
{
    //验证手机号格式是否正确
    if (![self validatePhone:self.phoneField.text]) {
        //格式错误
        NSLog(@"---手机号码格式错误");
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (error) {
            NSLog(@"获取验证码失败: %@", error);
        }else {
            NSLog(@"发送成功");
            [weakSelf.getSMSBtn startTime];
        }
    }];
}

- (void)submitSMSBtnAction
{
    [SMSSDK commitVerificationCode:self.submitField.text phoneNumber:self.phoneField.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
        
        if (error) {
            NSLog(@"错误信息: %@", error);
        }else {
            NSLog(@"验证成功");
        }
        
    }];
}

#pragma mark -create UIButton
- (UIButton *)createUIButtonWithTitle:(NSString *)title withFrame:(CGRect)frame withTitleColor:(UIColor *)titleColor withBackgroundColor:(UIColor *)backColor withTarget:(SEL)target
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    btn.backgroundColor = backColor;
    [btn addTarget:self action:target forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (UILabel *)createUILabelWithText:(NSString *)text withFrame:(CGRect)frame withTextColor:(UIColor *)textColor withAlignment:(NSTextAlignment)alignment withFont:(NSInteger)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.textAlignment = alignment;
    label.font = [UIFont systemFontOfSize:font];
    return label;
}

- (UITextField *)createUITextFieldWithFrame:(CGRect)frame withText:(NSString *)text withTextColor:(UIColor *)textColor withFont:(NSInteger)font withPlaceHolder:(NSString *)holder
{
    UITextField *field = [[UITextField alloc] initWithFrame:frame];
    field.text = text;
    field.textColor = textColor;
    field.font = [UIFont systemFontOfSize:font];
    field.placeholder = holder;
    field.borderStyle = UITextBorderStyleRoundedRect;
    field.keyboardType = UIKeyboardTypeNumberPad;//纯数字键盘
    return field;
}

#pragma mark - 验证手机号的合法性
- (BOOL)validatePhone:(NSString *)phone
{
    //modify by hgc -2017年12月01日 https://www.cnblogs.com/zengxiangzhan/p/phone.html
    //https://www.chahaoba.com/手机号段查询
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     更新:
     134 135 136 137 138 139 147 148 150 151 152 157 158 159 172 178 182 183 184 187 188 198
     * 联通：130,131,132,155,156,185,186
     更新:
     130 131 132 145 146 155 156 166 171 175 176 185 186
     * 电信：133,1349,153,180,189
     更新:
     133 149 153 173 174 177 180 181 189 199
     
     去除:1740、1741电信和工信部的卫星通信号段，144十三位移动物联网，141十三位电信物联网，10098船舶通信导航公司客服电话
     */
    
    ///虚拟运营商170 -154
    NSString * MOBILE = @"^((170)|(154))\\d{8}$";
    //|(1705)\\d{7}
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     更新:
     134 135 136 137 138 139 147 148 150 151 152 157 158 159 172 178 182 183 184 187 188 198
     12         */
    NSString * CM = @"^((13[4-9])|(147)|(148)|(15[0-2,7-9])|(172)|(178)|(18[2-4,7-8])|(198))\\d{8}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     更新:
     130 131 132 145 146 155 156 166 171 175 176 185 186
     17         */
    NSString * CU = @"^((13[0-2])|(145)|(146)|(15[5-6])|(166)|(171)|(175)|(176)|(18[5,6]))\\d{8}$";
    //|(1709)\\d{7}
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     更新:
     133 149 153 173 174 177 180 181 189 199
     22         */
    NSString * CT = @"^((133)|(149)|(153)|(173)|(174)|(177)|(18[0,1,9])|(199))\\d{8}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:phone] == YES)
        || ([regextestcm evaluateWithObject:phone] == YES)
        || ([regextestct evaluateWithObject:phone] == YES)
        || ([regextestcu evaluateWithObject:phone] == YES))
    {
        if([regextestcm evaluateWithObject:phone] == YES) {
            NSLog(@"China Mobile");
        } else if([regextestct evaluateWithObject:phone] == YES) {
            NSLog(@"China Telecom");
        } else if ([regextestcu evaluateWithObject:phone] == YES) {
            NSLog(@"China Unicom");
        } else {
            NSLog(@"Unknow");
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //收起键盘
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
