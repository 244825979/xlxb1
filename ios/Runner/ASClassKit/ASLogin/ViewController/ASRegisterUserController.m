//
//  ASRegisterUserController.m
//  AS
//
//  Created by SA on 2025/4/14.
//

#import "ASRegisterUserController.h"
#import "ASLoginRequest.h"
#import "ASRegisterGenderView.h"
#import "ASRegisterTextView.h"
#import "ASManNameListModel.h"
#import <UMLink/UMLink.h>

@interface ASRegisterUserController ()<MobClickLinkDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *upHeader;
@property (nonatomic, strong) ASRegisterGenderView *manView;
@property (nonatomic, strong) ASRegisterGenderView *womanView;
@property (nonatomic, strong) ASRegisterTextView *nameView;
@property (nonatomic, strong) ASRegisterTextView *ageView;
@property (nonatomic, strong) ASRegisterTextView *invitationView;
@property (nonatomic, strong) UIButton *loginBtn;
/*数据*/
@property (nonatomic, copy) NSString *headUrl;//上传成功头像的路径
@property (nonatomic, assign) BOOL isMan;//是否是男
@property (nonatomic, assign) BOOL isWechatHeadUpload;//是否上传过微信头像
@property (nonatomic, strong) NSArray *manNameList;//男用户昵称列表
@property (nonatomic, strong) NSArray *manHeadList;//男用户头像列表
@end

@implementation ASRegisterUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    self.isMan = YES;
    [self createUI];
    [self requestManNameList];
}

- (void)popVC {
    kWeakSelf(self);
    [self.view endEditing:YES];
    [ASAlertViewManager defaultPopTitle:@"是否放弃注册" content:@"" left:@"确定" right:@"取消" isTouched:YES affirmAction:^{
        [wself.navigationController popViewControllerAnimated:YES];
    } cancelAction:^{
        
    }];
}

#pragma mark - MobClickLinkDelegate
- (void)getLinkPath:(NSString *)path params:(NSDictionary *)params {
    self.invitationView.textField.text = params[@"userCode"];
}

