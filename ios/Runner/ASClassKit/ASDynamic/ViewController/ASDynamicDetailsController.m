//
//  ASDynamicDetailsController.m
//  AS
//
//  Created by SA on 2025/5/8.
//

#import "ASDynamicDetailsController.h"
#import "ASDynamicRequest.h"
#import "ASCommentInputView.h"
#import "ASDynamicListCell.h"
#import "ASDynamicCommentCell.h"
#import "ASDynamicCommentModel.h"
#import "ASReportController.h"

@interface ASDynamicDetailsController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) ASCommentInputView *inputView;
@property (nonatomic, strong) UIButton *sendBtn;
/**数据**/
@property (nonatomic, assign) BOOL isDel;
@property (nonatomic, strong) NSLayoutConstraint *bottomCons;
@property (nonatomic, strong) NSLayoutConstraint *bottomHCons;
@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic, copy) NSString *commentID;
@property (nonatomic, assign) NSInteger page;
@end

@implementation ASDynamicDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"动态详情";
    [self createUI];
    [self requestDetail];
}

- (void)createUI {
    self.isDel = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.tableView.mj_header = [ASRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(onRefresh)];
    self.tableView.mj_footer = [ASRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(onNextPage)];
    kWeakSelf(self);
    UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [moreBtn setImage:[UIImage imageNamed:@"more1"] forState:UIControlStateNormal];
    [[moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSString *title = [wself.model.user_id isEqualToString:USER_INFO.user_id] ? @"删除" : @"举报该条动态";
        [ASAlertViewManager bottomPopTitles:@[title] indexAction:^(NSString *indexName) {
            if ([indexName isEqualToString:@"删除"]) {
                [ASAlertViewManager defaultPopTitle:@"提示" content:@"是否确定删除这条动态？" left:@"删除" right:@"取消" affirmAction:^{
                    [ASDynamicRequest requestDynamicDeleteWithID:wself.model.ID success:^(NSNumber * _Nullable data) {
                        kShowToast(@"删除成功");
                        [wself.navigationController popViewControllerAnimated:YES];
                        if (wself.delBlock) {
                            wself.delBlock();
                        }
                    } errorBack:^(NSInteger code, NSString *msg) {
                        
                    }];
                } cancelAction:^{
                    
                }];
                return;
            }
            
            if ([indexName isEqualToString:@"举报该条动态"]) {
                ASReportController *vc = [[ASReportController alloc] init];
                vc.uid = wself.model.ID;
                vc.type = kReportTypeDynamic;
                ASBaseNavigationController *nav = [[ASBaseNavigationController alloc] initWithRootViewController:vc];
                nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
                [wself presentViewController:nav animated:YES completion:nil];
                return;
            }
        } cancelAction:^{
            
        }];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
    self.bottomView = ({
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = UIColor.whiteColor;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:view];
        view;
    });
    self.bottomCons = [self.bottomView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0];
    self.bottomHCons = [self.bottomView.heightAnchor constraintEqualToConstant:SCALES(50) + TAB_BAR_MAGIN];
    [NSLayoutConstraint activateConstraints:@[[self.bottomView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:0],
                                              [self.bottomView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:0]]];
    
    [self.bottomCons setActive:YES];
    [self.bottomHCons setActive:YES];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    
    ASCommentInputView *textView = [[ASCommentInputView alloc]init];
    [self.bottomView addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.right.equalTo(self.bottomView.mas_right).offset(-84);
        make.top.mas_equalTo(7.5);
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-(2.5+TAB_BAR_MAGIN));
    }];
    textView.backgroundColor = UIColorRGB(0xF5F5F5);
    textView.placeholder = @"   请输入想说的话";
    textView.placeholderColor = TEXT_SIMPLE_COLOR;
    textView.maxNumberOfLines = 4;
    textView.font = TEXT_FONT_15;
    textView.textContainerInset = UIEdgeInsetsMake(8, 10, 8, 10);
    textView.yz_textHeightChangeBlock = ^(NSString *text, CGFloat textHeight){
        wself.bottomHCons.constant = textHeight + 10;
    };
    self.inputView = textView;
    
    self.sendBtn = ({
        UIButton *button = [[UIButton alloc]init];
        [button setTitle:@"发送" forState:UIControlStateNormal];
        button.titleLabel.font = TEXT_FONT_12;
        button.layer.cornerRadius = 13;
        button.layer.masksToBounds = YES;
        [button setBackgroundColor:GRDUAL_CHANGE_BG_COLOR(54, 26)];
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            [[ASAuthStateVerifyManager shared] isCertificationState:kRpAuthDefaultPop succeed:^{
                [wself requestComment];
            }];
        }];
        [self.bottomView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.inputView);
            make.size.mas_equalTo(CGSizeMake(54, 26));
            make.right.equalTo(self.bottomView.mas_right).offset(-16);
        }];
        button;
    });
}

