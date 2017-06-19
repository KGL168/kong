//
//  LDWashModel.h
//  Panachz
//
//  Created by sanlimikaifa on 2017/2/20.
//  Copyright © 2017年 Palapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDWashModel : NSObject
//"img_id": "96"
@property (nonatomic, strong) NSString *img_id;
//"sn": "WKS_LT_BK_0001"
@property (nonatomic, strong) NSString *sn;
//"category": "WKS",类别
@property (nonatomic, strong) NSString *category;
//"output_img": "olbh3832da83b400.png",输出图片
@property (nonatomic, strong) NSString *output_img;
@property (nonatomic, strong) NSURL *output_imgUrl;
//"display_img": "olbh38233046c893.png",展示图片
@property (nonatomic, strong) NSString *display_img;
@property (nonatomic, strong) NSURL *display_imgUrl;
//"real_img": "olbh3812c0611819.png",真实图片
@property (nonatomic, strong) NSString *real_img;
@property (nonatomic, strong) NSURL *real_imgUrl;
//"fb": "BK",前后
@property (nonatomic, strong) NSString *fb;
//"lr": "LT",
@property (nonatomic, strong) NSString *lr;
//"desc_en": "Description (English)",
@property (nonatomic, strong) NSString *desc_en;
//"desc_cn": "Description (Chinese)",
@property (nonatomic, strong) NSString *desc_cn;
//"create_by": "admin",
@property (nonatomic, strong) NSString *create_by;
//"create_date": "2017-02-13 22:18:44",
@property (nonatomic, strong) NSString *create_date;
//"update_by": "admin",
@property (nonatomic, strong) NSString *update_by;
//"update_date": "2017-02-13 22:18:44",
@property (nonatomic, strong) NSString *update_date;
//"vaild": "1",
@property (nonatomic, strong) NSString *vaild;
//"deleted": "0",
@property (nonatomic, strong) NSString *deleted;
//"image_path": "\/wash\/"
@property (nonatomic, strong) NSString *image_path;

- (NSURL *)fetchImageUrl:(NSString *)imgName;

@end
