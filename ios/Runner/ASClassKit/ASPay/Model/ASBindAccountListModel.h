//
//  ASBindAccountListModel.h
//  AS
//
//  Created by SA on 2025/6/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASBindAccountListModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *bank_code;
@property (nonatomic, copy) NSString *card_name;
@property (nonatomic, copy) NSString *card_account;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *card_icon;
@end

NS_ASSUME_NONNULL_END
