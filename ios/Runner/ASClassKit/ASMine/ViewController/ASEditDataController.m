//
//  ASEditDataController.m
//  AS
//
//  Created by SA on 2025/4/21.
//

#import "ASEditDataController.h"
#import "ASEditDataModel.h"
#import "ASMineRequest.h"
#import "ASEditAvatarCell.h"
#import "ASEditVoiceSignCell.h"
#import "ASEditPhotoWallCell.h"
#import "ASEditTagsCell.h"
#import "ASEditTextStateCell.h"
#import "ASEditSetVoiceSignController.h"
#import "ASEditUserPhotoWallController.h"
#import "ASEditUserTagsController.h"

@interface ASEditDataController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) UILabel *topHintText;
@property (nonatomic, strong) UILabel *baseDataMoneyHint;
@property (nonatomic, strong) UIButton *saveBtn;
/**数据**/
@property (nonatomic, assign) UIImage *avatarImage;
@property (nonatomic, strong) ASUserInfoModel *userModel;
@property (nonatomic, strong) NSArray *provinceCitys;
@property (nonatomic, strong) NSArray *hometownCitys;
@property (nonatomic, strong) ASDataSelectModel *selectData;
@property (nonatomic, strong) NSMutableArray<NSArray *> *lists;
@property (nonatomic, assign) BOOL isEdit;//是否编辑
@property (nonatomic, strong) ASEditDataModel *editModel;
/**列表**/
@property (nonatomic, strong) ASSetCellModel *headModel;
@property (nonatomic, strong) ASSetCellModel *textSignModel;
@property (nonatomic, strong) ASSetCellModel *voiceSignModel;
@property (nonatomic, strong) ASSetCellModel *uploadPictureModel;
@property (nonatomic, strong) ASSetCellModel *nickNameModel;
@property (nonatomic, strong) ASSetCellModel *ageModel;
@property (nonatomic, strong) ASSetCellModel *addressModel;
@property (nonatomic, strong) ASSetCellModel *hometownModel;
@property (nonatomic, strong) ASSetCellModel *heightModel;
@property (nonatomic, strong) ASSetCellModel *weightModel;
@property (nonatomic, strong) ASSetCellModel *occupationModel;
@property (nonatomic, strong) ASSetCellModel *incomeModel;
@property (nonatomic, strong) ASSetCellModel *educationModel;
@property (nonatomic, strong) ASSetCellModel *myTagsModel;
@end

@implementation ASEditDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"编辑资料";
    [self createUI];
    [self requestData];
}

- (void)createUI {
    kWeakSelf(self);
    [self.lists addObject: @[self.headModel, self.textSignModel, self.voiceSignModel]];
    [self.lists addObject: @[self.uploadPictureModel]];
    [self.lists addObject: @[self.nickNameModel,
                             self.ageModel,
                             self.hometownModel,
                             self.addressModel,
                             self.heightModel,
                             self.weightModel,
                             self.occupationModel,
                             self.incomeModel,
                             self.educationModel,
                             self.myTagsModel]];
    
    self.saveBtn = ({
        UIButton *save = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCALES(48), SCALES(26))];
        [save setTitle:@"保存" forState:UIControlStateNormal];
        save.titleLabel.font = TEXT_FONT_14;
        [save setBackgroundColor: UIColorRGB(0xCCCCCC)];
        save.userInteractionEnabled = NO;
        save.layer.cornerRadius = SCALES(13);
        save.layer.masksToBounds = YES;
        [[save rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (!kObjectIsEmpty(wself.avatarImage)) {
                [[ASUploadImageManager shared] oneImageUpdateWithAliOSSType:@"avatar" imgae:wself.avatarImage success:^(id _Nonnull response) {
                    NSString *url = response;
                    [ASMineRequest requestUpdataAvatarWithURL:url success:^(id _Nullable data) {
                        wself.editModel.avatar = url;
                        if (!kStringIsEmpty(url)) {
                            USER_INFO.avatar = url;
                            [ASUserDefaults setValue:url forKey:@"userinfo_avatar"];
                        }
                        [wself disposePictureWithImages:wself.uploadPictureModel.images urlBlock:^(NSString *urls) {
                            wself.editModel.albums = urls;
                            [wself saveRequest];
                        } errorBack:^(NSInteger code, NSString *msg) {
                            
                        }];
                    } errorBack:^(NSInteger code, NSString *msg) {
                        
                    }];
                } fail:^{
                    
                }];
            } else {
                [wself disposePictureWithImages:wself.uploadPictureModel.images urlBlock:^(NSString *urls) {
                    wself.editModel.albums = urls;
                    [wself saveRequest];
                } errorBack:^(NSInteger code, NSString *msg) {
                    
                }];
            }
        }];
        save;
    });
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.saveBtn];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    
    [self.tableView registerClass:[ASBaseCommonCell class] forCellReuseIdentifier:@"baseCommonCell"];
    [self.tableView registerClass:[ASEditAvatarCell class] forCellReuseIdentifier:@"editAvatarCell"];
    [self.tableView registerClass:[ASEditVoiceSignCell class] forCellReuseIdentifier:@"editVoiceSignCell"];
    [self.tableView registerClass:[ASEditPhotoWallCell class] forCellReuseIdentifier:@"editPhotoWallCell"];
    [self.tableView registerClass:[ASEditTagsCell class] forCellReuseIdentifier:@"editMyTagsCell"];
    [self.tableView registerClass:[ASEditTextStateCell class] forCellReuseIdentifier:@"editStateCellText"];
}

