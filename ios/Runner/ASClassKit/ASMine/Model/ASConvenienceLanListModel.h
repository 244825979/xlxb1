//
//  ASConvenienceLanListModel.h
//  AS
//
//  Created by SA on 2025/5/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASConvenienceLanListModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, assign) NSInteger is_default;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger create_time;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *file;
@property (nonatomic, copy) NSString *voice_file;
@property (nonatomic, assign) NSInteger len;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