- (void)createUI {
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    kWeakSelf(self);
    UIButton *backBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [wself.scrollView endEditing:YES];
        if (wself.backBlock) {
            wself.backBlock();
        }
    }];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATUS_BAR_HEIGHT);
        make.left.mas_equalTo(12);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    UILabel *title = [[UILabel alloc]init];
    title.text = @"注册";
    title.textColor = TITLE_COLOR;
    title.font = TEXT_MEDIUM(20);
    title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(backBtn);
    }];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(HEIGHT_NAVBAR);
        make.left.right.bottom.equalTo(self.view);
    }];
    [self.scrollView addSubview:self.upHeader];
    if (!kStringIsEmpty(self.iconurl)) {
        [self.upHeader sd_setImageWithURL:[NSURL URLWithString:self.iconurl]];
        self.headUrl = self.iconurl;
    }
    UITapGestureRecognizer *upHeaderTap = [[UITapGestureRecognizer alloc] init];
    [self.upHeader addGestureRecognizer:upHeaderTap];
    [[upHeaderTap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [wself upHeaderSelect];
    }];
    [self.upHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.scrollView);
        make.top.equalTo(self.scrollView.mas_top).offset(SCALES(48));
        make.size.mas_equalTo(CGSizeMake(SCALES(99), SCALES(99)));
    }];
    UIImageView *cameraIcon = [[UIImageView alloc]init];
    cameraIcon.image = [UIImage imageNamed:@"up_camera"];
    [self.scrollView addSubview:cameraIcon];
    [cameraIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.upHeader).offset(SCALES(8));
        make.top.equalTo(self.upHeader.mas_bottom).offset(SCALES(14));
        make.size.mas_equalTo(CGSizeMake(SCALES(16), SCALES(16)));
    }];
    UILabel *upText = [[UILabel alloc]init];
    upText.text = @"上传头像";
    upText.textColor = TEXT_SIMPLE_COLOR;
    upText.font = TEXT_MEDIUM(14);
    upText.userInteractionEnabled = YES;
    UITapGestureRecognizer *upHeaderTap1 = [[UITapGestureRecognizer alloc] init];
    [upText addGestureRecognizer:upHeaderTap1];
    [[upHeaderTap1 rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [wself upHeaderSelect];
    }];
    [self.scrollView addSubview:upText];
    [upText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cameraIcon.mas_right).offset(SCALES(10));
        make.centerY.equalTo(cameraIcon);
    }];
    [self.scrollView addSubview:self.manView];
    [self.manView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cameraIcon.mas_bottom).offset(SCALES(35));
        make.right.equalTo(self.scrollView.mas_centerX).offset(SCALES(-8));
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH/2 - SCALES(40), SCALES(48)));
    }];
    [self.scrollView addSubview:self.womanView];
    [self.womanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.width.height.equalTo(self.manView);
        make.left.equalTo(self.scrollView.mas_centerX).offset(SCALES(8));
    }];
    [self.scrollView addSubview:self.nameView];
    if (!kStringIsEmpty(self.name)) {
        self.nameView.textField.text = self.name;
    }
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(32));
        make.width.mas_equalTo(SCREEN_WIDTH - SCALES(64));
        make.top.equalTo(self.manView.mas_bottom);
        make.height.mas_equalTo(SCALES(62));
    }];
    [self.scrollView addSubview:self.ageView];
    [self.ageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.nameView);
        make.top.equalTo(self.nameView.mas_bottom);
    }];
    [self.scrollView addSubview:self.invitationView];
    [self.invitationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.nameView);
        make.top.equalTo(self.ageView.mas_bottom);
    }];
    [self.scrollView addSubview:self.loginBtn];
    [[self.loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [wself.scrollView endEditing:YES];
        if (!kStringIsEmpty(wself.iconurl) && wself.isWechatHeadUpload == NO) {//如果用的微信头像，需要先下载下来，再进行上传到服务器，再进行注册
            [[ASUploadImageManager shared] oneImageUpdateWithAliOSSType:@"album" imgae:wself.upHeader.image success:^(id _Nonnull response) {
                wself.isWechatHeadUpload = YES;
                NSString *url = response;
                wself.headUrl = url;
                [wself requestRegister];
            } fail:^{
                
            }];
        } else {
            [wself requestRegister];
        }
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.invitationView.mas_bottom).offset(SCALES(48));
        make.left.right.equalTo(self.nameView);
        make.height.mas_equalTo(SCALES(50));
    }];
    YYLabel *agreementView = [[YYLabel alloc] init];
    agreementView.numberOfLines = 0;
    agreementView.attributedText = [ASTextAttributedManager contactUsAgreement:^{
        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
        vc.webUrl = [NSString stringWithFormat:@"%@%@",SERVER_AGREEMENT_URL, Web_URL_Customer];
        [wself.navigationController pushViewController:vc animated:YES];
    }];
    [self.scrollView addSubview:agreementView];
    [agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginBtn.mas_bottom).offset(SCALES(16));
        make.centerX.equalTo(self.scrollView);
        make.bottom.equalTo(self.scrollView.mas_bottom).offset(SCALES(-30));
    }];
    //获取一下用户的userCode
    [MobClickLink getInstallParams:^(NSDictionary *params, NSURL *URL, NSError *error) {
        ASLog(@"--------------getInstallParams = %@ = URL = %@", params, URL);
        if (error) {
            return;
        }
        if (URL.absoluteString.length > 0 || params.count > 0) {
            [MobClickLink handleLinkURL:URL delegate:self];
        }
    }];
}

