//
//  ASReportController.h
//  AS
//
//  Created by SA on 2025/5/9.
//

#import "ASBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ReportType) {
    kReportTypePersonalHome = 1,                //个人主页
    kReportTypeDynamic = 3,                     //举报动态
    kReportTypeVoice = 7,                       //语音举报
    kReportTypeVideo = 8,                       //视频通话举报
};

@interface ASReportController : ASBaseViewController
@property (nonatomic, assign) ReportType type;
@property (nonatomic, copy) NSString *uid;
@end

NS_ASSUME_NONNULL_END
