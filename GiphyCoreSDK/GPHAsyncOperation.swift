//
//  GPHAsyncOperation.swift
//  GiphyCoreSDK
//
//  Created by Cem Kozinoglu on 4/24/17.
//  Copyright © 2017 Giphy. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

import Foundation

/// Sub-classing Operation to make sure we manage its state correctly
///
class GPHAsyncOperation: Operation {
    public enum State: String {
        case ready, executing, finished
        
        /// cool trick from raywenderlich
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    /// Using KVO to update state
    open var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}

/// State management
///
extension GPHAsyncOperation {
    
    override open var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override open var isExecuting: Bool {
        return state == .executing
    }
    
    override open var isFinished: Bool {
        return state == .finished
    }
    
    override open var isAsynchronous: Bool {
        return true
    }
    
    override open func start() {
        if isCancelled {
            state = .finished
            return
        }
        
        main()
        state = .executing
    }
    
    override open func cancel() {
        super.cancel()
        state = .finished
    }
}

/// A specific type of async operation with a completion handler.
///
class GPHAsyncOperationWithCompletion: GPHAsyncOperation {
    /// User completion block to be called.
    let completion: GPHCompletionHandler?
    
    init(completionHandler: GPHCompletionHandler?) {
        self.completion = completionHandler
    }
    
    /// Finish this operation.
    /// This method should be called exactly once per operation.
    internal func callCompletion(data: GPHJSONObject?, response: URLResponse?, error: Error?) {
        if !isCancelled {
            if let completion = completion {
                completion(data, response, error)
            }
            state = .finished
        }
    }

}
