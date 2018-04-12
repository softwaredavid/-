//
//  PlayModel.h
//  GrainDepot
//
//  Created by shuaitong du on 2017/11/26.
//  Copyright © 2017年 EdisonDu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayModel : NSObject

@end

@interface OC_NET_DVR_PREVIEWINFO : NSObject{
    int32_t lChannel;
    int32_t dwStreamType;
    int32_t dwLinkMode;
    void * hPlayWnd;
    int32_t bBlocked;
    int32_t bPassbackRecord;
    Byte byPreviewMode;
    NSString *byStreamID;
    Byte byProtoType;
    Byte byRes1;
    Byte byVideoCodingType;
    int32_t dwDisplayBufNum;
    NSString *byRes;
}

@property int32_t lChannel;
@property int32_t dwStreamType;
@property int32_t dwLinkMode;
@property (nonatomic) void *hPlayWnd;
@property int32_t bBlocked;
@property int32_t bPassbackRecord;
@property Byte byPreviewMode;
@property (nonatomic, retain) NSString *byStreamID;
@property Byte byProtoType;
@property Byte byRes1;
@property Byte byVideoCodingType;
@property int32_t dwDisplayBufNum;
@property (nonatomic, retain) NSString *byRes;
@end
