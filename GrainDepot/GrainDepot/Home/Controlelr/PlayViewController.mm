//
//  PlayViewController.m
//  GrainDepot
//
//  Created by shuaitong du on 2017/11/23.
//  Copyright © 2017年 EdisonDu. All rights reserved.
//

#define MAX_VIEW_NUM    10

#import "PlayViewController.h"
#import "hcnetsdk.h"
#import "HikDec.h"
#import "VoiceTalk.h"
#import "IOSPlayM4.h"
#import <Foundation/Foundation.h>
#include <stdio.h>
#include <ifaddrs.h>
#include <sys/socket.h>
#include <sys/poll.h>
#include <net/if.h>
#include <map>
#import "PlayModel.h"
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>


typedef struct tagHANDLE_STRUCT
{
    int iPreviewID;
    int iPlayPort;
    UIView *pView;
    tagHANDLE_STRUCT()
    {
        iPreviewID = -1;
        iPlayPort = -1;
        pView = NULL;
    }
}HANDLE_STRUCT,*LPHANDLE_STRUCT;

HANDLE_STRUCT g_struHandle[MAX_VIEW_NUM];


int g_iStartChan = 0;
PlayViewController *contoller = nil;

void g_fExceptionCallBack(DWORD dwType, LONG lUserID, LONG lHandle, void *pUser)
{
    NSLog(@"g_fExceptionCallBack Type[0x%x], UserID[%d], Handle[%d]", dwType, lUserID, lHandle);
}

@interface PlayViewController () {
    int m_nPreviewPort;
    int ipPort;

}
@property (nonatomic) int useId;
@property (nonatomic, strong) OC_NET_DVR_PREVIEWINFO *previewInfo;
@property (weak, nonatomic) IBOutlet UIView *playView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;
@property (nonatomic) BOOL isFullScreen;
@property (weak, nonatomic) IBOutlet UIView *controlView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minddleHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controlHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *controlBottom;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    contoller = self;
    
    [self realyPlay];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false];
}
- (IBAction)back:(UIButton *)sender {
    [self stop];
    [self logOut];
    PlayM4_Stop(ipPort);
    PlayM4_PlaySound(ipPort);
    NET_DVR_Cleanup();
    contoller = nil;
    g_iStartChan = 0;
    [self.navigationController popViewControllerAnimated:true];
}


- (OC_NET_DVR_PREVIEWINFO *)getPreviewInfo {
    if (!_previewInfo) {
        _previewInfo = [[OC_NET_DVR_PREVIEWINFO alloc] init];
    }
    return _previewInfo;
}
- (int)logInWithIp:(NSString *)ip prort:(UInt16)port userName:(NSString *)userName passWord:(NSString *)pass {
    BOOL bRet = NET_DVR_Init();
    if (!bRet)
    {
        NSLog(@"NET_DVR_Init failed");
    }
    NET_DVR_SetExceptionCallBack_V30(0, NULL, g_fExceptionCallBack, NULL);
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    const char* pDir = [documentPath UTF8String];
    NET_DVR_SetLogToFile(3, (char*)pDir, true);
    
    NET_DVR_DEVICEINFO_V30 logindeviceInfo = {0};
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    int m_lUserID = NET_DVR_Login_V30((char*)[ip UTF8String],
                                  port,
                                  (char*)[userName cStringUsingEncoding:enc],
                                  (char*)[pass UTF8String],
                                  &logindeviceInfo);
    self.useId = m_lUserID;
    g_iStartChan = logindeviceInfo.byStartDChan;
    return m_lUserID;
}
- (void)realyPlay {
    
    int lUserID = [self logInWithIp:@"218.13.18.18" prort:20030 userName:@"admin" passWord:@"admin123"];
    NSInteger num = self.num.integerValue;
    [self start:lUserID chan:g_iStartChan view:self.playView index:num-1];
    
}
- (int)start:(int)iUserID chan:(int)iStartChan view:(UIView *)pView index:(int)iIndex {
    
    NET_DVR_PREVIEWINFO struPreviewInfo = {0};
    struPreviewInfo.lChannel = iStartChan + iIndex;/// 通道
    struPreviewInfo.dwStreamType = 1;
    struPreviewInfo.bBlocked = 1;
    struPreviewInfo.hPlayWnd = (void *)CFBridgingRetain(pView);
    
    g_struHandle[iIndex].iPreviewID = NET_DVR_RealPlay_V40(iUserID, &struPreviewInfo, fRealDataCallBack_V30, &g_struHandle[iIndex]);
    if (g_struHandle[iIndex].iPreviewID == -1)
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:1.5];
        hud.mode = MBProgressHUDModeText;
        hud.margin = 10;
        hud.label.text = @"连接失败";
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES afterDelay:1.5];
        return -1;
    }
    NSLog(@"NET_DVR_RealPlay_V40 succ");
    
    return g_struHandle[iIndex].iPreviewID;
}

