//
//  SettingsViewController.m
//  MVC-ViewModel
//
//  Created by WeiHan on 2022/6/6.
//

#import "SettingsViewController.h"

@interface SettingsViewController () <UITextFieldDelegate>

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UITextField *tfUser = [UITextField new];

    tfUser.leftView = ({
        UILabel *lblTitle = [UILabel new];
        lblTitle.text = @" User:  ";
        lblTitle.bounds = CGRectMake(0, 0, 100, 30);
        lblTitle;
    });
    tfUser.leftViewMode = UITextFieldViewModeAlways;
    tfUser.autocorrectionType = UITextAutocorrectionTypeNo;
    tfUser.autocapitalizationType = UITextAutocapitalizationTypeNone;
    tfUser.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.04];
    tfUser.clipsToBounds = YES;
    tfUser.layer.cornerRadius = 6;
    tfUser.delegate = self;
    tfUser.text = [NSUserDefaults.standardUserDefaults objectForKey:@"GithubUser"];

    [self.view addSubview:tfUser];

    [tfUser mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.width.equalTo(self.view).dividedBy(2);
        make.height.equalTo(@40);
    }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [NSUserDefaults.standardUserDefaults setObject:textField.text forKey:@"GithubUser"];
    [NSUserDefaults.standardUserDefaults synchronize];
}

@end
