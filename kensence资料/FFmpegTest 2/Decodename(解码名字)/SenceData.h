//
//  SenceData.h
//  N-mix
//
//  Created by chenq@kensence.com on 16/6/1.
//  Copyright © 2016年 times. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SenceData : NSObject
//PicTag,Viewtag,SenceNumber,SenceR,TLinkTag,ViewRect,RName,DesVid,Desch

//@property (nonatomic ,strong)NSMutableArray *PicTagmutArray;
@property (nonatomic ,strong)NSMutableArray *ViewTag;
@property (nonatomic ,strong)NSMutableArray *SenceNumberArray;
@property (nonatomic ,strong)NSMutableArray *SenceRArray;
@property (nonatomic ,strong)NSMutableArray *TLinkTagArray;
@property (nonatomic ,strong)NSMutableArray *ViewaRectArray;
@property (nonatomic ,strong)NSMutableArray *RnameArray;
@property (nonatomic ,strong)NSMutableArray *DesvidArray;
@property (nonatomic ,strong)NSMutableArray *DeschArray;
@property (nonatomic ,strong)NSMutableArray *MeetingNumber;





//场景保存的数据库
+(void)CreatSenceTable;
//图片位置   滑动的图片tag  样式 分屏样式 连接  连接位置 R的名称
+(void)InsertIntoUserName:(NSString *)NameOfUser ViewTag:(NSInteger)PicTag Meeting:(NSString *)Meeting TViewtage:(NSInteger)Viewtag Temp:(NSInteger)SenceNumber SenceR:(NSInteger)senceR Ttag:(NSInteger)TLinkTag Rect:(NSString *)ViewRect RName:(NSString *)Name DesVid:(NSString *)desvid Desch:(NSString *)desch; //ImageData:(NSData *)imageData senceType:( NSMutableDictionary *)senceType;
+(NSArray *)UserName:(NSString *)NameOfUser SelectViewTag:(NSInteger)PicTag;
+(void)UserName:(NSString *)NameOfUser  DeleteViewTag:(int)PicTag;
+(void)UserName:(NSString *)NameOfUser DeleteViewTag:(NSInteger)PicTag  Meeting:(NSString *)Meeting Ttage:(NSInteger)tag Temp:(NSInteger)SenceNumber SenceR:(NSInteger)senceR;
@end