void fRealDataCallBack_V30(LONG lRealHandle, DWORD dwDataType, BYTE *pBuffer, DWORD dwBufSize, void* pUser)
{
        dispatch_async(dispatch_get_main_queue(), ^{
            [contoller.playView bringSubviewToFront:contoller.titleL];
            [contoller.playView bringSubviewToFront:contoller.backBtn];
            [contoller.playView bringSubviewToFront:contoller.fullScreenBtn];
            contoller.titleL.text = contoller.name;
        });
    LPHANDLE_STRUCT pHandle = (LPHANDLE_STRUCT)pUser;
    contoller -> ipPort = pHandle->iPlayPort;
    switch (dwDataType)
    {
        case NET_DVR_SYSHEAD:
            if(pHandle->iPlayPort != -1)
            {
                break;
            }
            if(!PlayM4_GetPort(&pHandle->iPlayPort))
            {
                break;
            }
            if (dwBufSize > 0 )
            {
                if (!PlayM4_SetStreamOpenMode(pHandle->iPlayPort, STREAME_REALTIME))
                {
                    break;
                }
                if (!PlayM4_OpenStream(pHandle->iPlayPort, pBuffer , dwBufSize, 2*1024*1024))
                {
                    break;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [contoller previewPlay:&pHandle->iPlayPort playView:pHandle->pView];
                });
            }
            break;
        default:
            if (dwBufSize > 0 && pHandle->iPlayPort != -1)
            {
                if(!PlayM4_InputData(pHandle->iPlayPort, pBuffer, dwBufSize))
                {
                    break;
                }
            }
            break;
    }
}

- (void)previewPlay:(int*)iPlayPort playView:(UIView*)playView
{
    m_nPreviewPort = *iPlayPort;
    int iRet = PlayM4_Play(*iPlayPort, (void*)CFBridgingRetain(playView));
    PlayM4_PlaySound(*iPlayPort);
    
    
//    if (iRet != 1)
//    {
//        NSLog(@"PlayM4_Play fail");
//        [self stopPreviewPlay];
//        return;
//    }
}
- (void)dealloc {
    
}
- (void)stop {
    
    NET_DVR_StopPlayBack(g_struHandle[self.num.integerValue - 1].iPreviewID);
    
    if(!NET_DVR_StopRealPlay(g_struHandle[self.num.integerValue - 1].iPreviewID))
    {
        NSLog(@"NET_DVR_StopRealPlay failed:%d",  NET_DVR_GetLastError());
        return;
    }
}
- (IBAction)fullScreenClick:(UIButton *)sender {
    if([sender.currentTitle isEqualToString:@"全屏"]) {
        [sender setTitle:@"退出全屏" forState:UIControlStateNormal];
        self.minddleHeight.constant = 0;
        self.controlHeight.constant = 0;
        self.controlBottom.constant = 0;
        self.controlView.hidden = YES;
        self.bottomView.hidden = YES;
        self.backBtn.hidden = YES;
        self.titleL.hidden = YES;
    } else {
        [sender setTitle:@"全屏" forState:UIControlStateNormal];
        self.minddleHeight.constant = 44;
        self.controlHeight.constant = 250;
        self.controlBottom.constant = 60;
        self.controlView.hidden = NO;
        self.bottomView.hidden = NO;
        self.backBtn.hidden = NO;
        self.titleL.hidden = NO;
    }
    [self orientChange];
}

