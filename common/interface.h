//
//  interface.h
//  QiaoJiang
//
//  Created by mac on 16/3/16.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#ifndef QiaoJiang_interface_h
#define QiaoJiang_interface_h

//图片加载接口
#define kImage @"http://images.wusejia.com/image%@750x0.jpg"
#define kImgBanner @"http://images.wusejia.com/image%@0x0.jpg"

/**
 商城精选页所有接口
 */

//商城主页
#define kShop @"http://api.wusejia.com/mobile/productSpecial/search"

//商城段头链接
#define kHeader @"http://api.wusejia.com/mobile/product/search?limit=30&offset=0&productSpecialId=%ld"

//商品详情页
//顶部
#define kProduct @"http://api.wusejia.com/mobile/product/%ld"
//下部cell
#define kProductRef @"http://api.wusejia.com/mobile/product/productRefProduct/%ld"

//分类搜索,可拼接limit,offset,以及种类参数
#define kSearch @"http://api.wusejia.com/mobile/product/search?limit=30&offset=%ld"


/**
 匠心页面所有接口
 */

//创意
#define kIdea @"http://m.yidoutang.com//apiv3/case/list?area=0&budget=0&currentUserId=&order=0&page=%ld&size=0&style=0"
//创意详情页
#define kDetail @"http://m.yidoutang.com//apiv3/case/detail?currentUserId=&device=ios&id=%@&page=1"

//推荐
#define kRecommend @"http://m.yidoutang.com//apiv3/community/guide?page=%ld"
//推荐详情页
#define kRecDetail @"http://m.yidoutang.com//apiv3/community/detailHtml?device=ios&page=1&tid=%@"

//搜索
#define kRecSearch @"http://m.yidoutang.com//apiv3/community/searchguide?page=%ld&q=%@"
#define kIdeaSearch @"http://m.yidoutang.com//apiv3/case/search?page=%ld&q=%@"

//用户信息
#define kUserInfo @"http://m.yidoutang.com/apiv3/user/info?userId=%@"
#define kIdeaUser @"http://m.yidoutang.com//apiv3/user/casesfull?page=%ld&type=2&userId=%@"
#define kRecomUser @"http://m.yidoutang.com//apiv3/community/userGuides?page=%ld&type=2&userId=%@"

#endif
