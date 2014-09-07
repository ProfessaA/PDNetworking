#import "CDRSpecHelper.h"
#import "PDURLSessionClient.h"
#import "KSPromise.h"
#import "PSHKFakeOperationQueue.h"
#import "PDURLSessionClientDelegate.h"
#import "KSNetworkClient.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(PDURLSessionClientSpec)

describe(@"PDURLSessionClient", ^{
    __block PDURLSessionClient *subject;
    __block NSURLSession<CedarDouble> *session;
    __block id<PDURLSessionClientDelegate> delegate;
    
    beforeEach(^{
        delegate = nice_fake_for(@protocol(PDURLSessionClientDelegate));
        session = nice_fake_for([NSURLSession class]);
        subject = [[PDURLSessionClient alloc] initWithURLSession:session];
        subject.delegate = delegate;
    });
    
    describe(@"returning a promise for an NSURLRequest", ^{
        __block NSURLRequest *request;
        __block NSURLSessionDataTask *dataTask;
        __block KSPromise *promise;
        
        void (^simulateRequestCompletion)(NSData *, NSURLResponse *, NSError *);
        simulateRequestCompletion = ^(NSData *data, NSURLResponse *response, NSError *error) {
            NSInvocation *invocation = [[session sent_messages] firstObject];
            __autoreleasing void (^actualCompletionBlock)(NSData *, NSURLResponse *, NSError *);
            [invocation getArgument:&actualCompletionBlock atIndex:3];
            if (actualCompletionBlock) {
                actualCompletionBlock(data, response, error);
            }
            else {
                fail(@"Expected completion handler, but none found.");
            }
        };
        
        void (^simulateGetTasksCompletion)(NSArray *, NSArray *, NSArray *);
        simulateGetTasksCompletion = ^(NSArray *dataTasks, NSArray *downloadTasks, NSArray *uploadTasks) {
            NSInvocation *invocation = [session sent_messages][1];
            __autoreleasing void (^actualCompletionBlock)(NSArray *, NSArray *, NSArray *);
            [invocation getArgument:&actualCompletionBlock atIndex:2];
            if (actualCompletionBlock) {
                actualCompletionBlock(dataTasks, downloadTasks, uploadTasks);
            }
            else {
                fail(@"Expected completion handler, but none found.");
            }
        };
        
        beforeEach(^{
            dataTask = nice_fake_for([NSURLSessionDataTask class]);
            request = nice_fake_for([NSURLRequest class]);
            session stub_method(@selector(dataTaskWithRequest:completionHandler:))
                .with(request, Arguments::anything)
                .and_return(dataTask);
            promise = [subject promiseWithRequest:request];
        });
        
        it(@"should get a data task from the NSURLSession", ^{
            session should have_received(@selector(dataTaskWithRequest:completionHandler:)).with(request, Arguments::anything);
        });
        
        it(@"should call resume on the data task", ^{
            dataTask should have_received(@selector(resume));
        });
        
        it(@"should notify the session client's delegate", ^{
            delegate should have_received(@selector(URLSessionClient:didSendRequest:)).with(subject, request);
        });
        
        context(@"when the request succeeds", ^{
            __block NSData *data;
            __block NSURLResponse *response;
            beforeEach(^{
                data = nice_fake_for([NSData class]);
                response = nice_fake_for([NSURLResponse class]);
                simulateRequestCompletion(data, response, nil);
            });
            
            it(@"should get the outstanding tasks in the session", ^{
                session should have_received(@selector(getTasksWithCompletionHandler:));
            });
            
            it(@"should resolve the promise's deferred with a network response object", ^{
                KSNetworkResponse *networkResponse = promise.value;
                networkResponse.response should be_same_instance_as(response);
                networkResponse.data should be_same_instance_as(data);
            });
            
            context(@"when session reports on the in-flight tasks", ^{
                beforeEach(^{
                    simulateGetTasksCompletion(@[@0], @[@0, @1], @[@0, @1, @2]);
                });
                
                it(@"should notify its delegate", ^{
                    delegate should have_received(@selector(URLSessionClient:didUpdateDataTasks:uploadTasks:downloadTasks:)).with(subject, @[@0], @[@0, @1], @[@0, @1, @2]);
                });
            });
        });
        
        context(@"when the network request fails with an error", ^{
            __block NSError *error;
            beforeEach(^{
                error = nice_fake_for([NSError class]);
                simulateRequestCompletion(nil, nil, error);
            });
            
            it(@"should reject the promise's deferred with the error", ^{
                promise.error should be_same_instance_as(error);
            });
        });
    });
});

SPEC_END