-(BOOL)shouldAutorotate{
    
    return YES;
    
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscapeLeft;
    
}

- (void)orientChange {
    
    if (_isFullScreen) {
        NSLog(@"按钮-变竖屏");
        [UIView animateWithDuration:0.25 animations:^{
            NSNumber * value  = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
            [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        }];
    }else
    {
        NSLog(@"按钮-变横屏");
        [UIView animateWithDuration:0.25 animations:^{
            NSNumber * value  = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
            [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        }];
    }
    _isFullScreen = !_isFullScreen;
}

- (IBAction)small:(id)sender {
    int a = NET_DVR_PTZControl(g_struHandle[self.num.integerValue - 1].iPreviewID, ZOOM_OUT, 0);
    NSLog(@"%d",a);
}
- (IBAction)big:(id)sender {
   int a = NET_DVR_PTZControl(g_struHandle[self.num.integerValue - 1].iPreviewID, ZOOM_IN, 0);
    NSLog(@"%d",NET_DVR_GetLastError());
}
- (void)logOut {
  int a =  NET_DVR_Logout(self.useId);
}
- (IBAction)openLight:(id)sender {//
    [self controlUrl:@"http://218.13.18.18:20013/MyWebService.asmx/startCamera" para:@{@"camera":self.num}];
}
- (IBAction)closeLight:(id)sender {
    [self controlUrl:@"http://218.13.18.18:20013/MyWebService.asmx/stopCamera" para:@{@"camera":self.num}];
}
- (IBAction)up:(id)sender {
    [self controlUrl:@"http://218.13.18.18:20013/MyWebService.asmx/setUp" para:@{@"shebei":self.num}];
}

- (IBAction)left:(id)sender {
    [self controlUrl:@"http://218.13.18.18:20013/MyWebService.asmx/setLeft" para:@{@"shebei":self.num}];
}
- (IBAction)right:(id)sender {
    [self controlUrl:@"http://218.13.18.18:20013/MyWebService.asmx/setRight" para:@{@"shebei":self.num}];
}
- (IBAction)down:(id)sender {
    [self controlUrl:@"http://218.13.18.18:20013/MyWebService.asmx/setDown" para:@{@"shebei":self.num}];
}
- (void)controlUrl: (NSString *)url para:(NSDictionary *)dic {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 返回NSData
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 把返回的二进制数据转为字符串
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![result containsString:@"suc"] && ![result containsString:@"message_delayed"] ) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:1.5];
            hud.mode = MBProgressHUDModeText;
            hud.margin = 10;
            hud.label.text = @"操作失败";
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES afterDelay:1.5];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
-(BOOL)prefersStatusBarHidden {
    
    return YES;
    
}

- (void)soupurl:(NSString *)url {
    NSString *soapStr = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
                         <soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\
                         <soap12:Body>\
                         <setUp xmlns=\"http://tempuri.org/\">\
                         <shebei>%@</shebei>\
                         </setUp>\
                         </soap12:Body>\
                         </soap12:Envelope>",self.num];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
    // 设置请求超时时间
    manager.requestSerializer.timeoutInterval = 30;
    
    // 返回NSData
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 设置请求头，也可以不设置
    [manager.requestSerializer setValue:@"application/soap+xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%zd", soapStr.length] forHTTPHeaderField:@"Content-Length"];
    [manager.requestSerializer setValue:@"http://tempuri.org/setUp" forHTTPHeaderField:@"SOAPAction"];
    
    // 设置HTTPBody
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        return soapStr;
    }];
    
    [manager POST:url parameters:soapStr success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        // 把返回的二进制数据转为字符串
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",result);
        if ([result containsString:@"unsuc"]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:1.5];
            hud.mode = MBProgressHUDModeText;
            hud.margin = 10;
            hud.label.text = @"操作失败";
            hud.removeFromSuperViewOnHide = YES;
            [hud hideAnimated:YES afterDelay:1.5];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
        NSString *errorStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",errorStr);
    }];
}
@end
