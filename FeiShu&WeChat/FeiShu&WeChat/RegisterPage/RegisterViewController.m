//
//  RegisterViewController.m
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/5/24.
//

#import "RegisterViewController.h"
#import "KeyChainManager.h"
#import "MainViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view = self.regView;
    [self.regView.logBtn addTarget:self action:@selector(log) forControlEvents:UIControlEventTouchUpInside];
}

- (RegisterView *)regView{
    if(_regView == nil){
        _regView = [[RegisterView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _regView;
}

- (void)log{
    //密码正确则修改登录状态
    if([self veritf] == YES){
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setBool:YES forKey:@"loggingStatus"];
        NSLog(@"%@",[def objectForKey:@"loggingStatus"]);
        [def synchronize];//即刻保存登录状态
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录成功！" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:YES completion:nil];
        //由于在dismiss完成之前不能对NavigationController进行入栈和出栈操作，所以直接将进入主界面的代码写在dismiss之后将无法实现。以下两种方法均可实现:
           // (1)设置延迟关闭提示窗口的操作,等待dismiss完成之后在push
//           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//               [alertController dismissViewControllerAnimated:YES completion:nil];
//               [self.navigationController pushViewController:[[MainViewController alloc] init] animated:YES];
//           });
           // (2)使用dismiss自带的block回调，在完成dismiss之后会调block中的push。
        [alertController dismissViewControllerAnimated:YES completion:^{
            [self.navigationController pushViewController:[[MainViewController alloc] init] animated:YES];
        }];
    }else if([self veritf] == NO){
        //密码错误则提示
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"账号或密码错误，请检查后重新输入" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *back = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alert addAction:back];
        [self presentViewController:alert animated:YES completion:nil];
    }
   
}

- (BOOL)veritf{
    NSString *inAccount = self.regView.accountField.text;
    NSString *inPassword = self.regView.passWordField.text;
    
    if(inPassword == [KeyChainManager getPasswordWithAccount:inAccount]){
        return YES;
    }else{
        return NO;
    }
    
}

@end
