//
//  UIAlertController+Extension.m
//  AS
//
//  Created by SA on 2025/4/11.
//

#import "UIAlertController+Extension.h"
#import "Runner-Swift.h"

@implementation UIAlertController (Extension)

//用户主页提示私聊
+ (void)personalHomeChatAlertWithUserInfo:(ASUserInfoModel *)userInfo view:(UIView *)view {
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALES(80));
    bgView.backgroundColor = UIColor.clearColor;
    UIImageView *bgImage = [[UIImageView alloc] init];
    bgImage.image = [UIImage imageNamed:@"personal_im_pop"];
    [bgView addSubview:bgImage];
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(2));
        make.top.height.equalTo(bgView);
        make.width.mas_equalTo(SCALES(288));
    }];
    UIImageView *header = [[UIImageView alloc] init];
    [header sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, STRING(userInfo.avatar)]]];
    header.layer.cornerRadius = SCALES(6);
    header.layer.masksToBounds = YES;
    header.contentMode = UIViewContentModeScaleAspectFill;
    [bgImage addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(17));
        make.left.mas_equalTo(SCALES(17));
        make.width.height.mas_equalTo(SCALES(40));
    }];
    UILabel *nickName = [[UILabel alloc]init];
    nickName.font = TEXT_MEDIUM(14);
    nickName.text = STRING(userInfo.nickname);
    nickName.textColor = TITLE_COLOR;
    [bgImage addSubview:nickName];
    [nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header);
        make.height.mas_equalTo(SCALES(20));
        make.left.equalTo(header.mas_right).offset(SCALES(7));
        make.right.equalTo(bgImage).offset(-SCALES(20));
    }];
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = STRING(userInfo.text_content);
    textLabel.textColor = TEXT_SIMPLE_COLOR;
    textLabel.font = TEXT_FONT_14;
    [bgImage addSubview:textLabel];
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(header);
        make.height.mas_equalTo(SCALES(16));
        make.left.right.equalTo(nickName);
    }];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:bgView size:bgView.bounds.size];
    popupController.dismissAfterDelay = 3.0;
    popupController.maskType = zhPopupMaskTypeBlackOpacity;
    popupController.presentationStyle = zhPopupSlideStyleTransform;
    popupController.layoutType = zhPopupLayoutTypeTop;
    popupController.offsetSpacing = SCREEN_HEIGHT - SCALES(80) - TAB_BAR_MAGIN - SCALES(50);
    popupController.isHidenMaskView = YES;
    [popupController showInView:view duration:0.55 delay:0 options:UIViewAnimationOptionCurveLinear bounced:YES completion:nil];
}

