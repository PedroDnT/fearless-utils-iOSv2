import Foundation
import Starscream

extension WebSocketEngine: JSONRPCEngine {
    public func callMethod<P: Encodable, T: Decodable>(
        _ method: String,
        params: P?,
        options: JSONRPCOptions,
        completion closure: ((Result<T, Error>) -> Void)?
    ) throws -> UInt16 {
        mutex.lock()

        defer {
            mutex.unlock()
        }

        let request = try prepareRequest(
            method: method,
            params: params,
            options: options,
            completion: closure
        )

        updateConnectionForRequest(request)

        return request.requestId
    }

    public func subscribe<P: Encodable, T: Decodable>(
        _ method: String,
        params: P?,
        updateClosure: @escaping (T) -> Void,
        failureClosure: @escaping (Error, Bool) -> Void
    ) throws -> UInt16 {
        mutex.lock()

        defer {
            mutex.unlock()
        }

        let completion: ((Result<String, Error>) -> Void)? = nil

        let request = try prepareRequest(
            method: method,
            params: params,
            options: JSONRPCOptions(resendOnReconnect: true),
            completion: completion
        )

        let subscription = JSONRPCSubscription(
            requestId: request.requestId,
            requestData: request.data,
            requestOptions: request.options,
            updateClosure: updateClosure,
            failureClosure: failureClosure
        )

        addSubscription(subscription)

        updateConnectionForRequest(request)

        return request.requestId
    }

    public func cancelForIdentifier(_ identifier: UInt16) {
        mutex.lock()

        cancelRequestForLocalId(identifier)

        mutex.unlock()
    }
    
    public func reconnect(url: URL) {        
        self.url = url
        let request = URLRequest(url: url, timeoutInterval: 10)

        let engine = WSEngine(
            transport: FoundationTransport(),
            certPinner: FoundationSecurity(),
            compressionHandler: nil
        )
        
        self.connection.forceDisconnect()
        self.connection.delegate = nil
        
        let connection = WebSocket(request: request, engine: engine)
        self.connection = connection

        connection.delegate = self
        connection.callbackQueue = Self.sharedProcessingQueue
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            connection.connect()
        }
    }
}
