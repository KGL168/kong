//
//  LDFabricModel.h
//  Panachz
//
//  Created by sanlimikaifa on 2017/2/23.
//  Copyright © 2017年 Palapple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LDFabricModel : NSObject
//"fabric_id": "1",
@property (nonatomic, strong) NSString *fabric_id;
//"sn": "WKS_LT_BK_0001"
@property (nonatomic, strong) NSString *sn;
//"type": "cotton",
@property (nonatomic, strong) NSString *type;
//"weight": "25",
@property (nonatomic, strong) NSString *weight;
//"content": " construction",
@property (nonatomic, strong) NSString *content;
//"display_img": "olbh38233046c893.png",
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSURL *imageUrl;
//"color ": "blue",
@property (nonatomic, strong) NSString *color;
//"width": "65",
@property (nonatomic, strong) NSString *width;
//"unit": "inch",
@property (nonatomic, strong) NSString *unit;
//"suggested_price": "1520",
@property (nonatomic, strong) NSString *suggested_price;
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
//"image_path": "\/fabric\/"
@property (nonatomic, strong) NSString *image_path;

@property (nonatomic, strong) NSString *weaving;

- (NSURL *)fetchImageUrl:(NSString *)imgName;

@end