//来消息提醒
+ (zhPopupController *)chatPopWithMessage:(NIMMessage *)message userHeader:(NSString *)userHeader affirmAction:(VoidBlock)affirmAction {
    UIImageView *mainView = [[UIImageView alloc]init];
    mainView.frame = CGRectMake(0, (SCREEN_WIDTH - SCALES(375))/2, SCALES(375), SCALES(102));
    mainView.image = [UIImage imageNamed:@"im_chat_pop"];
    mainView.userInteractionEnabled = YES;
    UIImageView *header = [[UIImageView alloc] init];
    if (kStringIsEmpty(userHeader)) {//本地地址为空，从服务器中获取
        [[NIMSDK sharedSDK].userManager fetchUserInfos:@[STRING(message.from)] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
            if (users.count > 0) {
                NIMUser *user = users[0];
                [header sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, STRING(user.userInfo.avatarUrl)]]];
            }
        }];
    } else {
        [header sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, STRING(userHeader)]]];
    }
    header.layer.cornerRadius = SCALES(8);
    header.layer.masksToBounds = YES;
    header.contentMode = UIViewContentModeScaleAspectFill;
    [mainView addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(mainView);
        make.left.mas_equalTo(SCALES(21));
        make.width.height.mas_equalTo(SCALES(60));
    }];
    UILabel *nickName = [[UILabel alloc]init];
    nickName.font = TEXT_MEDIUM(16);
    nickName.text = STRING(message.senderName);
    nickName.textColor = TITLE_COLOR;
    [mainView addSubview:nickName];
    [nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header).offset(SCALES(5));
        make.height.mas_equalTo(SCALES(20));
        make.left.equalTo(header.mas_right).offset(SCALES(10));
        make.right.equalTo(mainView).offset(SCALES(-100));
    }];
    UILabel *content = [[UILabel alloc]init];
    content.font = TEXT_FONT_14;
    content.text = [ASMyAppCommonFunc lastMessgeHint:message];
    content.textColor = TITLE_COLOR;
    [mainView addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(header.mas_bottom).offset(SCALES(-6));
        make.height.mas_equalTo(SCALES(18));
        make.left.right.equalTo(nickName);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = LINE_COLOR;
    [mainView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(mainView);
        make.right.equalTo(mainView.mas_right).offset(SCALES(-94));
        make.height.mas_equalTo(SCALES(24));
        make.width.mas_equalTo(SCALES(0.5));
    }];
    UILabel *replyText = [[UILabel alloc]init];
    replyText.textColor = MAIN_COLOR;
    replyText.font = TEXT_FONT_15;
    replyText.text = @"回复";
    replyText.textAlignment = NSTextAlignmentCenter;
    [mainView addSubview:replyText];
    [replyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(mainView);
        make.left.equalTo(line.mas_right);
        make.width.height.mas_equalTo(SCALES(80));
    }];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:mainView size:mainView.bounds.size];
    popupController.dismissAfterDelay = 3.0;
    popupController.maskType = zhPopupMaskTypeClear;
    popupController.presentationStyle = zhPopupSlideStyleFromTop;
    popupController.layoutType = zhPopupLayoutTypeBottom;
    popupController.offsetSpacing = SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - SCALES(102) - SCALES(12);
    popupController.isHidenMaskView = YES;
    [popupController showInView:kCurrentWindow duration:0.55 delay:0 options:UIViewAnimationOptionCurveLinear bounced:YES completion:nil];
    __weak typeof(popupController) wPopupController = popupController;
    //向上滑动
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] init];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [mainView addGestureRecognizer:recognizer];
    [[recognizer rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [wPopupController dismiss];
    }];
    //点击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [mainView addGestureRecognizer:tap];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [wPopupController dismiss];
        affirmAction();
    }];
    return popupController;
}

