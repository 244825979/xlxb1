//
//  ASEditTagsDataModel.h
//  AS
//
//  Created by SA on 2025/4/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASEditTagsDataModel : NSObject
@property (nonatomic, strong) NSArray<ASTagsModel *> *tag_list;
@property (nonatomic, strong) NSArray<ASTagsModel *> *user_tag;
@end

NS_ASSUME_NONNULL_END
