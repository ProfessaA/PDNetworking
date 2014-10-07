#import <Foundation/Foundation.h>


@class KSPromise;


@protocol PDFetchClient <NSObject>

- (KSPromise *)fetchPromiseWithRequestParameters:(id)requestParameters;

@end