//上线提醒
+ (zhPopupController *)friendUpPopWithModel:(ASIMSystemNotifyDataModel *)model affirmAction:(VoidBlock)affirmAction {
    UIImageView *mainView = [[UIImageView alloc]init];
    mainView.frame = CGRectMake(0, (SCREEN_WIDTH - SCALES(375))/2, SCALES(375), SCALES(126));
    mainView.image = [UIImage imageNamed:@"im_chat_up"];
    mainView.userInteractionEnabled = YES;
    UIImageView *typeIcon = [[UIImageView alloc]init];
    typeIcon.image = [UIImage imageNamed:@"up_miyou"];
    [mainView addSubview:typeIcon];
    [typeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(mainView).offset(SCALES(14));
        make.size.mas_equalTo(CGSizeMake(SCALES(68), SCALES(24)));
    }];
    UIImageView *header = [[UIImageView alloc] init];
    [header sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, STRING(model.avatar)]]];
    header.layer.cornerRadius = SCALES(8);
    header.layer.masksToBounds = YES;
    header.contentMode = UIViewContentModeScaleAspectFill;
    [mainView addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(typeIcon.mas_bottom).offset(SCALES(7));
        make.left.mas_equalTo(SCALES(21));
        make.width.height.mas_equalTo(SCALES(60));
    }];
    UILabel *nickName = [[UILabel alloc]init];
    nickName.font = TEXT_MEDIUM(16);
    nickName.text = STRING(model.nickname);
    nickName.textColor = TITLE_COLOR;
    [mainView addSubview:nickName];
    [nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header).offset(SCALES(5));
        make.height.mas_equalTo(SCALES(20));
        make.left.equalTo(header.mas_right).offset(SCALES(10));
    }];
    UILabel *statusText = [[UILabel alloc]init];
    statusText.font = TEXT_MEDIUM(14);
    statusText.text = @"上线了";
    statusText.textColor = TITLE_COLOR;
    [mainView addSubview:statusText];
    [statusText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(27));
        make.right.equalTo(mainView.mas_right).offset(SCALES(-28));
        make.height.mas_equalTo(SCALES(18));
    }];
    UILabel *statusView = [[UILabel alloc]init];
    statusView.backgroundColor = UIColorRGB(0x35D78F);
    statusView.layer.cornerRadius = SCALES(4);
    statusView.layer.masksToBounds = YES;
    [mainView addSubview:statusView];
    [statusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(statusText.mas_left).offset(SCALES(-8));
        make.width.height.mas_equalTo(SCALES(8));
        make.centerY.equalTo(statusText);
    }];
    UIImageView *goChat = [[UIImageView alloc]init];
    goChat.image = [UIImage imageNamed:@"sixin_icon"];
    [mainView addSubview:goChat];
    [goChat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(statusText.mas_right);
        make.size.mas_equalTo(CGSizeMake(SCALES(51), SCALES(20)));
        make.top.mas_equalTo(SCALES(66));
    }];
    UILabel *content = [[UILabel alloc]init];
    content.font = TEXT_FONT_14;
    content.text = STRING(model.label);
    content.textColor = TEXT_SIMPLE_COLOR;
    [mainView addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(header.mas_bottom).offset(SCALES(-6));
        make.height.mas_equalTo(SCALES(20));
        make.left.equalTo(nickName);
        make.width.mas_equalTo(SCALES(170));
    }];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:mainView size:mainView.bounds.size];
    popupController.dismissAfterDelay = 3.0;
    popupController.maskType = zhPopupMaskTypeClear;
    popupController.presentationStyle = zhPopupSlideStyleFromBottom;
    popupController.layoutType = zhPopupLayoutTypeTop;
    popupController.offsetSpacing = SCREEN_HEIGHT - SCALES(12) - TAB_BAR_HEIGHT - SCALES(126);
    popupController.isHidenMaskView = YES;
    [popupController showInView:kCurrentWindow duration:0.55 delay:0 options:UIViewAnimationOptionCurveLinear bounced:YES completion:nil];
    
    __weak typeof(popupController) wPopupController = popupController;
    //向下滑动
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] init];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [mainView addGestureRecognizer:recognizer];
    [[recognizer rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [wPopupController dismiss];
    }];
    //点击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [mainView addGestureRecognizer:tap];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [wPopupController dismiss];
        affirmAction();
    }];
    return popupController;
}

