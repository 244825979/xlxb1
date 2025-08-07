//
//  ASDataSelectManager.m
//  AS
//
//  Created by SA on 2025/4/15.
//

#import "ASDataSelectManager.h"
#import "BRPickerView.h"

@interface ASDataSelectManager()
@property (nonatomic, copy) NSArray <NSNumber *> *addressSelectIndexs;
@property (nonatomic, copy) NSArray <NSNumber *> *linkage2SelectIndexs;
@end

@implementation ASDataSelectManager

//单选
- (void)selectViewOneDataWithType:(OneSelectViewType)type
                            value:(NSString *)value
                        listArray:(NSArray *)listArray
                           action:(SelectBlock)selectAction {
    
    switch (type) {
        case kOneSelectViewAge:
            {
                NSArray *dataList = @[@"18岁", @"19岁", @"20岁", @"21岁", @"22岁", @"23岁", @"24岁", @"25岁", @"26岁", @"27岁",
                                      @"28岁", @"29岁", @"30岁", @"31岁", @"32岁", @"33岁" ,@"34岁" ,@"35岁", @"36岁", @"37岁",
                                      @"38岁", @"39岁", @"40岁", @"41岁", @"42岁", @"43岁" ,@"44岁" ,@"45岁", @"46岁", @"47岁",
                                      @"48岁", @"49岁" ,@"50岁", @"51岁" ,@"52岁", @"53岁", @"54岁" ,@"55岁", @"56岁" ,@"57岁",
                                      @"58岁", @"59岁", @"60岁"];
                NSString *strValue = kStringIsEmpty(value) ? @"35岁" : STRING(value);
                BRTextPickerView *stringPickerView = [[BRTextPickerView alloc]init];
                stringPickerView.pickerMode = BRTextPickerComponentSingle;
                stringPickerView.title = @"年龄";
                stringPickerView.dataSourceArr = listArray.count > 0 ? listArray : dataList;//数据源
                stringPickerView.selectIndex = [dataList indexOfObject:strValue];
                stringPickerView.singleResultBlock = ^(BRTextModel * _Nullable resultModel, NSInteger index) {
                    selectAction(resultModel.index, resultModel.text);
                };
                
                stringPickerView.pickerStyle = [self pickerStyle];
                [stringPickerView show];
            }
            break;
        case kOneSelectViewStature:
            {
                NSArray *dataList = @[@"60cm", @"61cm", @"62cm", @"63cm", @"64cm", @"65cm", @"66cm", @"67cm", @"68cm", @"69cm", @"70cm", @"71cm", @"72cm", @"73cm", @"74cm", @"75cm", @"76cm", @"77cm", @"78cm", @"79cm", @"80cm", @"81cm", @"82cm", @"83cm", @"84cm", @"85cm", @"86cm", @"87cm", @"88cm", @"89cm", @"90cm", @"91cm", @"92cm", @"93cm", @"94cm", @"95cm", @"96cm", @"97cm", @"98cm", @"99cm", @"100cm", @"101cm", @"102cm", @"103cm", @"104cm", @"105cm", @"106cm", @"107cm", @"108cm", @"109cm", @"110cm", @"111cm", @"112cm", @"113cm", @"114cm", @"115cm", @"116cm", @"117cm", @"118cm", @"119cm", @"120cm", @"121cm", @"122cm", @"123cm", @"124cm", @"125cm", @"126cm", @"127cm", @"128cm", @"129cm", @"130cm", @"131cm", @"132cm", @"133cm", @"134cm", @"135cm", @"136cm", @"137cm", @"138cm", @"139cm", @"140cm", @"141cm", @"142cm", @"143cm", @"144cm", @"145cm", @"146cm", @"147cm", @"148cm", @"149cm", @"150cm", @"151cm", @"152cm", @"153cm", @"154cm", @"155cm", @"156cm", @"157cm", @"158cm", @"159cm", @"160cm", @"161cm", @"162cm", @"163cm", @"164cm", @"165cm", @"166cm", @"167cm", @"168cm", @"169cm", @"170cm", @"171cm", @"172cm", @"173cm", @"174cm", @"175cm", @"176cm", @"177cm", @"178cm", @"179cm", @"180cm", @"181cm", @"182cm", @"183cm", @"184cm", @"185cm", @"186cm", @"187cm", @"188cm", @"189cm", @"190cm", @"191cm", @"192cm", @"193cm", @"194cm", @"195cm", @"196cm", @"197cm", @"198cm", @"199cm", @"200cm"];
                NSString *strValue = (kStringIsEmpty(value) || [value isEqualToString:@"未设置"]) ? @"170cm" : STRING(value);
                BRTextPickerView *stringPickerView = [[BRTextPickerView alloc]init];
                stringPickerView.pickerMode = BRTextPickerComponentSingle;
                stringPickerView.title = @"选择你的身高（cm)";
                stringPickerView.dataSourceArr = listArray.count > 0 ? listArray : dataList;//数据源
                stringPickerView.selectIndex = [dataList indexOfObject:strValue];
                stringPickerView.singleResultBlock = ^(BRTextModel * _Nullable resultModel, NSInteger index) {
                    selectAction(resultModel.index, resultModel.text);
                };
                stringPickerView.pickerStyle = [self pickerStyle];
                [stringPickerView show];
            }
            break;
        case kOneSelectViewWeight:
            {
                NSArray *dataList = @[@"40kg", @"41kg", @"42kg", @"43kg", @"44kg", @"45kg", @"46kg", @"47kg",
                                      @"48kg", @"49kg", @"50kg", @"51kg", @"52kg", @"53kg", @"54kg", @"55kg",
                                      @"56kg", @"57kg", @"58kg", @"59kg", @"60kg", @"61kg", @"62kg", @"63kg", @"64kg",
                                      @"65kg", @"66kg", @"67kg", @"68kg", @"69kg", @"70kg", @"71kg", @"72kg", @"73kg",
                                      @"74kg", @"75kg", @"76kg", @"77kg", @"78kg", @"79kg", @"80kg", @"81kg", @"82kg",
                                      @"83kg", @"84kg", @"85kg", @"86kg", @"87kg", @"88kg", @"89kg", @"90kg", @"91kg",
                                      @"92kg", @"93kg", @"94kg", @"95kg", @"96kg", @"97kg", @"98kg", @"99kg", @"100kg"];
                NSString *strValue = (kStringIsEmpty(value) || [value isEqualToString:@"未设置"]) ? @"50kg" : STRING(value);
                BRTextPickerView *stringPickerView = [[BRTextPickerView alloc]init];
                stringPickerView.pickerMode = BRTextPickerComponentSingle;
                stringPickerView.title = @"选择你的体重（kg)";
                stringPickerView.dataSourceArr = listArray.count > 0 ? listArray : dataList;//数据源
                stringPickerView.selectIndex = [dataList indexOfObject:strValue];
                stringPickerView.singleResultBlock = ^(BRTextModel * _Nullable resultModel, NSInteger index) {
                    selectAction(resultModel.index, resultModel.text);
                };
                stringPickerView.pickerStyle = [self pickerStyle];
                [stringPickerView show];
            }
            break;
        case kOneSelectViewIncome:
            {
                NSArray *dataList = @[@"保密", @"5万以下", @"5-10万", @"10-20万", @"20-30万", @"30-50万", @"50万以上"];
                NSString *strValue = (kStringIsEmpty(value) || [value isEqualToString:@"未设置"]) ? @"保密" : STRING(value);
                BRTextPickerView *stringPickerView = [[BRTextPickerView alloc]init];
                stringPickerView.pickerMode = BRTextPickerComponentSingle;
                stringPickerView.title = @"当前年收入情况（元)";
                stringPickerView.dataSourceArr = listArray.count > 0 ? listArray : dataList;//数据源
                stringPickerView.selectIndex = [dataList indexOfObject:strValue];
                stringPickerView.singleResultBlock = ^(BRTextModel * _Nullable resultModel, NSInteger index) {
                    selectAction(resultModel.index, resultModel.text);
                };
                stringPickerView.pickerStyle = [self pickerStyle];
                [stringPickerView show];
            }
            break;
        case kOneSelectViewEducation:
            {
                NSArray *dataList = @[@"初中及以下", @"中专", @"高中", @"大专", @"本科", @"硕士", @"博士"];
                NSString *strValue = (kStringIsEmpty(value) || [value isEqualToString:@"未设置"]) ? @"初中及以下" : STRING(value);
                BRTextPickerView *stringPickerView = [[BRTextPickerView alloc]init];
                stringPickerView.pickerMode = BRTextPickerComponentSingle;
                stringPickerView.title = @"选择你的学历";
                stringPickerView.dataSourceArr = listArray.count > 0 ? listArray : dataList;//数据源
                stringPickerView.selectIndex = [dataList indexOfObject:strValue];
                stringPickerView.singleResultBlock = ^(BRTextModel * _Nullable resultModel, NSInteger index) {
                    selectAction(resultModel.index, resultModel.text);
                };
                stringPickerView.pickerStyle = [self pickerStyle];
                [stringPickerView show];
            }
            break;
        case kOneSelectViewCollectFee:
            {
                BRTextPickerView *stringPickerView = [[BRTextPickerView alloc]init];
                stringPickerView.pickerMode = BRTextPickerComponentSingle;
                stringPickerView.title = @"选择价格";
                stringPickerView.dataSourceArr = [self getCollectFeeSets:listArray];//数据源
                stringPickerView.selectIndex = [listArray indexOfObject:value];
                stringPickerView.singleResultBlock = ^(BRTextModel * _Nullable resultModel, NSInteger index) {
                    ASCollectFeeSelectModel *model = resultModel.extras;
                    if (model.status == 2) {
                        kShowToast(@"您的等级不够，无法设置该选项");
                        return;
                    }
                    selectAction(resultModel.index, resultModel.extras);
                };
                stringPickerView.pickerStyle = [self pickerStyle];
                [stringPickerView show];
            }
            break;
        default:
            break;
    }
}

