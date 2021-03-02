//
//  DataHelp.m
//  N-mix
//
//  Created by chenq@kensence.com on 16/4/21.
//  Copyright © 2016年 times. All rights reserved.
//

#import "DataHelp.h"
#import "BaseViewController.h"
#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "TViewModel.h"
#import "BaseViewController.h"
#import "LoginViewController.h"
#import "MBProgressHUD+MJ.h"
#import "NSObject+SBJSON.h"
#import "SeleDataManager.h"
#define  LogMessage(level,...)  NSLog(__VA_ARGS__)
#define UserNameString [[NSUserDefaults standardUserDefaults]objectForKey:@"Username"]



@interface DataHelp ()

@property (nonatomic ,strong)NSMutableArray *mutArray; //临时数组


@property (nonatomic ,strong)NSMutableArray *mutLoactions; //位置
@property (nonatomic ,strong)NSMutableArray *mutMedialink; //连接
@property (nonatomic ,strong)NSMutableArray *MutusersGroup;//所有用户
@property (nonatomic ,strong)NSMutableArray *mutUserdict; //用户信息


@property (nonatomic ,strong)MBProgressHUD *mbp;
@property (nonatomic ,assign)BOOL IsCus;

@property (nonatomic ,assign)NSTimer *timer;
@property (nonatomic ,assign)NSInteger heartTimeInterval;
@end


@implementation DataHelp

static sqlite3 *db1;

+ (DataHelp *)shareData
{
    static DataHelp * help = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        help = [DataHelp new];
    });
    
    return help;
    
}

-(void)dealloc
{
    [_ClientSocket disconnect];
    _ClientSocket = nil;
    [self.timer invalidate];
}



//- (NSMutableArray *)SenceCountView
//{
//    if (_SenceCountView == nil) {
//        
//        _SenceCountView = [NSMutableArray array];
//        
//    }
//    return _SenceCountView;
//
//}
+(void)CreatTable
{
    //打开数据库
    //取到沙盒
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"Name"];
    const char *CfileName = fileName.UTF8String;
    
    int result = sqlite3_open(CfileName, &db1);
    if (result == SQLITE_OK) {
        LogMessage(1,@"打开数据库成功");
        //创建表
        const char *sql = "CREATE TABLE IF NOT EXISTS t_name (id integer PRIMARY KEY AUTOINCREMENT,Sence text NOT NULL , type integer NOT NULL , key text NOT NULL , svalue text NOT NULL);";
        char *erroMsg = NULL;
        sqlite3_exec(db1, sql, NULL, NULL, &erroMsg);
        if (result == SQLITE_OK) {
             LogMessage(1,@"创表成功");
        }else
        {
           LogMessage(1,@"创表失败");
        }
    }else
    {
         LogMessage(1,@"打开数据库失败");
    }
  
}

+(void)InsertIntoTemp:(NSString *)temp Type:(NSString *)type Key:(NSString *)key Values:(NSString *)values
{
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_name (stemp,type,key,svalue) VALUES (%@,%@,'%@','%@');",temp,type,key,values];
    char *erroMsg = NULL;
    sqlite3_exec(db1, sql.UTF8String, NULL, NULL, &erroMsg);
    if (erroMsg) {
        LogMessage(1,@"插入成功");
    }else
    {
        LogMessage(1,@"插入成功");
        
    }
    
}


+(NSArray *)SelectTemp:(NSString *)temp Type:(NSString *)type
{
    
    NSMutableArray *mutArra = nil;
    
    NSString *sql = [NSString stringWithFormat:@"SELECT stemp,type,key,svalue FROM t_name WHERE stemp = %@ and type = %@;",temp,type];
    //sqlite3_stmt 用来取数据
    sqlite3_stmt *stmt = NULL;
    
    if ( sqlite3_prepare_v2(db1, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
//        NSLog(@"查询语句没问题");
        mutArra = [NSMutableArray array];
        //每一次sqlite3_step函数，就会取出下一条数据
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            sqlite3_column_int(stmt, 1);
            int temp = sqlite3_column_int(stmt, 0);
            int type = sqlite3_column_int(stmt, 1);
            const unsigned char *key = sqlite3_column_text(stmt, 2);
            const unsigned char *svalue = sqlite3_column_text(stmt, 3);
            
            NSString *string = [NSString stringWithUTF8String:(const char *)key];
            NSString *obj = [NSString stringWithUTF8String:(const char *)svalue];
            
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:string];
            [[NSUserDefaults standardUserDefaults]setObject:obj forKey:string];
        }
    }else
    {
//         LogMessage(1,@"查询有问题");
    }
    
    return mutArra;
    
}