- (void)keyboardWillShow:(NSNotification*)notification {
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.bottomCons.constant = -CGRectGetHeight(endFrame) + TAB_BAR_MAGIN;
    kWeakSelf(self);
    [UIView animateWithDuration:duration animations:^{
        [wself.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    self.inputView.placeholder = @"   请输入想说的话";
    self.commentID = nil;
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    self.bottomCons.constant = 0;
    kWeakSelf(self);
    [UIView animateWithDuration:duration animations:^{
        [wself.view layoutIfNeeded];
    }];
}

- (void)onRefresh {
    self.page = 1;
    [self requestList];
    [self.tableView.mj_footer endRefreshing];
    self.tableView.mj_footer.hidden = NO;
}

- (void)onNextPage{
    if (kObjectIsEmpty(self.lists)){
        self.tableView.mj_footer.hidden = YES;
        return;
    }
    [self requestList];
}

- (void)requestDetail {
    kWeakSelf(self);
    [ASDynamicRequest requestDynamicDetailWithID:self.model.ID success:^(id  _Nullable data) {
        ASDynamicListModel *detailModel = data;
        if (kStringIsEmpty(wself.model.nickname)) {
            wself.model.avatar = detailModel.user.avatar;
            wself.model.nickname = detailModel.user.nickname;
            wself.model.is_beckon = detailModel.is_beckon;
            wself.model.age = detailModel.user.age;
            wself.model.gender = detailModel.user.gender;
            wself.model.vip = detailModel.is_vip;
            wself.model.user_id = detailModel.user.user_id;
            wself.model.nickname = detailModel.user.nickname;
            wself.model.content = detailModel.content;
            wself.model.cover_url = detailModel.video.cover_url;
            wself.model.file_url = detailModel.video.file_url;
            wself.model.images = detailModel.images;
            wself.model.create_time = detailModel.create_time;
            wself.model.like_count = detailModel.like_count;
            wself.model.comment_count = detailModel.comment_count;
            wself.model.is_like = detailModel.is_like;
        }
        wself.isDel = NO;
        [wself onRefresh];
    } errorBack:^(NSInteger code, NSString *msg) {
        wself.isDel = YES;
        wself.inputView.hidden = YES;
        wself.sendBtn.hidden = YES;
        if (code == 60001) {
            wself.tableView.emptyType = kTableViewEmptyDynamicDel;
        } else {
            wself.tableView.emptyType = kTableViewEmptyLoadFail;
        }
        [wself.tableView reloadData];
    }];
}

- (void)requestComment {
    if (kStringIsEmpty(self.inputView.text)) {
        kShowToast(@"请输入要发布的内容");
        return;
    }
    kWeakSelf(self);
    [ASDynamicRequest requestCommentWithID:self.model.ID commentID:self.commentID content:wself.inputView.text success:^(id  _Nullable data) {
        wself.inputView.text = @"";
        [wself.inputView resignFirstResponder];
        [wself.inputView textDidChange];
        wself.model.comment_count++;
        [wself onRefresh];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (void)requestList {
    if (self.isDel == YES) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        return;
    }
    kWeakSelf(self);
    [ASDynamicRequest requestCommentListWithID:self.model.ID page:self.page success:^(id  _Nullable data) {
        NSArray *array = data;
        if(wself.page == 1){
            wself.lists = [NSMutableArray arrayWithArray:array];
            [wself.tableView.mj_header endRefreshing];
            if (wself.lists.count == 0) {
                wself.tableView.mj_footer.hidden = YES;
            }
        } else {
            [wself.lists addObjectsFromArray:array];
            [wself.tableView.mj_footer endRefreshing];
        }
        wself.page++;
        [wself.tableView reloadData];
    } errorBack:^(NSInteger code, NSString *msg) {
        [wself.tableView.mj_footer endRefreshing];
        [wself.tableView.mj_header endRefreshing];
    }];
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.isDel == YES) {
        return 0;
    }
    return 2;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isDel == YES) {
        return 0;
    }
    if (section == 0) {
        return 1;
    }
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && self.isDel == NO) {
        static NSString *iden = @"dynamicListCell";
        ASDynamicListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell){
            cell = [[ASDynamicListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        }
        cell.model = self.model;
        cell.hiddenMore = YES;
        if (kStringIsEmpty(self.model.nickname)) {
            cell.contentView.hidden = YES;
        } else {
            cell.contentView.hidden = NO;
        }
        kWeakSelf(self);
        cell.clikedBlock = ^(NSString * _Nonnull indexName) {
            wself.commentID = nil;
            [wself.inputView becomeFirstResponder];
        };
        return cell;
    } else {
        static NSString *iden = @"dynamicCommentCell";
        ASDynamicCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell){
            cell = [[ASDynamicCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        }
        cell.model = self.lists[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isDel == YES) {
        return 0;
    }
    if (indexPath.section == 0) {
        return self.model.cellHeight;
    } else {
        ASDynamicCommentModel *model = self.lists[indexPath.row];
        return model.cellHeight;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01f;
    }
    return SCALES(30);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = UIColor.whiteColor;
        UILabel *text = [[UILabel alloc] init];
        text.font = TEXT_FONT_16;
        text.text = [NSString stringWithFormat:@"评论（%zd）", self.model.comment_count];
        text.textColor = TITLE_COLOR;
        [view addSubview:text];
        [text mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(SCALES(6));
            make.left.mas_equalTo(SCALES(16));
            make.height.mas_equalTo(SCALES(24));
        }];
        text.hidden = self.model.comment_count == 0 ? YES : NO;
        return view;
    }
    return [[UIView alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ASDynamicCommentModel *model = self.lists[indexPath.row];
        if ([model.user_id isEqualToString:USER_INFO.user_id]) {
            return;
        }
        self.inputView.placeholder = [NSString stringWithFormat:@"   回复 %@", model.nickname];
        self.commentID = model.ID;
        [self.inputView becomeFirstResponder];
    }
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
