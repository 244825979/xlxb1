//
//  ASSetCostController.m
//  AS
//
//  Created by SA on 2025/4/22.
//

#import "ASSetCostController.h"
#import "ASSetRequest.h"

@interface ASSetCostController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) ASBaseTableView *tableView;
@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic, strong) NSArray *msgSelects;
@property (nonatomic, strong) NSArray *voiceSelects;
@property (nonatomic, strong) NSArray *videoSelects;
@property (nonatomic, strong) ASSetCellModel *msgPrice;
@property (nonatomic, strong) ASSetCellModel *voicePrice;
@property (nonatomic, strong) ASSetCellModel *videoPrice;
@end

@implementation ASSetCostController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleText = @"收费设置";
    [self createUI];
    [self requestList];
}

- (void)createUI {
    kWeakSelf(self);
    [self.tableView registerClass:[ASBaseCommonCell class] forCellReuseIdentifier:@"baseCommonCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.lists addObject: self.msgPrice];
    [self.lists addObject: self.voicePrice];
    [self.lists addObject: self.videoPrice];
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setTitle:@"说明" forState:UIControlStateNormal];
    [btn setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    btn.titleLabel.font = TEXT_FONT_15;
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
        vc.webUrl = STRING(USER_INFO.configModel.webUrl.chargeRule);
        [wself.navigationController pushViewController:vc animated:YES];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIView *footerView = [[UIView alloc]init];
    footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCALES(200));
    self.tableView.tableFooterView = footerView;
    YYLabel *hint = [[YYLabel alloc]init];
    hint.attributedText = [ASTextAttributedManager collectFeeSetAgreement:^{
        ASBaseWebViewController *vc = [[ASBaseWebViewController alloc]init];
        vc.webUrl = STRING(USER_INFO.configModel.webUrl.anchorStarlevel);
        [wself.navigationController pushViewController:vc animated:YES];
    }];
    hint.numberOfLines = 0;
    hint.preferredMaxLayoutWidth = SCREEN_WIDTH - SCALES(32);
    [footerView addSubview:hint];
    [hint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView).offset(SCALES(12));
        make.left.mas_equalTo(SCALES(16));
        make.right.equalTo(footerView.mas_right).offset(SCALES(-16));
    }];
}

- (void)requestList {
    kWeakSelf(self);
    [ASSetRequest requestMyCollectFeeDataWithSuccess:^(id _Nullable data) {
        wself.msgPrice.rightText = STRING(data[@"msg_price"]);
        wself.voicePrice.rightText = STRING(data[@"voice_price"]);
        wself.videoPrice.rightText = STRING(data[@"video_price"]);
        [wself.tableView reloadData];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
    
    [ASSetRequest requestCollectFeeSelectListWithSuccess:^(id _Nullable data) {
        wself.msgSelects = [ASCollectFeeSelectModel mj_objectArrayWithKeyValuesArray:data[@"chat"]];
        wself.voiceSelects = [ASCollectFeeSelectModel mj_objectArrayWithKeyValuesArray:data[@"voice"]];
        wself.videoSelects = [ASCollectFeeSelectModel mj_objectArrayWithKeyValuesArray:data[@"video"]];
    } errorBack:^(NSInteger code, NSString *msg) {
        
    }];
}

- (ASSetCellModel *)msgPrice {
    if (!_msgPrice) {
        _msgPrice = [[ASSetCellModel alloc]init];
        _msgPrice.cellType = kSetCommonCellText;
        _msgPrice.leftTitle = @"消息价格";
    }
    return _msgPrice;
}

- (ASSetCellModel *)voicePrice {
    if (!_voicePrice) {
        _voicePrice = [[ASSetCellModel alloc]init];
        _voicePrice.cellType = kSetCommonCellText;
        _voicePrice.leftTitle = @"语音价格";
    }
    return _voicePrice;
}

- (ASSetCellModel *)videoPrice {
    if (!_videoPrice) {
        _videoPrice = [[ASSetCellModel alloc]init];
        _videoPrice.cellType = kSetCommonCellText;
        _videoPrice.leftTitle = @"视频价格";
    }
    return _videoPrice;
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ASSetCellModel *model = self.lists[indexPath.row];
    id cell = [tableView dequeueReusableCellWithIdentifier:model.cellIndentify forIndexPath:indexPath];
    [cell setModel:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCALES(50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    kWeakSelf(self);
    ASSetCellModel *model = self.lists[indexPath.row];
    if ([model.leftTitle isEqualToString:@"消息价格"]) {
        if (kObjectIsEmpty(self.msgSelects) || self.msgSelects.count == 0) {
            return;
        }
        [[ASDataSelectManager alloc] selectViewOneDataWithType:kOneSelectViewCollectFee value:STRING(model.rightText) listArray:self.msgSelects action:^(NSInteger index, id  _Nonnull value) {
            ASCollectFeeSelectModel *model = value;
            [ASSetRequest requestSetCollectFeeWithModel:model type:@"5" success:^(id  _Nullable data) {
                wself.msgPrice.rightText = [NSString stringWithFormat:@"%zd%@/条",model.coins, model.content];
                wself.msgPrice.rightTextColor = TITLE_COLOR;
                kShowToast(@"价格设置成功!");
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        }];
        return;
    }
    
    if ([model.leftTitle isEqualToString:@"语音价格"]) {
        if (kObjectIsEmpty(self.voiceSelects) || self.voiceSelects.count == 0) {
            return;
        }
        [[ASDataSelectManager alloc] selectViewOneDataWithType:kOneSelectViewCollectFee value:STRING(model.rightText) listArray:self.voiceSelects action:^(NSInteger index, id  _Nonnull value) {
            ASCollectFeeSelectModel *model = value;
            [ASSetRequest requestSetCollectFeeWithModel:model type:@"1" success:^(id  _Nullable data) {
                wself.voicePrice.rightText = [NSString stringWithFormat:@"%zd%@/分钟",model.coins, model.content];
                wself.voicePrice.rightTextColor = TITLE_COLOR;
                kShowToast(@"价格设置成功!");
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        }];
        return;
    }
    
    if ([model.leftTitle isEqualToString:@"视频价格"]) {
        if (kObjectIsEmpty(self.videoSelects) || self.videoSelects.count == 0) {
            return;
        }
        [[ASDataSelectManager alloc] selectViewOneDataWithType:kOneSelectViewCollectFee value:STRING(model.rightText) listArray:self.videoSelects action:^(NSInteger index, id  _Nonnull value) {
            ASCollectFeeSelectModel *model = value;
            [ASSetRequest requestSetCollectFeeWithModel:model type:@"2" success:^(id  _Nullable data) {
                wself.videoPrice.rightText = [NSString stringWithFormat:@"%zd%@/分钟",model.coins, model.content];
                wself.videoPrice.rightTextColor = TITLE_COLOR;
                kShowToast(@"价格设置成功!");
                [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
            } errorBack:^(NSInteger code, NSString *msg) {
                
            }];
        }];
        return;
    }
}

- (ASBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[ASBaseTableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray *)lists {
    if (!_lists) {
        _lists = [[NSMutableArray alloc]init];
    }
    return _lists;
}
@end
