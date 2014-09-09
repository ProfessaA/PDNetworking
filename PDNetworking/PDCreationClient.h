#import <Foundation/Foundation.h>


@class KSPromise;


@protocol PDCreationClient <NSObject>

- (KSPromise *)creationPromiseWithRequestParameters:(id)requestParameters;

@end
