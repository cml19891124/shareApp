//
//  HPHowToPlayShareSpaceController.m
//  HPShareApp
//
//  Created by HP on 2018/11/26.
//  Copyright © 2018 Shenzhen Qianhai Hepai technology co.,ltd. All rights reserved.
//

#import "HPHowToPlayShareSpaceController.h"
#import "HPIdeaExampleItem.h"
#import "HPPageView.h"
#import "iCarousel.h"
#import "HPShareIdeaModel.h"

@interface HPHowToPlayShareSpaceController () <HPPageViewDelegate>

@property (nonatomic, weak) HPPageView *pageView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation HPHowToPlayShareSpaceController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    
    _dataArray = [NSMutableArray array];
    
    HPShareIdeaModel *model_1 = [HPShareIdeaModel new];
    [model_1 setTitle:@"健身房与轻食店"];
    [model_1 setType:@"铺位共享"];
    [model_1 setDesc:@"健身房优化设备布局，将闲置空间进行共享。通过系统匹配、推荐，选择最符合双方需求的轻食店进行合作，将闲置空间租给轻食店。"];
    [model_1 setPhotos:@[[UIImage imageNamed:@"idea_gym_pic1"], [UIImage imageNamed:@"idea_gym_pic2"], [UIImage imageNamed:@"idea_gym_pic3"]]];
    [model_1 setFirstPlace:@"健身房"];
    [model_1 setSecondPlace:@"轻食店"];
    [model_1 setTheory:@"健身房在选择共享合作店铺的时候，采用了产品或服务匹配的原理。将轻食店的简餐、减脂套餐作为健身运动的互补产品进行合作，通过运动与饮食相结合的方式，完善了自身健身服务，增加用户的粘性与忠诚度。\n\n\n轻食店在选择共享时，采用了人群、客流匹配的原理。轻食店的产品主要以素食、减肥餐、健身餐等食品为主。客户群体也多为健身或者是减肥等对饮食摄入要求较高的用户。这类客户群体与健身房的用户群体完全吻合。轻食店可以共享健身房的客群流量，来给店铺增加稳定的客流。"];
    [model_1 setBeforeFirstDesc:@"健身房的经营面积一般都较大，需要放置很多的健身设备，这就导致了会有许多的空间是闲置的，没有有效的利用起来。健身房的客户群体多以高收入人群为主，他们追求健康生活方式。注重运动，饮食。大量的运动过后，需要健康的饮食和营养品来进行补充。"];
    [model_1 setBeforeSecondDesc:@"轻食店也属于普通餐馆的一种，需要在人流较大的地区开设店铺，导致店铺租金成本较高。但轻食店的目标群体并不是所有客户，而是部分以追求健康生活方式的人群为主。会提供一些低热量、低卡路里的减肥餐或者健身餐。所以客户较少。"];
    [model_1 setAfterFirstDesc:@"健身房优化布局后，将闲置空间出租，换取收益，降低了店铺租金成本。轻食店的入驻，完善了健身房的整个生态链条，为健身房增加部分流量，增加了用户粘性。"];
    [model_1 setAfterSecondDesc:@"轻食店入驻健身房后，减少了店铺租金的压力。健身房给轻食店带来了大量稳定的客流，客户匹配程度非常高，增加了销售，带来收益。"];
    
    HPShareIdeaModel *model_2 = [HPShareIdeaModel new];
    [model_2 setTitle:@"便利店与快餐店"];
    [model_2 setType:@"铺位共享"];
    [model_2 setDesc:@"便利店增大商圈人群属性需求，将闲置空间进行共享。通过系统匹配、推荐，选择最符合双方需求的快餐店进行合作，将闲置空间分时段租赁给快餐店。"];
    [model_2 setPhotos:@[[UIImage imageNamed:@"idea_store_pic1"], [UIImage imageNamed:@"idea_store_pic2"], [UIImage imageNamed:@"idea_store_pic3"]]];
    [model_2 setFirstPlace:@"便利店"];
    [model_2 setSecondPlace:@"快餐店"];
    [model_2 setTheory:@"便利店在选择共享合作店铺的时候，采用产品或服务匹配的原理。将便利店所在的商圈人群属性，以及自身服务进行整体提升。将快餐店的即时餐饮服务进行合作互补，通过结合辅助消费提高收益，增加人流提高自身竞争力。\n\n\n快餐店在选择共享时，采用了人群、客流匹配的原理。通过将自身产品的服务接入符合自己的用户群体的便利店中，共享了便利店的人流，帮助自己提升收益，同时也增加用户的粘度。"];
    [model_2 setBeforeFirstDesc:@"便利店的核心优势就在于“灵活和快速”，常开设于“社区、写字楼、学校”等高租金的位置。在运营的过程中，往往没利用好空间对应添加周边人群消费需求，会错过很多获利机会。例如：开设在学校、写字楼便利店，如添加即食品早餐，面条等，将会大大的提高周边人群进行消费，并辅助便利店进行引流增加收益。"];
    [model_2 setBeforeSecondDesc:@"快餐店作为普通的餐馆进行运营，单独租赁人流较高的店铺需要投入大量的租金，难以获得高收益。如让快餐店分时段分配在各个符合自己人群的多个便利店作为运营点，将会大大的减少自己的租金，增大自己的收益。"];
    [model_2 setAfterFirstDesc:@"便利店优化布局后，将闲置空间出租，换取收益，降低了店铺租金成本。快餐店的入驻，完善了周边人群属性的需求，为便利店带来更多的流量，提高自己的竞争力。"];
    [model_2 setAfterSecondDesc:@"快餐店入驻便利店后，减少了店铺租金的压力。便利店给快餐店带来了稳定的客流，消费人群匹配程度非常高，增加销售，带来收益。"];
    
    HPShareIdeaModel *model_3 = [HPShareIdeaModel new];
    [model_3 setTitle:@"水果店与果汁饮品店"];
    [model_3 setType:@"铺位共享"];
    [model_3 setDesc:@"水果店为了减少租金压力，通过共享空间，将店铺的一块闲置区域进行共享，通过系统筛选、匹配推荐，最终选择果汁饮品店进行共享合作。"];
    [model_3 setPhotos:@[[UIImage imageNamed:@"idea_fruit_pic1"], [UIImage imageNamed:@"idea_fruit_pic2"], [UIImage imageNamed:@"idea_fruit_pic3"]]];
    [model_3 setFirstPlace:@"水果店"];
    [model_3 setSecondPlace:@"果汁饮品店"];
    [model_3 setTheory:@"水果店在选择共享合作店铺的时候，采用了产品、服务相匹配的原则，在客流相近的情况下，通过新增产品品类的方法，增加店铺的竞争力，还降低了产品的耗损率，增加营业利润。\n\n\n果汁店在选择共享合作店铺的时候，也采用了产品、服务相匹配的原则，在降低店铺成本的同时，解决了原料采购的问题，不仅降低采购的数量，还增加了原料品类。通过共享客流的方式，增加客户的到店率和停留时间。"];
    [model_3 setBeforeFirstDesc:@"水果店，水果作为一种快消品，对人流的需求非常的大。一般的水果店都会开设在商业街，医院，菜市场等客流大的地方。像这种客流旺的商业中心地段，店铺的租金价格就会较其他地方稍微高一点，所以开店的成本会较高，店铺租金就占了相当大的一部分。水果在运输、搬运的途中会有部分的损耗，或者是品相较差的水果卖不出去，这些也都会影响水果店的收益。"];
    [model_3 setBeforeSecondDesc:@"果汁饮品也属于快消品，需要开设在人流较大的区域，所以店铺租金较高，开店成本增加。果汁店对水果的需求非常的大，由于水果种类众多，客户的喜好不易拿捏，所以水果的采购也存在很多问题，进货多了会增加耗损率，进少了又满足不了一部分客户的需求，导致客户流失。不容易找到平衡的点。这些都是影响店铺经营的问题。"];
    [model_3 setAfterFirstDesc:@"水果店将店铺结构优化，将闲置空间共享，换取收益减轻了店铺租金压力。与果汁饮品店合作后，共享客流，增加了到店人数，增加潜在销售机会。通过低价的方式向果汁店提供销售不完或者品相较差的水果，从而减低耗损率。带来更多的收益。"];
    [model_3 setAfterSecondDesc:@"果汁店入驻水果店后，降低了店铺租金的压力。与水果店共享客流，增加了顾客的到店率和停留时间，增加销售机会。对于水果的采购也可以进行优化整合，与水果店合作，水果店拥有大量的水果种类。只需要采购销量大的几种水果，个别客户的需求可以通过与水果店的合作来弥补。降低成本的同时，带来了更好的用户体验，增加用户粘性。"];
    
    HPShareIdeaModel *model_4 = [HPShareIdeaModel new];
    [model_4 setTitle:@"洗车店与茶庄"];
    [model_4 setType:@"铺位共享"];
    [model_4 setDesc:@"洗车店为了增加营收，进行优化。将休息室作为共享空间划分出来，寻找合作伙伴。通过系统推荐、匹配，从众多的合作商家中选择了一家茶庄。与茶庄达成合作协议，将闲置空间，低价出租给茶庄。"];
    [model_4 setPhotos:@[[UIImage imageNamed:@"idea_car_pic1"], [UIImage imageNamed:@"idea_car_pic2"], [UIImage imageNamed:@"idea_car_pic3"]]];
    [model_4 setFirstPlace:@"洗车店"];
    [model_4 setSecondPlace:@"茶庄"];
    [model_4 setTheory:@"洗车店在选择共享伙伴的时候，采用了产品、服务匹配的原理。洗车店内的茶水间，给等待的用户免费提供茶水服务，既需要人工成本，有需要物料成本。通过与茶庄共享合作，由茶庄给用户提供茶水服务。不经降低了成本，还提升了服务质量。"];
    [model_4 setBeforeFirstDesc:@"洗车店，一般的洗车店主要的经营内容以汽车清洗、美容为主。拥有较大的经营空间，店铺租金成本会很高。汽车清洗的过程较长，为了提升服务质量，增加用户粘性。在这期间，洗车店会有专门的休息室，有服务人员给车主提供茶水、点心、报刊等打发时间。这无形中又增加了洗车店的成本，包括人工、茶水、点心等花费。"];
    [model_4 setBeforeSecondDesc:@"茶庄，以出售茶叶、茶具为主。位置一般选择在人流量较大的商圈或者商业集群区域。所以店铺租金成本较高，行业竞争相对比较大。虽然客流大，但是客户的停留率较低，流量大的背后，只有一少部分是目标客户。所以成交率较低。"];
    [model_4 setAfterFirstDesc:@"洗车店提供共享空间后。首先通过出租闲置空间，增加了一部分收入，减少了租金成本的压力。其次茶庄为了进行销售，为车主提供免费的茶水及服务。成功将对车主的服务业务转嫁至茶庄，减少了这部分的成本。营收大大提升。"];
    [model_4 setAfterSecondDesc:@"茶庄租用共享空间后，首先茶庄降低了租金成本。其次洗车店的客户属性，多为私家车主，年龄中等偏大，消费能力较高，在汽车养护时有空闲停留的时间。与茶庄的用户画像匹配度较高，更容易促成交易达成，增加营收。"];
    
    [_dataArray addObject:model_1];
    [_dataArray addObject:model_2];
    [_dataArray addObject:model_3];
    [_dataArray addObject:model_4];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setupUI {
    [self.view setBackgroundColor:UIColor.whiteColor];
    
    UIImageView *bgView = [[UIImageView alloc] init];
    [bgView setImage:[UIImage imageNamed:@"idea_detail_bg"]];
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.and.and.width.equalTo(self.view);
    }];
    
    UIImageView *backIcon = [[UIImageView alloc] init];
    [backIcon setImage:[UIImage imageNamed:@"icon_back"]];
    [self.view addSubview:backIcon];
    [backIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(16.f * g_rateWidth);
        make.top.equalTo(self.view).with.offset(g_statusBarHeight + 9.f * g_rateWidth);
    }];
    
    UIButton *backBtn = [[UIButton alloc] init];
    [backBtn addTarget:self action:@selector(onClickBackBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(g_statusBarHeight);
        make.size.mas_equalTo(CGSizeMake(44.f, 44.f));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [titleLabel setTextColor:UIColor.whiteColor];
    [titleLabel setText:@"共享空间怎么玩?"];
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(backBtn);
    }];
    
    UIView *topicPanel = [[UIView alloc] init];
    [topicPanel.layer setCornerRadius:5.f];
    [topicPanel.layer setShadowColor:COLOR_GRAY_7A7878.CGColor];
    [topicPanel.layer setShadowOffset:CGSizeMake(0.f, 7.f)];
    [topicPanel.layer setShadowRadius:14.f];
    [topicPanel.layer setShadowOpacity:0.1f];
    [topicPanel setBackgroundColor:UIColor.whiteColor];
    [self.view addSubview:topicPanel];
    [topicPanel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).with.offset(-31.f * g_rateWidth);
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(336.f * g_rateWidth, 84.f * g_rateWidth));
    }];
    [self setupTopicPanel:topicPanel];
    
    UILabel *exampleTitleLabel = [[UILabel alloc] init];
    [exampleTitleLabel setFont:[UIFont fontWithName:FONT_BOLD size:18.f]];
    [exampleTitleLabel setTextColor:COLOR_BLACK_333333];
    [exampleTitleLabel setText:@"精选玩法"];
    [self.view addSubview:exampleTitleLabel];
    [exampleTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topicPanel.mas_bottom).with.offset(45.f * g_rateWidth);
        make.left.equalTo(topicPanel);
        make.height.mas_equalTo(exampleTitleLabel.font.pointSize);
    }];
    
    HPPageView *pageView = [[HPPageView alloc] init];
    [pageView setDelegate:self];
    [pageView setPageMarginLeft:getWidth(20.f)];
    [pageView setPageSpace:getWidth(20.f)];
    [pageView setPageWidth:getWidth(297.f)];
    [pageView setPageItemSize:CGSizeMake(getWidth(297.f), getWidth(296.f))];
    [self.view addSubview:pageView];
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(exampleTitleLabel.mas_bottom);
        make.left.and.width.equalTo(self.view);
        make.height.mas_equalTo(336.f * g_rateWidth);
    }];
    
    UIImageView *footerView = [[UIImageView alloc] init];
    [footerView setImage:[UIImage imageNamed:@"shenmeshi_hepai"]];
    [self.view addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(pageView.mas_bottom).with.offset(4.f * g_rateWidth);
        make.centerX.equalTo(self.view);
    }];
}

