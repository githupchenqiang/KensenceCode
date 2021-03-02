//
//  DataHelp.h
//  N-mix
//
//  Created by chenq@kensence.com on 16/4/21.
//  Copyright © 2016年 times. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "GCDAsyncSocket.h"


@interface DataHelp : NSObject<GCDAsyncSocketDelegate>

enum{
   
    SocketOffLineByUser,//用户手动断开
    SocketOffLineByServer,//服务器掉线
};

//@property (nonatomic ,strong)NSMutableArray *SenceCountView; //自定义场景View的个数
@property (nonatomic ,assign)BOOL CustomeIsBool; //判断是否进行了自定义事件
@property (nonatomic ,strong)GCDAsyncSocket *ClientSocket;
@property (nonatomic ,strong)NSMutableData *mutData; //接受的数据
@property (nonatomic ,strong)NSArray *AllDataArray; //说有数据的Array
@property(nonatomic,strong)NSString *LogSuccess; //登陆成功
@property (nonatomic ,strong)NSString *function; //事件
@property (nonatomic ,strong)NSMutableArray *TAllArray;

@property (nonatomic ,strong)NSMutableArray *LocationArray; //位置数组
@property (nonatomic ,strong)NSMutableArray *medialinksArray; //连接数组
@property (nonatomic ,strong)NSMutableArray *userMessage; //用户信息
@property (nonatomic ,strong)NSMutableArray *usersGroupArray; //用户群组信息
@property (nonatomic ,strong)NSDictionary *allDataDict;
@property (nonatomic ,strong)NSMutableArray  *RNamearray;

@property (nonatomic ,strong)NSMutableArray *srcdevidArray;
@property (nonatomic ,strong)NSMutableArray *srcchanidArray;
@property (nonatomic ,strong)NSMutableArray *destdevidArray;
@property (nonatomic ,strong)NSMutableArray *destchanidArray;
@property (nonatomic , strong)NSMutableArray *TIPArray;
@property(nonatomic,strong)NSMutableArray *RIPArray;
@property (nonatomic ,strong)NSMutableArray *MutTXArray;
@property (nonatomic ,strong)NSString *RnameData;//R的名字
@property (nonatomic ,strong)NSString *destdevid;
@property (nonatomic ,strong)NSString *destchanid;
@property (nonatomic ,assign)BOOL CreatRView; //标记是否为创建查询
@property (nonatomic ,strong)NSMutableData *LinkData;
@property(nonatomic,strong)NSMutableData *DeletData;
@property (nonatomic ,strong)NSArray *DeviceArray;

@property (nonatomic ,strong)NSMutableArray *MeetingRnameArray; //会场里的R名字
@property (nonatomic ,strong)NSMutableArray *MeetingDestdevid;
@property (nonatomic ,strong)NSMutableArray *MeetingDestchanid;

@property (nonatomic ,strong)NSMutableArray *channelsArray;
@property (nonatomic ,strong)NSMutableArray *Rchannel;
@property (nonatomic ,assign)BOOL isMeeting;

@property(nonatomic,strong)NSMutableDictionary *NetTIP; //T的IP地址
@property(nonatomic,strong)NSMutableDictionary *NetRIP; //R的IP地址

@property(nonatomic,strong)NSMutableArray *SelectArray;
@property (nonatomic ,strong)NSString *MeetingIndex;
@property (nonatomic ,strong)NSString *MeetingName; //会场名称
@property (nonatomic ,assign)NSInteger TCamerIndex; //选择设置T
@property (nonatomic ,assign)NSInteger RCamerIndx; //选择设置R
@property (nonatomic ,assign)NSInteger Tcamer;
@property (nonatomic ,assign)NSInteger isLeft;
@property (nonatomic ,assign)BOOL IsRDecoder;//是否有解码器
@property (nonatomic ,strong)NSString *camerIndexName; //选择解码器名称
@property (nonatomic ,strong)NSMutableArray *SenceDistureArray;
@property (nonatomic ,strong)NSString *ipString;//呼叫ip地址
@property (nonatomic ,assign)NSInteger TapTagNumber;
@property (nonatomic ,assign)BOOL isTdecore;
@property (nonatomic ,strong)NSString *IPtext;
@property (nonatomic ,assign)NSString *PortText;
@property (nonatomic ,assign)BOOL isViedeo;
@property (nonatomic ,assign)BOOL isfast; //快速连接页面加载
@property (nonatomic ,assign)BOOL isConnect; //连接状态
@property (nonatomic ,assign)NSInteger MeetingNumber; //会场位数





//@property (nonatomic ,assign)NSIntege
+(DataHelp *)shareData;

+(void)CreatTable;

//+(void)InsertIntoTemp:(NSString *)temp Value:(NSString *)VAlueString;
//
//+(NSArray *)SelectTemp:(NSString *)temp Value:(NSString *)ValueString;
//
//+(void)DeleteWithTemp:(NSString *)temp Value:(NSString *)ValueString;
//

//连接tcp
- (void)CreatTcpSocketWithIP:(NSString *)Host port:(uint16_t)Port;
- (DataHelp *)RowWithIndex:(NSInteger)index;
- (void)cutConnect;


- (void)StartTimer;
//- (void)HeartJump:(NSInteger)timer;

@end
