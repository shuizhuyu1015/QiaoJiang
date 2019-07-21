//
//  interface.h
//  QiaoJiang
//
//  Created by mac on 16/3/16.
//  Copyright (c) 2016年 GL. All rights reserved.
//

#ifndef QiaoJiang_interface_h
#define QiaoJiang_interface_h


/*! =============================================================
 @brief 首页接口
 */

//首页图片广告
#define HOME_RECOMMEND @"https://api.thebeastshop.com/app/index/getNewIndex"
//article类型的广告详情
#define GET_ARTICLE_DETAIL @"https://api.thebeastshop.com/app/article/%@"
//通过商品id数组获取商品列表
#define GET_PRODUCTS_BY_IDS @"https://api.thebeastshop.com/app/product/simple"
//折扣广告获取详情
#define GET_DISCOUNT_PRODUCT @"https://api.thebeastshop.com/app/search/product?limit=20&offset=%d&param=discount&sortField=SYNTHESIS&sortOrder=DESC"
//shop-story广告详情
#define GET_SHOP_STORY @"https://api.thebeastshop.com/app/store/getOperation.json?shopId=%@"
//list广告详情
#define GET_PRODUCT_LIST @"https://api.thebeastshop.com/app/search/product?limit=20&listId=%@&offset=%d&sortField=SYNTHESIS&sortOrder=DESC"
//product类型广告
#define GET_PRODUCT_BY_ID @"https://api.thebeastshop.com/app/product/%@"
//product推荐理由等介绍
#define GET_PRODUCT_DETAILS_BY_ID @"https://api.thebeastshop.com/app/product/%@/details?legacy=0"


/** ==========================================================
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

//图片加载接口
#define kImage @"http://images.wusejia.com/image%@750x0.jpg"
#define kImgBanner @"http://images.wusejia.com/image%@0x0.jpg"

#endif
