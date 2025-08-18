//
//  ASReportDetailsController.m
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASReportDetailsController.h"
#import "ASReportDetailsCell.h"
#import "ASSetRequest.h"
#import "ASReportDetailsReplenishView.h"
#import "ASReportDetailsHeadView.h"
#import "ASReportDetailsTopDataView.h"

@interface ASReportDetailsController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) ASReportDetailsHeadView *topStateView;
@property (nonatomic, strong) ASReportDetailsTopDataView *topDataView;
@property (nonatomic, strong) ASReportDetailsReplenishView *replenishView;//补充材料
@property (nonatomic, strong) UIButton *submitBtn;
/**数据**/
@property (nonatomic, strong) NSArray *selectedPhotos;
@property (nonatomic, strong) NSString *content;
@end

@implementation ASReportDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"举报详情";
    self.view.backgroundColor = BACKGROUNDCOLOR;
    [self createUI];
    [self requestUserData];
}

- (void)createUI {
    kWeakSelf(self);
    [self.view addSubview:self.tableView];
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = BACKGROUNDCOLOR;
    headView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    self.headView = headView;
    [headView addSubview:self.topStateView];
    [self.topStateView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(SCALES(10));
        make.left.right.equalTo(headView);
        make.height.mas_equalTo(SCALES(68));
    }];
    [headView addSubview:self.topDataView];
    [self.topDataView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topStateView.mas_bottom).offset(SCALES(10));
        make.left.right.equalTo(headView);
        make.bottom.equalTo(headView.mas_bottom).offset(SCALES(-10));
    }];
    self.tableView.tableHeaderView = headView;
    if (self.model.status == 1 || self.model.status == 2) {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    } else {
        [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
        }];
        [self.view addSubview:self.submitBtn];
        [self.submitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_bottom).offset(SCALES(10));
            make.centerX.equalTo(self.view);
            make.size.mas_equalTo(CGSizeMake(SCALES(319), SCALES(48)));
            make.bottom.equalTo(self.view.mas_bottom).offset(-(SCALES(10) + TAB_BAR_MAGIN20));
        }];
        switch (self.model.status) {
            case 0://受理中
                self.submitBtn.userInteractionEnabled = YES;
                [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
                [self.submitBtn setTitle:@"撤销举报" forState:UIControlStateNormal];
                [self.submitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
                break;
            case 3://已撤销
                self.submitBtn.userInteractionEnabled = NO;
                [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
                [self.submitBtn setTitle:@"已撤销" forState:UIControlStateNormal];
                [self.submitBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
                break;
            case 4://待补充材料
                self.submitBtn.userInteractionEnabled = NO;
                [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
                [self.submitBtn setTitle:@"提交" forState:UIControlStateNormal];
                [self.submitBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
                break;
            case 5://审核中
                self.submitBtn.userInteractionEnabled = NO;
                [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
                [self.submitBtn setTitle:@"已提交" forState:UIControlStateNormal];
                [self.submitBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
    if (self.model.status == 1 || self.model.status == 2 || self.model.status == 4 || self.model.status == 5) {
        self.replenishView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALES(20));
        self.tableView.tableFooterView = self.replenishView;
        if (self.model.status == 4) {
            self.replenishView.backBlock = ^(NSString * _Nonnull content, NSArray * _Nonnull images) {
                wself.selectedPhotos = images;
                wself.content = content;
                wself.model.selectedPhotosCount = (images.count + 1) > 9 ? 9 : images.count + 1;
                wself.replenishView.height = SCALES(70) + wself.model.reasonHeight + SCALES(104) + wself.model.replenishCollectionHeight;
                [wself.tableView reloadData];
                if (!kStringIsEmpty(content) && images.count > 0) {
                    wself.submitBtn.userInteractionEnabled = YES;
                    [wself.submitBtn setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
                    [wself.submitBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
                } else {
                    wself.submitBtn.userInteractionEnabled = NO;
                    [wself.submitBtn setBackgroundImage:[UIImage imageNamed:@"button_bg1"] forState:UIControlStateNormal];
                    [wself.submitBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
                }
            };
        }
    }
}

- (void)requestUserData {
    kWeakSelf(self);
    [ASSetRequest requestReportDetailWithID:self.model.ID success:^(id  _Nullable data) {
        wself.model = data;
        wself.topStateView.hidden = NO;
        wself.topStateView.model = wself.model;
        wself.topDataView.hidden = NO;
        wself.topDataView.model = wself.model;
        wself.headView.height = SCALES(30) + SCALES(68) + SCALES(146) + wself.model.textHeight + SCALES(28) + wself.model.collectionHeight + SCALES(6);
        wself.replenishView.model = wself.model;
        if (wself.model.status == 1 || wself.model.status == 2) {
            wself.replenishView.height = SCALES(70) + wself.model.reasonHeight;
        }
        if (wself.model.status == 4 || wself.model.status == 5) {
            wself.replenishView.height = SCALES(70) + wself.model.reasonHeight + SCALES(221);
        }
        [wself.tableView reloadData];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (void)saveRequestWithUrls:(NSString *)urls {
    kWeakSelf(self);
    [ASSetRequest requestReplenishWithReportId:wself.model.ID images:urls content:wself.content success:^(id  _Nonnull response) {
        [ASAlertViewManager defaultPopTitle:@"补充举报成功"
                                    content:@"我们已接收到您的举报补充内容，请耐心等待审核。"
                                       left:@"确定"
                                      right:@""
                                  isTouched:NO
                               affirmAction:^{
            [wself.navigationController popViewControllerAnimated:YES];
            if (wself.backBlock) {
                wself.backBlock(0);//补充审核中的回调
            }
        } cancelAction:^{
        
        }];
    } errorBack:^(NSInteger code, NSString * _Nonnull message) {
        
    }];
}

#pragma mark tableViewDelegate
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.more.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"cell";
    ASReportDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell){
        cell = [[ASReportDetailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.model = self.model.more[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASReportDetailsMoreModel *model = self.model.more[indexPath.row];
    return model.textHeight + model.reasonHeight + model.collectionHeight + SCALES(54) + SCALES(73) + SCALES(34);
}

- (ASReportDetailsHeadView *)topStateView {
    if (!_topStateView) {
        _topStateView = [[ASReportDetailsHeadView alloc]init];
        _topStateView.backgroundColor = UIColor.whiteColor;
        _topStateView.hidden = YES;
    }
    return _topStateView;
}

- (ASReportDetailsTopDataView *)topDataView {
    if (!_topDataView) {
        _topDataView = [[ASReportDetailsTopDataView alloc]init];
        _topDataView.backgroundColor = UIColor.whiteColor;
        _topDataView.hidden = YES;
    }
    return _topDataView;
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc] init];
        _tableView.backgroundColor = BACKGROUNDCOLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [[UIButton alloc] init];
        _submitBtn.titleLabel.font = TEXT_MEDIUM(18);
        [_submitBtn setTitleColor:TEXT_SIMPLE_COLOR forState:UIControlStateNormal];
        _submitBtn.adjustsImageWhenHighlighted = NO;
        kWeakSelf(self);
        [[_submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            if (wself.model.status == 0) {//撤销举报
                [ASAlertViewManager defaultPopTitle:@"温馨提示"
                                            content:@"您确定要撤销投诉吗？"
                                               left:@"确定"
                                              right:@"取消"
                                          isTouched:NO
                                       affirmAction:^{
                    [ASSetRequest requestReportDrawWithID:wself.model.ID success:^(id  _Nonnull response) {
                        [wself.navigationController popViewControllerAnimated:YES];
                        if (wself.backBlock) {
                            wself.backBlock(3);
                        }
                    } errorBack:^(NSInteger code, NSString * _Nonnull message) {
                        
                    }];
                } cancelAction:^{
                
                }];
                return;
            }
            if (wself.model.status == 4) {//补充材料提交
                [[ASUploadImageManager shared] imagesUpdateWithAliOSSType:@"album" imgaes:wself.selectedPhotos success:^(id  _Nonnull response) {
                    NSArray *urls = response;
                    NSString *urlsString = [urls componentsJoinedByString: @","];
                    [wself saveRequestWithUrls:urlsString];
                } fail:^{
                }];
                return;
            }
        }];
    }
    return _submitBtn;
}

- (ASReportDetailsReplenishView *)replenishView {
    if (!_replenishView) {
        _replenishView = [[ASReportDetailsReplenishView alloc]init];
        _replenishView.backgroundColor = UIColor.whiteColor;
    }
    return _replenishView;
}
@end
