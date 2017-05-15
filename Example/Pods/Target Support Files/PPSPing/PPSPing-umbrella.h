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

#import "NAQOSICMPHeader.h"
#import "NAQOSPing.h"
#import "NAQOSPingServices.h"
#import "NAQOSPingSummary.h"

FOUNDATION_EXPORT double PPSPingVersionNumber;
FOUNDATION_EXPORT const unsigned char PPSPingVersionString[];