- (void)requestManNameList {
    kWeakSelf(self);
    [ASLoginRequest requestRegisterManNameSuccess:^(id  _Nullable data) {
        ASManNameListModel *model = data;
        if (model.nickname.count > 0) {
            if (kStringIsEmpty(wself.name)) {
                ASManNameModel *nickName = model.nickname[0];
                wself.nameView.textField.text = nickName.name;
            }
            wself.manNameList = model.nickname;
        }
        if (model.avatar.count > 0) {
            if (kStringIsEmpty(wself.iconurl)) {
                NSString *headUrl = [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.avatar[0]];
                wself.headUrl = model.avatar[0];
                [wself.upHeader sd_setImageWithURL:[NSURL URLWithString:headUrl]];
            }
            wself.manHeadList = model.avatar;
        }
        [wself verifyButton];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (void)upHeaderSelect {
    kWeakSelf(self);
    [[ASUploadImageManager shared] selectImagePickerWithMaxCount:1 isSelfieCamera:YES viewController:wself didFinish:^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
        [[ASUploadImageManager shared] oneImageUpdateWithAliOSSType:@"album" imgae:photos[0] success:^(id _Nonnull response) {
            wself.iconurl = @"";
            NSString *url = response;
            wself.headUrl = url;
            wself.upHeader.image = photos[0];
            [wself verifyButton];
        } fail:^{
            
        }];
    }];
}

- (void)requestRegister {
    if (self.nameView.textField.text.length > 10) {
        kShowToast(@"昵称长度不大于10个字符");
        return;
    }
    NSString *age = [self.ageView.textField.text stringByReplacingOccurrencesOfString:@"岁" withString:@""];
    [ASLoginRequest requestProfileRegNewWithNickName:self.nameView.textField.text
                                              avatar:self.headUrl
                                              gender:self.isMan ? @"2" : @"1"
                                                 age:age
                                          inviteCode:self.invitationView.textField.text
                                      showNavigation:self.showNavigation
                                       isWeChatFirst:self.isWeChatFirst
                                             success:^(id  _Nullable data) {
        [[ASLoginManager shared] loginSuccess];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (void)verifyButton {
    if (!kStringIsEmpty(self.nameView.textField.text) &&
        !kStringIsEmpty(self.ageView.textField.text) &&
        !kStringIsEmpty(self.headUrl)) {
        self.loginBtn.userInteractionEnabled = YES;
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
    } else {
        self.loginBtn.userInteractionEnabled = NO;
        [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
    }
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIImageView *)upHeader {
    if (!_upHeader) {
        _upHeader = [[UIImageView alloc]init];
        _upHeader.contentMode = UIViewContentModeScaleAspectFill;
        _upHeader.layer.borderColor = LINE_COLOR.CGColor;
        _upHeader.layer.borderWidth = SCALES(1);
        _upHeader.layer.cornerRadius = SCALES(16);
        _upHeader.layer.masksToBounds = YES;
        _upHeader.userInteractionEnabled = YES;
    }
    return _upHeader;
}

- (ASRegisterGenderView *)manView {
    if (!_manView) {
        _manView = [[ASRegisterGenderView alloc]init];
        _manView.isMan = YES;
        _manView.isSelect = YES;
        kWeakSelf(self);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_manView addGestureRecognizer:tap];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.isMan == YES) {
                return;
            }
            wself.isMan = YES;
            wself.nameView.isMan = YES;
            wself.womanView.isSelect = NO;
            wself.manView.isSelect = YES;
            int r = arc4random() % wself.manNameList.count;//随机数
            ASManNameModel *nickName = wself.manNameList[r];
            wself.nameView.textField.text = nickName.name;
            if (kStringIsEmpty(wself.iconurl)) {
                NSString *headUrl = [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, wself.manHeadList[0]];
                wself.headUrl = wself.manHeadList[0];
                [wself.upHeader sd_setImageWithURL:[NSURL URLWithString:headUrl]];
            } else {
                [wself.upHeader sd_setImageWithURL:[NSURL URLWithString:wself.iconurl]];
                wself.headUrl = wself.iconurl;
            }
            [wself verifyButton];
        }];
    }
    return _manView;
}

- (ASRegisterGenderView *)womanView {
    if (!_womanView) {
        _womanView = [[ASRegisterGenderView alloc]init];
        _womanView.isMan = NO;
        _womanView.isSelect = NO;
        kWeakSelf(self);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        [_womanView addGestureRecognizer:tap];
        [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            if (wself.isMan == NO) {
                return;
            }
            wself.nameView.isMan = NO;
            wself.isMan = NO;
            wself.manView.isSelect = NO;
            wself.womanView.isSelect = YES;
            //重置昵称和头像
            wself.nameView.textField.text = @"";
            wself.headUrl = @"";
            wself.upHeader.image = [UIImage imageNamed:@"register_upload_head"];
            [wself verifyButton];
        }];
    }
    return _womanView;
}

- (ASRegisterTextView *)nameView {
    if (!_nameView) {
        _nameView = [[ASRegisterTextView alloc]init];
        _nameView.viewType = kTextViewName;
        kWeakSelf(self);
        _nameView.inputBlock = ^(NSString * _Nonnull text) {
            [wself verifyButton];
        };
        _nameView.changeNameBlock = ^() {
            if (wself.isMan == YES) {
                int r = arc4random() % wself.manNameList.count;//随机数
                ASManNameModel *nickName = wself.manNameList[r];
                wself.nameView.textField.text = nickName.name;
            } else {
                wself.nameView.textField.text = @"";
            }
            [wself verifyButton];
        };
    }
    return _nameView;
}

- (ASRegisterTextView *)ageView {
    if (!_ageView) {
        _ageView = [[ASRegisterTextView alloc]init];
        _ageView.viewType = kTextViewSelectAge;
        kWeakSelf(self);
        _ageView.inputBlock = ^(NSString * _Nonnull text) {
            [wself verifyButton];
        };
    }
    return _ageView;
}

- (ASRegisterTextView *)invitationView {
    if (!_invitationView) {
        _invitationView = [[ASRegisterTextView alloc]init];
        _invitationView.viewType = kTextViewInvitation;
    }
    return _invitationView;
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] init];
        _loginBtn.adjustsImageWhenHighlighted = NO;
        _loginBtn.userInteractionEnabled = NO;
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = TEXT_MEDIUM(18);
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = SCALES(25);
        [_loginBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    return _loginBtn;
}
@end
