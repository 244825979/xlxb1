//
//  ASSetCellModel.h
//  AS
//
//  Created by SA on 2025/4/21.
//

#import <Foundation/Foundation.h>
#import "ASMyAppCommonFunc.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, ASSetCellType){
    kSetCommonCellDefault = 0,      //默认左边标题
    kSetCommonCellText = 1,         //左边标题，右边显示文本
    kSetCommonCellSwitch = 2,       //左边标题，右边开关
    kSetEditCellUploadAvatar = 3,   //编辑上传头像
    kSetEditCellVoiceSign = 4,      //编辑页语音签名
    kSetEditCellPhotoWall = 5,      //编辑页上传照片墙
    kSetEditCellMyTags = 6,         //编辑页我的标签
    kSetStateCellText = 7,          //左边标题，右边显示文本，有显示审核中状态样式
};

@interface ASSetCellModel : NSObject
@property (nonatomic, assign) ASSetCellType cellType;
@property (nonatomic, copy) NSString *cellIndentify;
@property (nonatomic, copy) NSString *leftTitle;
@property (nonatomic, strong) UIColor *leftTitleColor;
@property (nonatomic, copy) NSString *titleRearImage;//title后面显示的icon,如隐身访问的vip
@property (nonatomic, strong) UIFont *leftTitleFont;
@property (nonatomic, copy) NSString *rightText;
@property (nonatomic, strong) UIColor *rightTextColor;
@property (nonatomic, strong) UIFont *rightTextFont;
@property (nonatomic, copy) NSString *rightIcon;
@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, assign) BOOL isSkip;//cell是否可以跳转 默认YES可跳转，NO不可以跳转
@property (nonatomic, assign) BOOL isShowLine;//是否显示分割线，默认NO不显示，YES显示分割线
@property (nonatomic, assign) BOOL isSwitch;//switch是否开启 默认关闭
@property (nonatomic, assign) CGFloat rightTextPading;//右边文本右边距
@property (nonatomic, copy) ResponseSuccess valueDidBlock;
@property (nonatomic, assign) NSInteger stateHiden;//审核状态是否显示 0表示显示、1表示隐藏
@property (nonatomic, assign) BOOL isRed;
/******** edit编辑页数据 *****/
@property (nonatomic, copy) NSString *avatarUrl;//头像url
@property (nonatomic, copy) UIImage *avatarImage;//头像image
@property (nonatomic, strong) ASVoiceModel *voice;
@property (nonatomic, strong) NSArray *images;//我的图片数组
@property (nonatomic, strong) NSArray *tags;//我的标签数据
@property (nonatomic, strong) ASSubTaskModel *taskModel;//显示金币数据模型
@end

NS_ASSUME_NONNULL_END