+(void)DeleteWithTemp:(NSString *)temp type:(NSString *)type Key:(NSString *)key
{
    
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_name WHERE stemp = %@ and type = %@ and key = '%@'",temp,type,key];
    
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(db1, sql.UTF8String, -1, &stmt, NULL) == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {
            if (sqlite3_step(stmt) == SQLITE_DONE) {
               LogMessage(1,@"删除成功");
            }
             LogMessage(1,@"删除失败");
            
        }
    }
}

/*
 *
 *保存场景的数据操作
 */

//创建连接
- (void)CreatTcpSocketWithIP:(NSString *)Host port:(uint16_t)Port
{
    

    [_ClientSocket disconnect];
    //创建一个队列，等待接收数据
    dispatch_queue_t Queue = dispatch_queue_create("client tcp socket", NULL);
    //创建一个tcp和服务端通讯
    _ClientSocket  = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:Queue socketQueue:nil];
    
    _mutData = [NSMutableData data];
    
    //连接服务器 60s连接不上出错服务器在线时
    [_ClientSocket connectToHost:Host onPort:Port withTimeout:5 error:nil];
//    [_ClientSocket readDataWithTimeout:-1 tag:500];
    
    _srcdevidArray = [NSMutableArray array];
    _srcchanidArray = [NSMutableArray array];
    
    _destchanidArray = [NSMutableArray array];
    _destdevidArray = [NSMutableArray array];
    
    _TIPArray = [NSMutableArray array];
    _RIPArray = [NSMutableArray array];
    
    _NetRIP = [NSMutableDictionary dictionary];
    _NetTIP = [NSMutableDictionary dictionary];

    _RNamearray = [NSMutableArray array];
    _channelsArray = [NSMutableArray array];
    _Rchannel = [NSMutableArray array];
    _mutData = [[NSMutableData alloc]init];
    _LinkData =[[NSMutableData alloc]init];
    _DeletData = [[NSMutableData alloc]init];
    _LocationArray = [NSMutableArray array];
    _DeviceArray = [NSMutableArray array];
    _MutTXArray = [NSMutableArray array];
    
}

- (void)socketDidCloseReadStream:(GCDAsyncSocket *)sock
{
    
}

#pragma mark ===代理方法

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    //连接成功
    LogMessage(1,@"连接成功");
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ConnectSu" object:nil userInfo:nil];
//    NSInteger heartPackTime = self.heartTimeInterval == 0 ? 20 : self.heartTimeInterval;
   
}

- (void)StartTimer
{
    NSInteger heartPackTime = self.heartTimeInterval == 0 ? 20 : self.heartTimeInterval;
    self.timer =[NSTimer scheduledTimerWithTimeInterval:heartPackTime target:self selector:@selector(longConnectToSocket:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer fire];
}

- (void)longConnectToSocket:(NSTimer *)timer
{
//    NSDictionary *dict = @{@"message":@{@"function":@"device_get_all"}};
//   NSData *data = [[NSString stringWithFormat:@"%@\n",[dict JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
//    [_ClientSocket writeData:data withTimeout:2 tag:600];
//    [_ClientSocket readDataWithTimeout:-1 tag:600];
//    
//    NSDictionary *Venue = @{@"message":@{@"function":@"location_get_all"}};
//    
//    NSData *Venuedata = [[NSString stringWithFormat:@"%@\n",[Venue JSONRepresentation]] dataUsingEncoding: NSUTF8StringEncoding];
//    [_ClientSocket writeData:Venuedata withTimeout:2 tag:500];
//    [_ClientSocket readDataWithTimeout:-1 tag:500];
}

//连接失败重连
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSString *host1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"HostKey"];
    NSString *port1 = [[NSUserDefaults standardUserDefaults]objectForKey:@"PortKey"];
