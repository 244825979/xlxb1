//
//  ASVideoShowDemonstrationController.m
//  AS
//
//  Created by SA on 2025/5/13.
//

#import "ASVideoShowDemonstrationController.h"
#import "ASVideoShowRequest.h"

@interface ASVideoShowDemonstrationController ()

@end

@implementation ASVideoShowDemonstrationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"视频秀示例图";
    [self createUI];
}

- (void)createUI {
    UIImageView *demonstrationImage = [[UIImageView alloc] init];
    demonstrationImage.image = [UIImage imageNamed:@"video_demonstration"];
    [self.view addSubview:demonstrationImage];
    [demonstrationImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(SCALES(16));
        make.width.mas_equalTo(SCALES(343));
        make.height.mas_equalTo(SCALES(230));
    }];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TITLE_COLOR;
    titleLabel.font = TEXT_FONT_15;
    titleLabel.attributedText = [ASCommonFunc attributedWithString:@"视频秀可展示在消息列表/个人主页，极大增加曝光率哦!其中视频秀可展示在个人主页。" lineSpacing:SCALES(4.0)];
    titleLabel.numberOfLines = 0;
    [self.view addSubview:titleLabel];
    [titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(demonstrationImage.mas_bottom).offset(SCALES(16));
        make.left.right.equalTo(demonstrationImage);
    }];
    UILabel *titleLabel1 = [[UILabel alloc] init];
    titleLabel1.textColor = RED_COLOR;
    titleLabel1.font = TEXT_FONT_20;
    titleLabel1.text = @"上传要求：";
    [self.view addSubview:titleLabel1];
    [titleLabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(SCALES(28));
        make.left.equalTo(titleLabel);
        make.height.mas_equalTo(SCALES(28));
    }];
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.textColor = TITLE_COLOR;
    textLabel.font = TEXT_FONT_15;
    textLabel.attributedText = [ASCommonFunc attributedWithString:@"1.必须是本人动态露脸视频，不能遮挡面部\n2.舞蹈，唱歌，变装表演，能够获得更多推荐\n3.请上传3秒≤时长≤15秒的清晰视频" lineSpacing:SCALES(4.0)];
    textLabel.numberOfLines = 0;
    [self.view addSubview:textLabel];
    [textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel1.mas_bottom).offset(SCALES(16));
        make.left.equalTo(titleLabel1);
        make.right.equalTo(titleLabel1);
    }];
    UIButton *nextBtn = [[UIButton alloc] init];
    [nextBtn setTitle:@"立即上传" forState:UIControlStateNormal];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
    nextBtn.adjustsImageWhenHighlighted = NO;
    nextBtn.titleLabel.font = TEXT_FONT_18;
    nextBtn.layer.masksToBounds = YES;
    nextBtn.layer.cornerRadius = SCALES(25);
    [nextBtn addTarget:self action:@selector(nextBtnCliked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(-TAB_BAR_MAGIN - SCALES(16));
        make.height.mas_equalTo(SCALES(50));
        make.width.mas_equalTo(SCALES(311));
    }];
}

- (void)nextBtnCliked:(UIButton *)button {
    kWeakSelf(self);
    [[ASAuthStateVerifyManager shared] isCertificationState:kRpAuthPopVideoShow succeed:^{
        [ASVideoShowRequest requestVideoShowCheckDayAcountSuccess:^(id  _Nullable data) {
            [[ASUploadImageManager shared] selectVideoShowPickerWithViewController:wself didFinish:^(UIImage * _Nonnull coverImage, PHAsset * _Nonnull asset) {
                [ASVideoShowManager popPublishVideoShowWithAssets:asset];
            }];
        } errorBack:^(NSInteger code, NSString *msg) {
            
        }];
    }];
}
@end
