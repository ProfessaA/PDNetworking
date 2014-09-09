#import <Foundation/Foundation.h>


@class KSPromise;


@protocol PDUpdateClient <NSObject>

- (KSPromise *)updatePromiseWithRequestParameters:(id)requestParameters;

@end