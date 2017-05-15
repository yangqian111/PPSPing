#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "PPSICMPHeader.h"
#import "PPSPing.h"
#import "PPSPingServices.h"
#import "PPSPingSummary.h"

FOUNDATION_EXPORT double PPSPingVersionNumber;
FOUNDATION_EXPORT const unsigned char PPSPingVersionString[];