//多选
- (void)selectViewMoreDataWithType:(MoreSelectViewType)type
                         listArray:(NSArray *)listArray
                            action:(MoreSelectBlock)selectAction {
    switch (type) {
        case kMoreSelectViewHometown:
        {
            BRTextPickerView *stringPickerView = [[BRTextPickerView alloc]init];
            stringPickerView.pickerMode = BRTextPickerComponentCascade;
            stringPickerView.title = @"选择你的家乡";
            stringPickerView.dataSourceArr = [self getProvinceCitys:listArray];//数据源
            stringPickerView.selectIndexs = @[@0, @0];//第二列的index数据
            stringPickerView.showColumnNum = 2;
            stringPickerView.multiResultBlock = ^(NSArray<BRTextModel *> *resultModelArr, NSArray<NSNumber *> *indexs) {
                if (resultModelArr.count > 1) {
                    BRTextModel *model = resultModelArr[1];
                    selectAction(model.code, model.text);
                } else {
                    BRTextModel *model = resultModelArr[0];
                    selectAction(model.code, model.text);
                }
            };
            stringPickerView.pickerStyle = [self pickerStyle];
            [stringPickerView show];
        }
            break;
        case kMoreSelectViewAddress:
        {
            BRTextPickerView *stringPickerView = [[BRTextPickerView alloc]init];
            stringPickerView.pickerMode = BRTextPickerComponentCascade;
            stringPickerView.title = @"选择你的所在地";
            stringPickerView.dataSourceArr = [self getProvinceCitys:listArray];//数据源
            stringPickerView.selectIndexs = @[@0, @0];//第二列的index数据
            stringPickerView.showColumnNum = 2;
            stringPickerView.multiResultBlock = ^(NSArray<BRTextModel *> *resultModelArr, NSArray<NSNumber *> *indexs) {
                if (resultModelArr.count > 1) {
                    BRTextModel *model = resultModelArr[1];
                    selectAction(model.code, model.text);
                } else {
                    BRTextModel *model = resultModelArr[0];
                    selectAction(model.code, model.text);
                }
            };
            stringPickerView.pickerStyle = [self pickerStyle];
            [stringPickerView show];
        }
            break;
        case kMoreSelectViewOccupation:
        {
            BRTextPickerView *stringPickerView = [[BRTextPickerView alloc]init];
            stringPickerView.pickerMode = BRTextPickerComponentCascade;
            stringPickerView.title = @"选择你的职业";
            stringPickerView.dataSourceArr = [self getOccupations:listArray];//数据源
            stringPickerView.selectIndexs = @[@0, @0];//第二列的index数据
            stringPickerView.showColumnNum = 2;
            stringPickerView.multiResultBlock = ^(NSArray<BRTextModel *> *resultModelArr, NSArray<NSNumber *> *indexs) {
                if (resultModelArr.count > 1) {
                    BRTextModel *model = resultModelArr[1];
                    selectAction(model.code, model.text);
                } else {
                    BRTextModel *model = resultModelArr[0];
                    selectAction(model.code, model.text);
                }
            };
            stringPickerView.pickerStyle = [self pickerStyle];
            [stringPickerView show];
        }
            break;
        case kMoreSelectViewTime:
        {
            BRTextPickerView *stringPickerView = [[BRTextPickerView alloc]init];
            stringPickerView.pickerMode = BRTextPickerComponentCascade;
            stringPickerView.title = @"时间";
            stringPickerView.dataSourceArr = [self getTimeData];
            stringPickerView.selectIndexs = @[@0, @0];//第二列的index数据
            stringPickerView.showColumnNum = 2;
            stringPickerView.multiResultBlock = ^(NSArray<BRTextModel *> *resultModelArr, NSArray<NSNumber *> *indexs) {
                if (resultModelArr.count > 1) {
                    BRTextModel *model = resultModelArr[1];
                    selectAction(model.parentCode, model.code);
                } else {
                    BRTextModel *model = resultModelArr[0];
                    selectAction(model.code, model.text);
                }
            };
            stringPickerView.pickerStyle = [self pickerStyle];
            [stringPickerView show];
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - UI
- (BRPickerStyle *)pickerStyle {
    // 设置选择器中间选中行的样式
    BRPickerStyle *customStyle = [[BRPickerStyle alloc]init];
    customStyle.hiddenShadowLine = YES;
    customStyle.paddingBottom = TAB_BAR_MAGIN20 + SCALES(12) + SCALES(20) + SCALES(50);
    customStyle.rowHeight = SCALES(40);
    customStyle.separatorColor = UIColor.clearColor;
    customStyle.selectRowColor = UIColorRGB(0xF5F5F5);
    customStyle.topCornerRadius = SCALES(10);
    //标题
    customStyle.titleLabelFrame = CGRectMake(SCALES(100), SCALES(2), SCREEN_WIDTH - SCALES(200), SCALES(50));
    customStyle.titleBarHeight = SCALES(52);
    customStyle.titleTextColor = TITLE_COLOR;
    customStyle.titleTextFont = TEXT_MEDIUM(18);
    customStyle.hiddenTitleLine = YES;
    CGFloat btnWidth = SCREEN_WIDTH / 2 - SCALES(25) - SCALES(8);
    //取消
    customStyle.cancelTextColor = TEXT_SIMPLE_COLOR;
    customStyle.cancelColor = UIColorRGB(0xF5F5F5);
    customStyle.cancelBorderStyle = BRBorderStyleFill;
    customStyle.cancelTextFont = TEXT_FONT_18;
    customStyle.cancelCornerRadius = SCALES(25);
    customStyle.cancelBtnFrame = CGRectMake(SCALES(25), SCALES(270), btnWidth, SCALES(50));
    //完成
    customStyle.doneBtnTitle = @"确认";
    customStyle.doneColor = GRDUAL_CHANGE_BG_COLOR(btnWidth, SCALES(50));
    customStyle.doneTextColor = UIColor.whiteColor;
    customStyle.doneTextFont = TEXT_FONT_18;
    customStyle.doneBorderStyle = BRBorderStyleFill;
    customStyle.doneCornerRadius = SCALES(25);
    customStyle.doneBtnFrame = CGRectMake(SCREEN_WIDTH - SCALES(25) - btnWidth, SCALES(270), btnWidth, SCALES(50));
    return customStyle;
}

#pragma mark - 数据处理
//省份城市数据
- (NSArray <BRTextModel *>*)getProvinceCitys:(NSArray *)list {
    NSMutableArray *modelList = [[NSMutableArray alloc]init];
    for (ASProvinceCitysListModel *provincesModel in list) {
        BRTextModel *model = [[BRTextModel alloc]init];
        model.parentCode = @"-1";
        model.code = ([provincesModel.ID isEqualToString:@"-1"] ? @"0" : provincesModel.ID);
        model.text = provincesModel.name;
        [modelList addObject:model];
        NSMutableArray *childrenList = [[NSMutableArray alloc]init];
        for (ASProvinceCitysListModel *citysModel in provincesModel.child) {
            BRTextModel *model1 = [[BRTextModel alloc]init];
            model1.parentCode = ([citysModel.parent_id isEqualToString:@"-1"] ? @"0" : citysModel.parent_id);
            model1.code = citysModel.ID;
            model1.text = citysModel.name;
            [childrenList addObject:model1];
        }
        model.children = childrenList;
    }
    return [modelList copy];
}

//职业数据
- (NSArray <BRTextModel *>*)getOccupations:(NSArray *)list {
    NSMutableArray *modelList = [[NSMutableArray alloc]init];
    for (ASOccupationListModel *oneModel in list) {
        BRTextModel *model = [[BRTextModel alloc]init];
        model.parentCode = @"-1";
        model.code = oneModel.key;
        model.text = oneModel.key;
        [modelList addObject:model];
        NSMutableArray *childrenList = [[NSMutableArray alloc]init];
        for (NSString *data in oneModel.val) {
            BRTextModel *model1 = [[BRTextModel alloc]init];
            model1.parentCode = oneModel.key;
            model1.code = data;
            model1.text = data;
            [childrenList addObject:model1];
        }
        model.children = childrenList;
    }
    return [modelList copy];
}

//处理选择月份数据源
- (NSArray <BRTextModel *>*)getTimeData {
    //处理数据源
    NSString * time = [ASCommonFunc getTimeWithFormat: @"YYYY-MM"];
    NSArray *times = [time componentsSeparatedByString:@"-"];
    NSMutableArray *dictArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 5; i++) {//近五年数据
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        NSString* year = times[0];
        dict[@"year"] = [NSString stringWithFormat:@"%d年",year.intValue - i];
        dict[@"yearID"] = [NSString stringWithFormat:@"%d",year.intValue - i];
        NSMutableArray * monthList = [NSMutableArray array];
        if (i == 0) {
            NSString* month = times[1];
            for (int n = 0; n < month.intValue; n++) {
                [monthList addObject:@{@"yearID": [NSString stringWithFormat:@"%d",year.intValue - i], @"month": [NSString stringWithFormat:@"%d月",month.intValue-n], @"monthID": [NSString stringWithFormat:@"%d",month.intValue-n]}];
            }
        } else {
            for (int n = 0; n < 12; n++) {
                [monthList addObject:@{@"yearID": [NSString stringWithFormat:@"%d",year.intValue - i], @"month": [NSString stringWithFormat:@"%d月",12-n], @"monthID": [NSString stringWithFormat:@"%d",12-n]}];
            }
        }
        dict[@"month"] = monthList;
        [dictArray addObject:dict];
    }
    
    NSMutableArray *listModelArr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in dictArray) {
        BRTextModel *model = [[BRTextModel alloc]init];
        model.code = dic[@"yearID"];
        model.text = dic[@"year"];
        [listModelArr addObject:model];
        NSMutableArray *childrenList = [[NSMutableArray alloc]init];
        for (NSDictionary *param in dic[@"month"]) {
            BRTextModel *model1 = [[BRTextModel alloc]init];
            model1.parentCode = param[@"yearID"];
            model1.code = param[@"monthID"];
            model1.text = param[@"month"];
            [childrenList addObject:model1];
        }
        model.children = childrenList;
    }
    return [listModelArr copy];;
}

//收费设置数据处理
- (NSArray<BRTextModel *>*)getCollectFeeSets:(NSArray *)list {
    NSMutableArray *modelList = [[NSMutableArray alloc]init];
    for (ASCollectFeeSelectModel *oneModel in list) {
        BRTextModel *model = [[BRTextModel alloc]init];
        model.code = oneModel.ID;
        model.text = [NSString stringWithFormat:@"%zd%@",oneModel.coins, oneModel.content];
        model.extras = oneModel;//扩展字段
        [modelList addObject:model];
    }
    return [modelList copy];
}
@end