//礼物飘屏
+ (zhPopupController *)giftPiaoPingWithModel:(ASIMSystemNotifyDataModel *)model {
    UIView *mainView = [[UIView alloc]init];
    mainView.frame = CGRectMake(0, 0, SCREEN_WIDTH - SCALES(16), SCALES(60));
    mainView.backgroundColor = UIColor.clearColor;
    UIImageView *bgImage = [[UIImageView alloc]init];
    bgImage.image = [UIImage imageNamed:@"gift_piao_pop"];
    bgImage.contentMode = UIViewContentModeScaleAspectFill;
    [mainView addSubview:bgImage];
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.height.equalTo(mainView);
        make.width.mas_equalTo(SCALES(286));
    }];
    //头像
    UIImageView *header = [[UIImageView alloc]init];
    header.layer.cornerRadius = SCALES(18);
    header.layer.masksToBounds = YES;
    header.layer.borderWidth = SCALES(1.5);
    header.layer.borderColor = UIColor.whiteColor.CGColor;
    header.contentMode = UIViewContentModeScaleAspectFill;
    [bgImage addSubview:header];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(10));
        make.top.mas_equalTo(SCALES(10));
        make.height.width.mas_equalTo(SCALES(36));
    }];
    [header sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.avatar]]];
    //对方头像
    UIImageView *toHeader = [[UIImageView alloc]init];
    toHeader.layer.cornerRadius = SCALES(15);
    toHeader.layer.masksToBounds = YES;
    toHeader.layer.borderWidth = SCALES(1.5);
    toHeader.layer.borderColor = UIColor.whiteColor.CGColor;
    toHeader.contentMode = UIViewContentModeScaleAspectFill;
    [bgImage addSubview:toHeader];
    [toHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(39));
        make.top.mas_equalTo(SCALES(19));
        make.height.width.mas_equalTo(SCALES(30));
    }];
    [toHeader sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.toavatar]]];
    UILabel *nickNameTitle = [[UILabel alloc]init];
    nickNameTitle.textColor = MAIN_COLOR;
    nickNameTitle.font = TEXT_MEDIUM(14);
    [bgImage addSubview:nickNameTitle];
    [nickNameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(78));
        make.top.mas_equalTo(SCALES(9));
        make.height.mas_equalTo(SCALES(18));
        make.right.offset(SCALES(-46));
    }];
    NSString *nickname = model.nickname.length > 5 ? [NSString stringWithFormat:@"%@...",[model.nickname substringToIndex:5]] : model.nickname;
    NSString *tonickname = model.tonickname.length > 5 ? [NSString stringWithFormat:@"%@...",[model.tonickname substringToIndex:5]] : model.tonickname;
    NSString *name = [NSString stringWithFormat:@"%@ 送给 %@", nickname, tonickname];
    NSMutableAttributedString *nameAttributed = [[NSMutableAttributedString alloc] initWithString:name];
    //设置部分字体颜色name
    [nameAttributed addAttribute:NSForegroundColorAttributeName
                           value:TITLE_COLOR
                           range:NSMakeRange(nickname.length + 1, 2)];
    //设置部分字体字号
    [nameAttributed addAttribute:NSFontAttributeName
                           value:TEXT_FONT_14
                           range:NSMakeRange(nickname.length + 1, 2)];
    [nickNameTitle setAttributedText:nameAttributed];
    UILabel *content = [[UILabel alloc]init];
    content.textColor = TITLE_COLOR;
    content.font = TEXT_FONT_14;
    content.text = [NSString stringWithFormat:@"%@ x%zd", STRING(model.giftname), model.gifttotal];
    [bgImage addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickNameTitle);
        make.top.equalTo(nickNameTitle.mas_bottom).offset(SCALES(7));
        make.height.mas_equalTo(SCALES(16));
    }];
    UIImageView *giftIcon = [[UIImageView alloc]init];
    [giftIcon sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",SERVER_IMAGE_URL, model.giftimg]]];
    [mainView addSubview:giftIcon];
    [giftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(251));
        make.centerY.equalTo(mainView);
        make.width.height.mas_equalTo(SCALES(44));
    }];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:mainView size:mainView.bounds.size];
    popupController.dismissAfterDelay = 4.0;
    popupController.maskType = zhPopupMaskTypeClear;
    popupController.presentationStyle = zhPopupSlideStyleFromRight;
    popupController.dismissonStyle = zhPopupSlideStyleFade;//结束动画
    popupController.layoutType = zhPopupLayoutTypeBottom;
    popupController.offsetSpacing = SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - SCALES(58) - SCALES(100);
    popupController.isHidenMaskView = YES;
    [popupController showInView:kCurrentWindow duration:2 delay:0 options:UIViewAnimationOptionCurveLinear bounced:YES completion:nil];
    return popupController;
}

