//
//  ASEditUserTagsController.h
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ASEditUserTagsController : ASBaseViewController
@property (nonatomic, strong) NSMutableArray *selectTags;
@property (nonatomic, copy) ResponseSuccess saveBlock;
@end

NS_ASSUME_NONNULL_END