//    NSLog(@"====%@",err);
    NSInteger integer = err.code;
    if (integer == 7) {
        self.IsCus =YES;
        _mutData = [[NSMutableData alloc]init];
            //注册掉线通知
            [[NSNotificationCenter defaultCenter]postNotificationName:@"LostUser" object:nil userInfo:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            mbp.mode = MBProgressHUDModeText;
            mbp.label.text = Localized(@"用户在别处登录");
            mbp.margin = 10.0f; //提示框的大小
            [mbp setOffset:CGPointMake(10, 300)];//提示框的位置
            mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
            [mbp hideAnimated:YES afterDelay:2]; //多久后隐藏
        });
    }else if (integer == 601)
    {
        NSLog(@"网络请求失败");
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            mbp.mode = MBProgressHUDModeText;
            mbp.label.text = Localized(@"网络连接出错");
            mbp.margin = 10.0f; //提示框的大小
            [mbp setOffset:CGPointMake(10, 300)];//提示框的位置
            mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
            [mbp hideAnimated:YES afterDelay:1.5]; //多久后隐藏
            //注册掉线通知
            [[NSNotificationCenter defaultCenter]postNotificationName:@"LostUser" object:nil userInfo:nil];
        });
        
    }else if (integer == 4)
    {
        //注册掉线通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"LostUser" object:nil userInfo:nil];

    }else if (integer == 5)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            mbp.mode = MBProgressHUDModeText;
            mbp.label.text = Localized(@"网络配置错误");
            mbp.margin = 10.0f; //提示框的大小
            [mbp setOffset:CGPointMake(10, 300)];//提示框的位置
//            mbp.dimBackground = NO;
            mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
            [mbp hideAnimated:YES afterDelay:1.5]; //多久后隐藏
            //注册掉线通知
            [[NSNotificationCenter defaultCenter]postNotificationName:@"LostUser" object:nil userInfo:nil];
        });
    }else if (integer == 51)
    {
        
        if (_ClientSocket.userData == SocketOffLineByUser) {
            unsigned short utfString = [port1 integerValue];
            [_ClientSocket connectToHost:host1 onPort:utfString withTimeout:-1 error:nil];
        }else
        {
            return;
            
        }
    }
 
  LogMessage(1,@"连接失败");
//    if (sock.userData == SocketOfflineByServer) {
//        //重新连接
//        unsigned short utfString = [port1 integerValue];
//
//        [[DataHelp shareData].ClientSocket connectToHost:host1 onPort:utfString withTimeout:-1 error:nil];
//        
//    }else
//    {
//        return;
//    }
}

- (void)cutConnect
{
    _ClientSocket.userData = SocketOffLineByUser;
    [self.timer invalidate];
}


- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"消息发送成功");
    
    if (tag == 500) {
          [_ClientSocket readDataWithTimeout:-1 tag:500];
    }else if (tag == 300)
    {
          [_ClientSocket readDataWithTimeout:-1 tag:300];
        
    }else if (tag == 400)
    {
        [_ClientSocket readDataWithTimeout:-1 tag:400];
    }
    
