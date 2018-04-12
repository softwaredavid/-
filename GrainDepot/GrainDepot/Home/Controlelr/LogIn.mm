//
//  LogIn.m
//  GrainDepot
//
//  Created by shuaitong du on 2017/11/25.
//  Copyright © 2017年 EdisonDu. All rights reserved.
//

#import "LogIn.h"
#import "hcnetsdk.h"


@implementation LogIn


-(int32_t) NET_DVR_Login_V30:(NSString*) sDVRIP wDVRPort:(UInt16)wDVRPort sUserName:(NSString*) sUserName sPassword:(NSString*)sPassword OC_LPNET_DVR_DEVICEINFO_V30:(OC_NET_DVR_DEVICEINFO_V30*)OC_LPNET_DVR_DEVICEINFO_V30
{
    NET_DVR_DEVICEINFO_V30 logindeviceInfo = {0};
    int iUserID = NET_DVR_Login_V30((char*)[sDVRIP UTF8String],
                                    wDVRPort,
                                    (char*)[sUserName UTF8String],
                                    (char*)[sPassword UTF8String],
                                    &logindeviceInfo);
    
    if(iUserID >= 0)
    {
        OC_LPNET_DVR_DEVICEINFO_V30.byChanNum = logindeviceInfo.byChanNum;
        OC_LPNET_DVR_DEVICEINFO_V30.byStartChan = logindeviceInfo.byStartChan;
        OC_LPNET_DVR_DEVICEINFO_V30.byIPChanNum = logindeviceInfo.byIPChanNum;
        OC_LPNET_DVR_DEVICEINFO_V30.byStartDChan = logindeviceInfo.byStartDChan;
        OC_LPNET_DVR_DEVICEINFO_V30.byHighDChanNum = logindeviceInfo.byHighDChanNum;
    }
    return iUserID;
}
@end