- (void)popVC {
    [self.view endEditing:YES];
    if (self.isEdit == YES) {
        kWeakSelf(self);
        [ASAlertViewManager defaultPopTitle:@"提示" content:@"是否确认放弃本次修改" left:@"确认" right:@"取消" affirmAction:^{
            [wself.navigationController popViewControllerAnimated:YES];
        } cancelAction:^{
        }];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setIsEdit:(BOOL)isEdit {
    _isEdit = isEdit;
    if (isEdit == NO) {
        [self.saveBtn setBackgroundColor: UIColorRGB(0xCCCCCC)];
        self.saveBtn.userInteractionEnabled = NO;
    } else {
        [self.saveBtn setBackgroundColor: GRDUAL_CHANGE_BG_COLOR(SCALES(48), SCALES(26))];
        self.saveBtn.userInteractionEnabled = YES;
    }
}

- (ASSetCellModel *)headModel {
    if (!_headModel) {
        _headModel = [[ASSetCellModel alloc]init];
        _headModel.cellType = kSetEditCellUploadAvatar;
        _headModel.leftTitle = @"头像";
        _headModel.stateHiden = 1;
        _headModel.avatarUrl = USER_INFO.avatar;
    }
    return _headModel;
}

- (ASSetCellModel *)textSignModel {
    if (!_textSignModel) {
        _textSignModel = [[ASSetCellModel alloc]init];
        _textSignModel.cellType = kSetStateCellText;
        _textSignModel.leftTitle = @"个性签名";
        _textSignModel.rightText = @"说说你是什么样的人?";
        _textSignModel.stateHiden = 1;
    }
    return _textSignModel;
}

- (ASSetCellModel *)voiceSignModel {
    if (!_voiceSignModel) {
        _voiceSignModel = [[ASSetCellModel alloc]init];
        _voiceSignModel.leftTitle = @"语音签名";
        _voiceSignModel.cellType = kSetEditCellVoiceSign;
    }
    return _voiceSignModel;
}

- (ASSetCellModel *)uploadPictureModel {
    if (!_uploadPictureModel) {
        _uploadPictureModel = [[ASSetCellModel alloc]init];
        _uploadPictureModel.leftTitle = @"个人相册";
        _uploadPictureModel.cellType = kSetEditCellPhotoWall;
        kWeakSelf(self);
        _uploadPictureModel.valueDidBlock = ^(id _Nullable value) {
            wself.isEdit = YES;
        };
    }
    return _uploadPictureModel;
}

- (ASSetCellModel *)nickNameModel {
    if (!_nickNameModel) {
        _nickNameModel = [[ASSetCellModel alloc]init];
        _nickNameModel.cellType = kSetStateCellText;
        _nickNameModel.leftTitle = @"昵称";
        _nickNameModel.rightTextColor = TITLE_COLOR;
        _nickNameModel.rightText = USER_INFO.nickname;
        _nickNameModel.stateHiden = 1;//默认隐藏
    }
    return _nickNameModel;
}

- (ASSetCellModel *)ageModel {
    if (!_ageModel) {
        _ageModel = [[ASSetCellModel alloc]init];
        _ageModel.cellType = kSetCommonCellText;
        _ageModel.leftTitle = @"年龄";
        _ageModel.rightTextColor = TITLE_COLOR;
        _ageModel.rightText = [NSString stringWithFormat:@"%zd岁",USER_INFO.age];
    }
    return _ageModel;
}

- (ASSetCellModel *)hometownModel {
    if (!_hometownModel) {
        _hometownModel = [[ASSetCellModel alloc]init];
        _hometownModel.cellType = kSetCommonCellText;
        _hometownModel.leftTitle = @"家乡";
        _hometownModel.rightText = @"未设置";
    }
    return _hometownModel;
}

- (ASSetCellModel *)addressModel {
    if (!_addressModel) {
        _addressModel = [[ASSetCellModel alloc]init];
        _addressModel.cellType = kSetCommonCellText;
        _addressModel.leftTitle = @"所在地";
        _addressModel.rightText = @"未设置";
    }
    return _addressModel;
}

- (ASSetCellModel *)heightModel {
    if (!_heightModel) {
        _heightModel = [[ASSetCellModel alloc]init];
        _heightModel.cellType = kSetCommonCellText;
        _heightModel.leftTitle = @"身高";
        _heightModel.rightText = @"未设置";
    }
    return _heightModel;
}

- (ASSetCellModel *)weightModel {
    if (!_weightModel) {
        _weightModel = [[ASSetCellModel alloc]init];
        _weightModel.cellType = kSetCommonCellText;
        _weightModel.leftTitle = @"体重";
        _weightModel.rightText = @"未设置";
    }
    return _weightModel;
}

- (ASSetCellModel *)occupationModel {
    if (!_occupationModel) {
        _occupationModel = [[ASSetCellModel alloc]init];
        _occupationModel.cellType = kSetCommonCellText;
        _occupationModel.leftTitle = @"职业";
        _occupationModel.rightText = @"未设置";
    }
    return _occupationModel;
}

- (ASSetCellModel *)incomeModel {
    if (!_incomeModel) {
        _incomeModel = [[ASSetCellModel alloc]init];
        _incomeModel.cellType = kSetCommonCellText;
        _incomeModel.leftTitle = @"年收入";
        _incomeModel.rightText = @"未设置";
    }
    return _incomeModel;
}

- (ASSetCellModel *)educationModel {
    if (!_educationModel) {
        _educationModel = [[ASSetCellModel alloc]init];
        _educationModel.cellType = kSetCommonCellText;
        _educationModel.leftTitle = @"学历";
        _educationModel.rightText = @"未设置";
    }
    return _educationModel;
}

- (ASSetCellModel *)myTagsModel {
    if (!_myTagsModel) {
        _myTagsModel = [[ASSetCellModel alloc]init];
        _myTagsModel.cellType = kSetEditCellMyTags;
        _myTagsModel.leftTitle = @"我的标签";
        _myTagsModel.rightText = @"去选择";
    }
    return _myTagsModel;
}

#pragma mark - 请求获取数据
- (void)saveRequest {
    [self.view endEditing:YES];
    kWeakSelf(self);
    [ASMineRequest requestEditSaveDataWithModel:self.editModel success:^(id  _Nullable data) {
        if (!kStringIsEmpty(wself.editModel.nickname)) {
            USER_INFO.nickname = wself.editModel.nickname;
            [ASUserDefaults setValue:wself.editModel.nickname forKey:@"userinfo_nickname"];
        }
        if (!kStringIsEmpty(wself.editModel.age)) {
            NSString *age = [wself.editModel.age stringByReplacingOccurrencesOfString:@"岁" withString:@""];
            USER_INFO.age = age.integerValue;
            [ASUserDefaults setValue:@(age.integerValue) forKey:@"userinfo_age"];
        }
        [wself.navigationController popViewControllerAnimated:YES];
        if (wself.refreshBolck) {
            wself.refreshBolck();
        }
    } errorBack:^(NSInteger code, NSString *msg) {
    }];
}

- (void)requestData {
    kWeakSelf(self);
    [ASCommonRequest requestProvinceCitysSuccess:^(id  _Nullable data) {
        wself.provinceCitys = data;
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];

    [ASCommonRequest requestCityOptionsSuccess:^(id  _Nullable data) {
        wself.hometownCitys = data;
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
    
    [ASCommonRequest requestSelectListSuccess:^(id  _Nullable data) {
        wself.selectData = data;
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
    
    [ASMineRequest requestEditDataSuccess:^(id  _Nullable data) {
        wself.userModel = data;
        wself.headModel.taskModel = wself.userModel.task.avatar_task;
        wself.textSignModel.taskModel = wself.userModel.task.sign_task;
        wself.voiceSignModel.taskModel = wself.userModel.task.voice_task;
        wself.uploadPictureModel.taskModel = wself.userModel.task.album_task;
        wself.nickNameModel.rightText = wself.userModel.nickname;
        wself.nickNameModel.stateHiden = wself.userModel.nickname_state;
        wself.baseDataMoneyHint.hidden = wself.userModel.task.over_task.is_show == 1 ? NO : YES;
        wself.baseDataMoneyHint.text = [NSString stringWithFormat:@"   %@   ",wself.userModel.task.over_task.des];
        //完善数量 年龄+昵称已经有了
        CGFloat perfectCount = 2.00;
        if (!kStringIsEmpty(wself.userModel.avatar)) {
            wself.headModel.stateHiden = wself.userModel.avatar_auth_status;
            if (wself.userModel.avatar_auth_status == 1) {
                wself.headModel.avatarUrl = wself.userModel.avatar;
            } else {
                wself.headModel.avatarUrl = wself.userModel.avatar_auth;
            }
            wself.editModel.avatar = wself.userModel.avatar;
            perfectCount += 1.00;
        }
        //个性签名
        if (!kStringIsEmpty(wself.userModel.sign) && ![wself.userModel.sign isEqualToString:@"这个人很懒，什么都没有留下…"]) {
            wself.textSignModel.rightText = wself.userModel.sign;
            wself.textSignModel.rightTextColor = TITLE_COLOR;
            wself.textSignModel.stateHiden = wself.userModel.sign_state;
            wself.editModel.signature = wself.userModel.sign;
            perfectCount += 1.00;
        }
        //语音签名
        if (!kStringIsEmpty(wself.userModel.voice.voice)) {
            wself.voiceSignModel.voice = wself.userModel.voice;
            wself.editModel.voice = wself.userModel.voice.voice;
            wself.editModel.voice_time = wself.userModel.voice.voice_time;
            perfectCount += 1.00;
        }
        //照片墙
        if (wself.userModel.albums_list.count > 0) {
            wself.uploadPictureModel.images = wself.userModel.albums_list;
            perfectCount += 1.00;
        }
        //所在地
        if (!kStringIsEmpty(wself.userModel.basic_info_detail.city)) {
            wself.addressModel.rightText = wself.userModel.basic_info_detail.city;
            wself.addressModel.rightTextColor = TITLE_COLOR;
            perfectCount += 1.00;
        }
        //家乡
        if (!kStringIsEmpty(wself.userModel.basic_info_detail.hometown)) {
            wself.hometownModel.rightText = wself.userModel.basic_info_detail.hometown;
            wself.hometownModel.rightTextColor = TITLE_COLOR;
            perfectCount += 1.00;
        }
        //身高
        if (!kStringIsEmpty(wself.userModel.basic_info_detail.height)) {
            wself.heightModel.rightText = wself.userModel.basic_info_detail.height;
            wself.heightModel.rightTextColor = TITLE_COLOR;
            perfectCount += 1.00;
        }
        //体重
        if (!kStringIsEmpty(wself.userModel.basic_info_detail.weight)) {
            wself.weightModel.rightText = wself.userModel.basic_info_detail.weight;
            wself.weightModel.rightTextColor = TITLE_COLOR;
            perfectCount += 1.00;
        }
        //职业
        if (!kStringIsEmpty(wself.userModel.basic_info_detail.occupation)) {
            wself.occupationModel.rightText = wself.userModel.basic_info_detail.occupation;
            wself.occupationModel.rightTextColor = TITLE_COLOR;
            perfectCount += 1.00;
        }
        //年收入
        if (!kStringIsEmpty(wself.userModel.basic_info_detail.annual_income)) {
            wself.incomeModel.rightText = wself.userModel.basic_info_detail.annual_income;
            wself.incomeModel.rightTextColor = TITLE_COLOR;
            perfectCount += 1.00;
        }
        //学历
        if (!kStringIsEmpty(wself.userModel.basic_info_detail.education)) {
            wself.educationModel.rightText = wself.userModel.basic_info_detail.education;
            wself.educationModel.rightTextColor = TITLE_COLOR;
            perfectCount += 1.00;
        }
        //我的标签
        if (wself.userModel.label.count > 0) {
            wself.myTagsModel.tags = wself.userModel.label;
            wself.myTagsModel.rightText = @"";
            perfectCount += 1.00;
        }
        [wself.tableView reloadData];
        
        CGFloat perfectValue = perfectCount / 14.00;
        NSInteger val = ceilf(perfectValue * 100);
        //富文本设置
        NSString *text = [NSString stringWithFormat:@"基本资料完成度%zd%%，完善度越高越受欢迎哦~", val];
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:text];
        //设置部分字体颜色
        [attributed addAttribute:NSForegroundColorAttributeName
                           value:TITLE_COLOR
                           range:NSMakeRange(0, 7)];
        [wself.topHintText setAttributedText:attributed];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.lists.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASSetCellModel *model = self.lists[indexPath.section][indexPath.row];
    id cell = [tableView dequeueReusableCellWithIdentifier:model.cellIndentify forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASSetCellModel *model = self.lists[indexPath.section][indexPath.row];
    return model.cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    if (section == 0) {
        view.backgroundColor = UIColorRGB(0xFFF1F3);
        [view addSubview:self.topHintText];
        self.topHintText.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALES(34));
    } else if (section == 2){
        view.backgroundColor = BACKGROUNDCOLOR;
        UIView *userDataView = [[UIView alloc] initWithFrame:CGRectMake(0, SCALES(10), SCREEN_WIDTH, SCALES(52))];
        userDataView.backgroundColor = UIColor.whiteColor;
        [view addSubview:userDataView];
        UILabel *title = [[UILabel alloc] init];
        [userDataView addSubview:title];
        title.font = TEXT_FONT_16;
        title.textColor = TITLE_COLOR;
        title.text = @"基本信息";
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(userDataView);
            make.left.mas_equalTo(SCALES(15));
        }];
        
        [userDataView addSubview:self.baseDataMoneyHint];
        [self.baseDataMoneyHint mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(title);
            make.left.equalTo(title.mas_right).offset(SCALES(8));
            make.height.mas_equalTo(SCALES(20));
        }];
    } else {
        view.backgroundColor = BACKGROUNDCOLOR;
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return SCALES(34);
    } else if (section == 2){
        return SCALES(60);
    } else {
        return SCALES(10);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    kWeakSelf(self);
    ASSetCellModel *model = self.lists[indexPath.section][indexPath.row];
    if ([model.leftTitle isEqualToString:self.headModel.leftTitle]) {
        [[ASAuthStateVerifyManager shared] isCertificationState:kRpAuthDefaultPop succeed:^{
            [[ASUploadImageManager shared] selectImagePickerWithMaxCount:1 isSelfieCamera:YES viewController:self didFinish:^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
                wself.headModel.avatarUrl = @"";
                wself.headModel.avatarImage = photos[0];
                wself.headModel.stateHiden = 0;
                wself.avatarImage = photos[0];
                //更新当前的cell
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
                wself.isEdit = YES;
            }];
        }];
        return;
    }
    
    if ([model.leftTitle isEqualToString:self.textSignModel.leftTitle]) {
        [ASAlertViewManager popTextViewWithTitle:@"个性签名" content:self.editModel.signature placeholder:@"添加个性签名，获得更多关注~" length:100 affirmText:@"提交" affirmAction:^(NSString * _Nonnull text) {
            wself.textSignModel.rightText = text;
            wself.textSignModel.rightTextColor = TITLE_COLOR;
            wself.textSignModel.stateHiden = 0;
            wself.editModel.signature = text;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            wself.isEdit = YES;
        } cancelAction:^{
            
        }];
        return;
    }
    
    if ([model.leftTitle isEqualToString:self.voiceSignModel.leftTitle]) {
        ASEditSetVoiceSignController *vc = [[ASEditSetVoiceSignController alloc] init];
        vc.saveBlock = ^(NSString * _Nonnull url, NSInteger voiceTime) {
            wself.editModel.voice = STRING(url);
            wself.editModel.voice_time = voiceTime;
            ASVoiceModel *voice = [[ASVoiceModel alloc] init];
            voice.voice = url;
            voice.voice_time = voiceTime;
            wself.userModel.voice = voice;
            wself.voiceSignModel.voice = voice;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            wself.isEdit = YES;
        };
        [wself.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([model.leftTitle isEqualToString:self.uploadPictureModel.leftTitle]) {
        ASEditUserPhotoWallController *vc = [[ASEditUserPhotoWallController alloc] init];
        vc.photos = [NSMutableArray arrayWithArray:self.uploadPictureModel.images];
        vc.saveBlock = ^(NSArray * _Nonnull images) {
            wself.uploadPictureModel.images = images;
            wself.uploadPictureModel.rightText = @"";
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            wself.isEdit = YES;
        };
        [wself.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([model.leftTitle isEqualToString:self.nickNameModel.leftTitle]) {
        [ASAlertViewManager popTextFieldWithTitle:@"昵称"
                                          content:self.nickNameModel.rightText
                                      placeholder:@"请输入昵称"
                                           length:10
                                       affirmText:@"确认"
                                           remark:@""
                                         isNumber:NO
                                          isEmpty:NO
                                     affirmAction:^(NSString * _Nonnull text) {
            wself.nickNameModel.rightText = text;
            wself.nickNameModel.stateHiden = 0;
            wself.editModel.nickname = text;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            wself.isEdit = YES;
        } cancelAction:^{
            
        }];
        return;
    }
    
    if ([model.leftTitle isEqualToString:self.ageModel.leftTitle]) {
        [[ASDataSelectManager alloc] selectViewOneDataWithType:kOneSelectViewAge value:self.ageModel.rightText listArray:@[] action:^(NSInteger index, id  _Nonnull value) {
            wself.ageModel.rightText = value;
            wself.editModel.age = value;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            wself.isEdit = YES;
        }];
        return;
    }
    
    if ([model.leftTitle isEqualToString:self.hometownModel.leftTitle]) {
        if (kObjectIsEmpty(self.provinceCitys)) {
            return;
        }
        [[ASDataSelectManager alloc] selectViewMoreDataWithType:kMoreSelectViewHometown listArray:self.hometownCitys action:^(NSString * _Nonnull key, id  _Nonnull value) {
            wself.hometownModel.rightText = value;
            wself.hometownModel.rightTextColor = TITLE_COLOR;
            wself.editModel.hometown = key;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            wself.isEdit = YES;
        }];
        return;
    }
    
    if ([model.leftTitle isEqualToString:self.addressModel.leftTitle]) {
        if (kObjectIsEmpty(self.provinceCitys)) {
            return;
        }
        [[ASDataSelectManager alloc] selectViewMoreDataWithType:kMoreSelectViewAddress listArray:self.provinceCitys action:^(NSString * _Nonnull key, id  _Nonnull value) {
            wself.addressModel.rightText = value;
            wself.addressModel.rightTextColor = TITLE_COLOR;
            wself.editModel.cityId = key;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            wself.isEdit = YES;
        }];
        return;
    }
    
    if ([model.leftTitle isEqualToString:self.heightModel.leftTitle]) {
        [[ASDataSelectManager alloc] selectViewOneDataWithType:kOneSelectViewStature value:self.heightModel.rightText listArray:self.selectData.height action:^(NSInteger index, id  _Nonnull value) {
            wself.heightModel.rightText = value;
            wself.editModel.height = value;
            wself.heightModel.rightTextColor = TITLE_COLOR;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            wself.isEdit = YES;
        }];
        return;
    }
    
    if ([model.leftTitle isEqualToString:self.weightModel.leftTitle]) {
        [[ASDataSelectManager alloc] selectViewOneDataWithType:kOneSelectViewWeight value:self.weightModel.rightText listArray:self.selectData.weight action:^(NSInteger index, id  _Nonnull value) {
            wself.weightModel.rightText = value;
            wself.editModel.weight = value;
            wself.weightModel.rightTextColor = TITLE_COLOR;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            wself.isEdit = YES;
        }];
        return;
    }
    
    if ([model.leftTitle isEqualToString:self.occupationModel.leftTitle]) {
        if (kObjectIsEmpty(self.selectData)) {
            return;
        }
        [[ASDataSelectManager alloc] selectViewMoreDataWithType:kMoreSelectViewOccupation listArray:self.selectData.occupation action:^(NSString * _Nonnull key, id  _Nonnull value) {
            wself.occupationModel.rightText = value;
            wself.occupationModel.rightTextColor = TITLE_COLOR;
            wself.editModel.occupation = key;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            wself.isEdit = YES;
        }];
        return;
    }
    
    if ([model.leftTitle isEqualToString:self.incomeModel.leftTitle]) {
        [[ASDataSelectManager alloc] selectViewOneDataWithType:kOneSelectViewIncome value:self.incomeModel.rightText listArray:self.selectData.annual_income action:^(NSInteger index, id  _Nonnull value) {
            wself.incomeModel.rightText = value;
            wself.editModel.annual_income = value;
            wself.incomeModel.rightTextColor = TITLE_COLOR;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            wself.isEdit = YES;
        }];
        return;
    }
    
    if ([model.leftTitle isEqualToString:self.educationModel.leftTitle]) {
        [[ASDataSelectManager alloc] selectViewOneDataWithType:kOneSelectViewEducation value:self.educationModel.rightText listArray:self.selectData.education action:^(NSInteger index, id  _Nonnull value) {
            wself.educationModel.rightText = value;
            wself.editModel.education = value;
            wself.educationModel.rightTextColor = TITLE_COLOR;
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            wself.isEdit = YES;
        }];
        return;
    }
    
    if ([model.leftTitle isEqualToString:self.myTagsModel.leftTitle]) {
        ASEditUserTagsController *vc = [[ASEditUserTagsController alloc] init];
        vc.selectTags = [NSMutableArray arrayWithArray:self.myTagsModel.tags];
        vc.saveBlock = ^(NSArray * _Nonnull tags) {
            wself.myTagsModel.tags = tags;
            wself.myTagsModel.rightText = @"";
            NSMutableArray *tagsString = [NSMutableArray array];
            for (ASTagsModel *tag in tags) {
                [tagsString addObject:tag.ID];
            }
            wself.editModel.label = [tagsString componentsJoinedByString: @","];
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            wself.isEdit = YES;
        };
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

//照片墙数据上传转成字符串
- (void)disposePictureWithImages:(NSArray *)images urlBlock:(void(^)(NSString *urls))urlBlock errorBack:(ResponseFail)errorBack {
    kWeakSelf(self);
    if (images.count > 0) {
        NSMutableArray *imgs = [[NSMutableArray alloc] init];
        NSMutableArray *urls = [[NSMutableArray alloc] init];
        for (id data in images) {
            if ([data isKindOfClass: UIImage.class]) {//新选择的图片
                [imgs addObject:data];
            }
            if ([data isKindOfClass: ASAlbumsModel.class]) {//已经上传的图片url
                ASAlbumsModel *model = data;
                [urls addObject:model.url];
            }
        }
        if (imgs.count > 0) {
            //有新选择图片，进行上传
            [[ASUploadImageManager shared] imagesUpdateWithAliOSSType:@"album" imgaes:imgs success:^(id  _Nonnull response) {
                NSArray *urlList = response;
                [urls addObjectsFromArray:urlList];
                urlBlock([urls componentsJoinedByString: @","]);
            } fail:^{
                errorBack(-1000, @"上传失败");
            }];
        } else {
            urlBlock([urls componentsJoinedByString: @","]);
        }
    } else {
        wself.editModel.albums = @"";
        urlBlock(@"");
    }
}

- (NSMutableArray *)lists {
    if (!_lists) {
        _lists = [[NSMutableArray alloc]init];
    }
    return _lists;
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.whiteColor;
    }
    return _tableView;
}

- (UILabel *)topHintText {
    if (!_topHintText) {
        _topHintText = [[UILabel alloc]init];
        _topHintText.textAlignment = NSTextAlignmentCenter;
        _topHintText.font = TEXT_FONT_14;
        _topHintText.textColor = MAIN_COLOR;
    }
    return _topHintText;
}

- (ASEditDataModel *)editModel {
    if (!_editModel) {
        _editModel = [[ASEditDataModel alloc]init];
    }
    return _editModel;
}

- (UILabel *)baseDataMoneyHint {
    if (!_baseDataMoneyHint) {
        _baseDataMoneyHint = [[UILabel alloc]init];
        _baseDataMoneyHint.backgroundColor = UIColorRGB(0xFFF1F3);
        _baseDataMoneyHint.font = TEXT_FONT_11;
        _baseDataMoneyHint.layer.cornerRadius = SCALES(10);
        _baseDataMoneyHint.layer.masksToBounds = YES;
        _baseDataMoneyHint.textColor = MAIN_COLOR;
        _baseDataMoneyHint.hidden = YES;
    }
    return _baseDataMoneyHint;
}
@end