//    }else if (tag == 600)
//    {
//        [_ClientSocket readDataWithTimeout:-1 tag:600];
//        
//    }
}
/*
 *  tag :200 接受登录返回的消息
 *  tag :300 接受连接返回的消息
 *  Tag :400 接受删除返回的消息
 */

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
//    NSLog(@"%ld",tag);
    if (tag == 500) {
        NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"====%@",dataString);
        if (_mutData == nil) {
            _mutData = [[NSMutableData alloc]init];
        }else if (data != nil)
        {
            [_mutData appendData:data];
            NSRange rang = [dataString rangeOfString:@"\n"];
            if (rang.location != NSNotFound) {
                NSString *String = [[NSString alloc]initWithData:_mutData encoding:NSUTF8StringEncoding];
                NSData *data = [String dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *AlDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
               
                NSDictionary *deviceArray = [AlDict valueForKey:@"message"];
                NSArray *array = [deviceArray valueForKey:@"devices"];
                
                for (NSDictionary *device in array) {
                    if ([device[@"type"]isEqualToString:@"TX"]) {
                        _DeviceArray = [array mutableCopy];
                        [self.srcdevidArray addObject:[device valueForKey:@"id"]];
                        [self.MutTXArray addObject:[device valueForKey:@"name"]];
                        
                        [SeleDataManager CreatTable];
                        [SeleDataManager DeleteWithTemp:UserNameString Value:[device valueForKey:@"name"]];
                        [SeleDataManager InsertIntoTemp:UserNameString Value:[device valueForKey:@"name"]];
                        _channelsArray = [device valueForKey:@"channels"];
                        
                        for (NSDictionary *chanes in _channelsArray) {
                            [self.srcchanidArray addObject:chanes[@"id"]];
                        }
                        [_TIPArray addObject:[device valueForKey:@"net"][@"ip"]];
                        
                    }else if ([device[@"type"]isEqualToString:@"RX"])
                    {
                        [self.destchanidArray addObject:[device valueForKey:@"id"]];
                        [self.RNamearray addObject:[device valueForKey:@"name"]];
                        
                        
                        _Rchannel = [device valueForKey:@"channels"];
                        for (NSDictionary *dict in _Rchannel) {
                            [self.destdevidArray addObject:dict[@"id"]];
                        }
                    }
                }
//                _LocationArray = [NSMutableArray array];
                for (NSDictionary *locaDict in deviceArray[@"locations"]) {
                    [_LocationArray addObject:locaDict];
                }
                _medialinksArray = [NSMutableArray array];
                if ([[deviceArray valueForKey:@"status"] isEqualToString:@"Success"]&&[[deviceArray valueForKey:@"function"] isEqualToString:@"medialink_add"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                       
                        mbp.mode = MBProgressHUDModeText;
                        mbp.label.text = Localized(@"连接成功");
//                        [mbp customView];
                         mbp.bezelView.hidden = YES;
                        mbp.margin = 10.0f; //提示框的大小
                        [mbp setOffset:CGPointMake(10, 300)];//提示框的位置
//                       mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
                        [mbp hideAnimated:YES afterDelay:0.5]; //多久后隐藏
                    });
                }else if([deviceArray valueForKey:@"device"] == nil&& [[deviceArray valueForKey:@"function"] isEqualToString:@"medialink_add"])
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                        mbp.mode = MBProgressHUDModeText;
                        mbp.label.text =Localized( @"连接已存在");
//                        [mbp customView];
                        mbp.backgroundView.hidden = YES;
                        mbp.margin = 10.0f; //提示框的大小
                        
                        mbp.bezelView.hidden = YES;
                        [mbp setOffset:CGPointMake(10, 300)];//提示框的位置
                        mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
                        [mbp hideAnimated:YES afterDelay:0.5]; //多久后隐藏
                    });
                }
                _mutData = nil;
                _mutData = [[NSMutableData alloc]init];
                if ([[deviceArray valueForKey:@"status"] isEqualToString:@"Success"] && [[deviceArray valueForKey:@"function"] isEqualToString:@"user_login"]) {
                
                    dispatch_async(dispatch_get_main_queue(), ^{
                      [_mbp hideAnimated:YES];
                       _mbp.removeFromSuperViewOnHide = YES;
                    });
                    
                    [DataHelp shareData].MeetingDestchanid = [NSMutableArray array];
                    [DataHelp shareData].MeetingDestdevid = [NSMutableArray array];
                    [DataHelp shareData].MeetingRnameArray = [NSMutableArray array];
                    //创建通知
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"Log" object:nil];

                }
            }
             [_ClientSocket readDataWithTimeout:-1 tag:500];

        }
        
        
    }else if (tag == 300)
    {
         NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *AlDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSDictionary *deviceArray = [AlDict valueForKey:@"message"];
        if ([[deviceArray valueForKey:@"status"] isEqualToString:@"Success"]&&[[deviceArray valueForKey:@"function"] isEqualToString:@"medialink_add"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                mbp.mode = MBProgressHUDModeText;
                mbp.label.text = Localized(@"连接成功");
                [mbp customView];
                mbp.margin = 10.0f; //提示框的大小
                [mbp setOffset:CGPointMake(10, 300)];//提示框的位置
                //                       mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
                [mbp hideAnimated:YES afterDelay:1]; //多久后隐藏
            });
        }else if([deviceArray valueForKey:@"device"] == nil&& [[deviceArray valueForKey:@"function"] isEqualToString:@"medialink_add"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD *mbp = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                mbp.mode = MBProgressHUDModeText;
                mbp.label.text =Localized( @"连接已存在");
                [mbp customView];
                mbp.margin = 10.0f; //提示框的大小
                [mbp setOffset:CGPointMake(10, 300)];//提示框的位置
                mbp.removeFromSuperViewOnHide = YES; //隐藏之后删除view
                [mbp hideAnimated:YES afterDelay:1]; //多久后隐藏
            });
        }
        
        
    }else if (tag == 600)
    {
        NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        if (_mutData == nil) {
            _mutData = [[NSMutableData alloc]init];
        }else
        {
            [_mutData appendData:data];
            NSRange rang = [dataString rangeOfString:@"\n"];
            if (rang.location != NSNotFound) {
                NSString *String = [[NSString alloc]initWithData:_mutData encoding:NSUTF8StringEncoding];
                NSData *data = [String dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *AlDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                
                NSDictionary *deviceArray = [AlDict valueForKey:@"message"];
                NSArray *array = [deviceArray valueForKey:@"devices"];
                
                for (NSDictionary *device in array) {
                    if ([device[@"type"]isEqualToString:@"TX"]) {
                        _DeviceArray = [array mutableCopy];
                        [self.srcdevidArray addObject:[device valueForKey:@"id"]];
                        [self.MutTXArray addObject:[device valueForKey:@"name"]];
                        
//                        [SeleDataManager CreatTable];
//                        [SeleDataManager InsertIntoTemp:UserNameString Value:[device valueForKey:@"name"]];
//                        
                        _channelsArray = [device valueForKey:@"channels"];
                        
                        for (NSDictionary *chanes in _channelsArray) {
                            [self.srcchanidArray addObject:chanes[@"id"]];
                        }
                        
                
                    }else if ([device[@"type"]isEqualToString:@"RX"])
                    {
                        [self.destchanidArray addObject:[device valueForKey:@"id"]];
                        [self.RNamearray addObject:[device valueForKey:@"name"]];
                        
                        _Rchannel = [device valueForKey:@"channels"];
                       
                        for (NSDictionary *dict in _Rchannel) {
                            [self.destdevidArray addObject:dict[@"id"]];
                        }
                        
                    }
                }
                
//                for (NSDictionary *locaDict in deviceArray[@"locations"]) {
//                    [_LocationArray addObject:locaDict];
//                    
//                }
                _medialinksArray = [NSMutableArray array];
        BaseViewController *base = [BaseViewController new];
        [base.table reloadData];
        
    }
        }
    }
    
    
    
}



- (NSMutableArray *)SenceDistureArray
{
    if (_SenceDistureArray == nil) {
        _SenceDistureArray = [NSMutableArray array];
    }
    return _SenceDistureArray;
}


- (DataHelp *)RowWithIndex:(NSInteger)index
{
    return self.mutArray[index];
}

- (NSMutableArray *)mutArray
{
    if (_mutArray == nil) {
        _mutArray = [NSMutableArray array];
    }
    return _mutArray;
}


- (NSArray *)AllDataArray
{
    return [_mutArray mutableCopy];
}



- (NSMutableArray *)TAllArray
{
    return [_MutTXArray mutableCopy];
}



@end