- (void)setupTopicPanel:(UIView *)view {
    UILabel *questionLabel = [[UILabel alloc] init];
    [questionLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
    [questionLabel setTextColor:COLOR_BLACK_4A4A4B];
    [questionLabel setText:@"概念太抽象？"];
    [view addSubview:questionLabel];
    [questionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).with.offset(18.f * g_rateWidth);
        make.top.equalTo(view).with.offset(13.f);
        make.height.mas_equalTo(questionLabel.font.pointSize);
    }];
    
    UILabel *answerLabel = [[UILabel alloc] init];
    [answerLabel setFont:[UIFont fontWithName:FONT_BOLD size:13.f]];
    [answerLabel setTextColor:COLOR_RED_FF4562];
    [answerLabel setText:@"莫慌 !!!"];
    [view addSubview:answerLabel];
    [answerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(questionLabel.mas_right).with.offset(5.f);
        make.centerY.equalTo(questionLabel);
        make.height.mas_equalTo(answerLabel.font.pointSize);
    }];
    
    UILabel *descLabel = [[UILabel alloc] init];
    [descLabel setFont:[UIFont fontWithName:FONT_MEDIUM size:13.f]];
    [descLabel setTextColor:COLOR_GRAY_999999];
    [descLabel setNumberOfLines:0];
    [descLabel setText:@"不怕你不会玩，就怕你玩不过来！我们一起“享”未来！"];
    [view addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(questionLabel.mas_bottom).with.offset(11.f * g_rateWidth);
        make.left.equalTo(questionLabel);
        make.width.mas_equalTo(181.f);
    }];
}

#pragma mark - HPPageViewDelegate

- (UIView *)pageView:(HPPageView *)pageView viewAtPageIndex:(NSInteger)index {
    HPShareIdeaModel *model = _dataArray[index];
    
    HPIdeaExampleItem *item = [[HPIdeaExampleItem alloc] init];
    [item setTitle:model.title];
    [item setType:model.type];
    [item setDesc:model.desc];
    [item loadPhotoWithImages:model.photos];
    
    return item;
}

- (NSInteger)pageNumberOfPageView:(HPPageView *)pageView {
    return _dataArray.count;
}

- (void)pageView:(HPPageView *)pageView didClickPageItem:(UIView *)item atIndex:(NSInteger)index {
    HPShareIdeaModel *model = _dataArray[index];
    [self pushVCByClassName:@"HPHowToPlayDetailController" withParam:@{@"model":model}];
}

#pragma mark - onClick

- (void)onClickBackBtn:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
