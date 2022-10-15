//
//  DownloadOperation.swift
//  BLMusic
//
//  Created by Son Hoang on 14/10/2022.
//

import Foundation

class DownloadOperation: Operation, NetworkCancellable {
    
    private var progressObservation: NSKeyValueObservation?
    private var task : URLSessionDownloadTask!
    
    enum OperationState : Int {
        case ready
        case executing
        case finished
    }
    
    private var state : OperationState = .ready {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isReady: Bool { return state == .ready }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    init(
        session: URLSession = URLSession.shared,
        downloadTaskURL: URL,
        progressHandler: @escaping (Double) -> Void,
        downloadHandler: ((URL?, URLResponse?, Error?) -> Void)?
    ) {
        super.init()
        
        task = session.downloadTask(
            with: downloadTaskURL,
            completionHandler: { [weak self] (localURL, response, error) in
                guard let self = self else {
                    downloadHandler?(nil, nil, DownloadError.somethingWentWrong)
                    return
                }
                
                downloadHandler?(localURL, response, error)
                
                self.state = .finished
            }
        )
        
        progressObservation = task.progress.observe(\.fractionCompleted) { progress, _ in
            progressHandler(progress.fractionCompleted)
        }
    }
    
    override func start() {
        if(isCancelled) {
            state = .finished
            return
        }
        
        state = .executing
        
        task.resume()
    }
    
    override func cancel() {
        super.cancel()
        
        task.cancel()
        
        progressObservation?.invalidate()
    }
}
