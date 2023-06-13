//
//  AddContactsViewController.h
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/6/8.
//

#import <UIKit/UIKit.h>
#import "TopView.h"
#import "ContactsModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface AddContactsViewController : UIViewController

@property(strong,nonatomic) UIButton *backBtn;
@property(strong,nonatomic) TopView *topView;
@property(strong,nonatomic) UITextField *searchField;
@property(strong,nonatomic) UIButton *addBtn;

@end

NS_ASSUME_NONNULL_END
