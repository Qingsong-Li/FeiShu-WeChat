//
//  searchCell.h
//  FeiShu&WeChat
//
//  Created by 李青松 on 2023/6/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol SearchCellDelegate <NSObject>

- (void)searchContact;

@end

@interface SearchCell : UITableViewCell

@property(strong,nonatomic) UITextField *searchField;
@property(strong,nonatomic) UIButton *searchBtn;
@property(weak,nonatomic) id<SearchCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
