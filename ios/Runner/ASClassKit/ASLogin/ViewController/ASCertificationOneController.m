//
//  ASCertificationOneController.m
//  AS
//
//  Created by SA on 2025/5/23.
//  认证页

#import "ASCertificationOneController.h"

@interface ASCertificationOneController ()
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UIButton *nextBtn;
@end

@implementation ASCertificationOneController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldNavigationBarHidden = YES;
    [self createUI];
}

- (void)createUI {
    kWeakSelf(self);
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(STATUS_BAR_HEIGHT);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(44);
    }];
    [[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [wself.navigationController popViewControllerAnimated:YES];
        if (wself.backBlock) {
            wself.backBlock();
        }
    }];
    UILabel *navigationItemTitle = [[UILabel alloc] init];
    navigationItemTitle.font = TEXT_MEDIUM(18);
    navigationItemTitle.text = @"上传照片";
    navigationItemTitle.textColor = TITLE_COLOR;
    [self.view addSubview:navigationItemTitle];
    [navigationItemTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backBtn);
        make.centerX.equalTo(self.view);
    }];
    UILabel *title = [[UILabel alloc] init];
    title.font = TEXT_FONT_22;
    title.text = @"请上传本人高清正面靓照";
    title.textColor = TITLE_COLOR;
    [self.view addSubview:title];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(backBtn.mas_bottom).offset(SCALES(29));
        make.height.mas_equalTo(SCALES(32));
    }];
    UILabel *content = [[UILabel alloc] init];
    content.font = TEXT_FONT_14;
    content.text = @"五官清晰的照片，会更受欢迎哦";
    content.textColor = TEXT_SIMPLE_COLOR;
    [self.view addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(title);
        make.top.equalTo(title.mas_bottom).offset(SCALES(14));
        make.height.mas_equalTo(SCALES(18));
    }];
    [self.view addSubview:self.headView];
    self.headView.contentMode = UIViewContentModeScaleAspectFill;
    NSString *avatar = [ASUserDefaults valueForKey:@"register_avatar"];
    if (!kStringIsEmpty(avatar)) {
        self.userAvatar = avatar;
        [self.headView sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, avatar]]];
    } else {
        [self.headView sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, kStringIsEmpty(self.userAvatar) ? self.userModel.avatar : self.userAvatar]]];
    }
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(content.mas_bottom).offset(SCALES(40));
        make.size.mas_equalTo(CGSizeMake(SCALES(120), SCALES(120)));
    }];
    UIButton *updateHead = [[UIButton alloc] init];
    [updateHead setTitle:@"重新上传" forState:UIControlStateNormal];
    [updateHead setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
    updateHead.adjustsImageWhenHighlighted = NO;
    updateHead.titleLabel.font = TEXT_FONT_14;
    updateHead.layer.masksToBounds = YES;
    updateHead.layer.cornerRadius = SCALES(15);
    [self.view addSubview:updateHead];
    [updateHead mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.headView);
        make.top.equalTo(self.headView.mas_bottom).offset(SCALES(12));
        make.height.mas_equalTo(SCALES(30));
        make.width.mas_equalTo(SCALES(94));
    }];
    [[updateHead rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[ASUploadImageManager shared] selectImagePickerWithMaxCount:1 isSelfieCamera:YES viewController:wself didFinish:^(NSArray<UIImage *> * _Nonnull photos, NSArray * _Nonnull assets, BOOL isSelectOriginalPhoto) {
            [[ASUploadImageManager shared] oneImageUpdateWithAliOSSType:@"album" imgae:photos[0] success:^(id _Nonnull response) {
                NSString *url = response;
                wself.userAvatar = url;
                wself.headView.image = photos[0];
            } fail:^{
                
            }];
        }];
    }];
    UIImageView *hintIcon = [[UIImageView alloc] init];
    hintIcon.image = [UIImage imageNamed:@"auth_hint"];
    [self.view addSubview:hintIcon];
    [hintIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(updateHead.mas_bottom).offset(SCALES(38));
        make.size.mas_equalTo(CGSizeMake(SCALES(340), SCALES(104)));
    }];
    [self.view addSubview:self.nextBtn];
    [[self.nextBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
        vc.webUrl = [NSString stringWithFormat:@"%@?avatar=%@", USER_INFO.systemIndexModel.verifyAuth, (kStringIsEmpty(wself.userAvatar) ? wself.userModel.avatar : wself.userAvatar)];
        vc.backBlock = ^{
            if (!kObjectIsEmpty(wself.userModel)) {
                [USER_INFO saveUserDataWithModel:wself.userModel complete:^{
                    [[ASLoginManager shared] loginSuccess];
                }];
            }
        };
        [wself.navigationController pushViewController:vc animated:YES];
        if (wself.showNavigation == YES) {
            vc.showNavigationTitle = @"真人认证";
        }
    }];
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(hintIcon.mas_bottom).offset(SCALES(54));
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCALES(285), SCALES(50)));
    }];
}

- (UIImageView *)headView {
    if (!_headView) {
        _headView = [[UIImageView alloc]init];
        _headView.layer.masksToBounds = YES;
        _headView.layer.cornerRadius = SCALES(10);
        _headView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headView;
}

- (UIButton *)nextBtn {
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc]init];
        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
        _nextBtn.adjustsImageWhenHighlighted = NO;
        _nextBtn.titleLabel.font = TEXT_FONT_18;
        _nextBtn.layer.masksToBounds = YES;
        _nextBtn.layer.cornerRadius = SCALES(25);
        [_nextBtn setTitle:@"开始认证" forState:UIControlStateNormal];
    }
    return _nextBtn;
}
@end
