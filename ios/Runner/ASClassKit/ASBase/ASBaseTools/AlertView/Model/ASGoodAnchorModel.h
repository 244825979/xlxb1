//
//  ASGoodAnchorModel.h
//  AS
//
//  Created by SA on 2025/4/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASGoodAnchorModel : NSObject
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *greetVoice;
@property (nonatomic, copy) NSString *greetImg;
@property (nonatomic, copy) NSString *greetTxt;
@property (nonatomic, copy) NSArray *avatarList;
@property (nonatomic, assign) NSInteger isFree;//是否免费
@property (nonatomic, assign) NSInteger greetVoiceLen;//语音时长
@end

NS_ASSUME_NONNULL_END