//是否开通消息提醒view
+ (zhPopupController *)systemNotifyLimitPopView:(UIView *)view affirmAction:(VoidBlock)affirmAction {
    UIView *mainView = [[UIView alloc]init];
    mainView.frame = CGRectMake(SCALES(16), 0, SCREEN_WIDTH - SCALES(32), SCALES(48));
    mainView.backgroundColor = UIColor.clearColor;
    UIImageView *bgImage = [[UIImageView alloc]init];
    bgImage.image = [UIImage imageNamed:@"im_notify_bg"];
    bgImage.contentMode = UIViewContentModeScaleAspectFill;
    bgImage.userInteractionEnabled = YES;
    [mainView addSubview:bgImage];
    [bgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(mainView);
    }];
    UILabel *text = [[UILabel alloc]init];
    text.text = @"打开通知权限，及时接收消息!";
    text.textColor = UIColor.whiteColor;
    text.font = TEXT_FONT_14;
    [bgImage addSubview:text];
    [text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(SCALES(8));
        make.centerY.equalTo(mainView);
    }];
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close3"] forState:UIControlStateNormal];
    [bgImage addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-SCALES(8));
        make.centerY.equalTo(mainView);
        make.size.mas_equalTo(CGSizeMake(SCALES(16), SCALES(16)));
    }];
    UILabel *goOpen = [[UILabel alloc]init];
    goOpen.backgroundColor = UIColor.whiteColor;
    goOpen.textColor = MAIN_COLOR;
    goOpen.textAlignment = NSTextAlignmentCenter;
    goOpen.font = TEXT_FONT_14;
    goOpen.text = @"点击开启";
    goOpen.layer.cornerRadius = SCALES(12);
    goOpen.layer.masksToBounds = YES;
    [bgImage addSubview:goOpen];
    [goOpen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-SCALES(32));
        make.centerY.equalTo(mainView);
        make.size.mas_equalTo(CGSizeMake(SCALES(72), SCALES(24)));
    }];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:mainView size:mainView.bounds.size];
    popupController.maskType = zhPopupMaskTypeClear;
    popupController.presentationStyle = zhPopupSlideStyleFade;
    popupController.dismissonStyle = zhPopupSlideStyleFade;//结束动画
    popupController.layoutType = zhPopupLayoutTypeTop;
    popupController.offsetSpacing = SCREEN_HEIGHT - TAB_BAR_HEIGHT - SCALES(48) - SCALES(16);
    popupController.isHidenMaskView = YES;
    [popupController showInView:view duration:0.55 delay:0 options:UIViewAnimationOptionCurveLinear bounced:YES completion:nil];
    __weak typeof(popupController) wPopupController = popupController;
    //点击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [mainView addGestureRecognizer:tap];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [wPopupController dismiss];
        affirmAction();
    }];
    [[closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [wPopupController dismiss];
    }];
    return popupController;
}

//微信悬浮弹窗提示微信登录
+ (zhPopupController *)wechatLoginWithView:(UIView *)view affirmAction:(VoidBlock)affirmAction {
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(SCALES(28), 0, SCREEN_WIDTH - SCALES(56), SCALES(110));
    bgView.backgroundColor = UIColor.whiteColor;
    bgView.layer.cornerRadius = SCALES(15);
    bgView.layer.masksToBounds = YES;
    UILabel *hintTitle = [[UILabel alloc] init];
    hintTitle.text = @"长时间未收到验证码？试试微信一键登录";
    hintTitle.textColor = TITLE_COLOR;
    hintTitle.font = TEXT_FONT_15;
    [bgView addSubview:hintTitle];
    [hintTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.mas_equalTo(SCALES(15));
        make.height.mas_equalTo(SCALES(21));
    }];
    UIButton *login = [[UIButton alloc] init];
    [login setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
    [login setTitle:@"微信一键登录" forState:UIControlStateNormal];
    login.titleLabel.font = TEXT_MEDIUM(18);
    login.adjustsImageWhenHighlighted = NO;
    login.layer.cornerRadius = SCALES(20);
    login.layer.masksToBounds = YES;
    [bgView addSubview:login];
    [login mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.mas_equalTo(SCALES(54));
        make.size.mas_equalTo(CGSizeMake(SCALES(180), SCALES(40)));
    }];
    zhPopupController *popupController = [[zhPopupController alloc] initWithView:bgView size:bgView.bounds.size];
    popupController.dismissAfterDelay = 5.0;
    popupController.maskType = zhPopupMaskTypeClear;
    popupController.presentationStyle = zhPopupSlideStyleFromTop;
    popupController.layoutType = zhPopupLayoutTypeBottom;
    popupController.offsetSpacing = SCREEN_HEIGHT - NAVIGATION_BAR_HEIGHT - SCALES(110) - SCALES(6);
    popupController.isHidenMaskView = YES;
    [popupController showInView:view duration:0.55 delay:0 options:UIViewAnimationOptionCurveLinear bounced:YES completion:nil];
    __weak typeof(popupController) wPopupController = popupController;
    [[login rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [wPopupController dismiss];
        affirmAction();
    }];
    return popupController;
}
@end
