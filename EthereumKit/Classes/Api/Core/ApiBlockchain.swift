import RxSwift
import BigInt

class ApiBlockchain {
    private var disposeBag = DisposeBag()
    private let serialQueueScheduler = SerialDispatchQueueScheduler(qos: .utility)

    weak var delegate: IBlockchainDelegate?

    private let storage: IApiStorage
    private let rpcApiProvider: IRpcApiProvider
    private let reachabilityManager: IReachabilityManager
    private let transactionSigner: TransactionSigner
    private let transactionBuilder: TransactionBuilder
    private var logger: Logger?

    private var started = false

    private(set) var syncState: SyncState = .notSynced {
        didSet {
            if syncState != oldValue {
                delegate?.onUpdate(syncState: syncState)
            }
        }
    }

    init(storage: IApiStorage, rpcApiProvider: IRpcApiProvider, reachabilityManager: IReachabilityManager, transactionSigner: TransactionSigner, transactionBuilder: TransactionBuilder, logger: Logger? = nil) {
        self.storage = storage
        self.rpcApiProvider = rpcApiProvider
        self.reachabilityManager = reachabilityManager
        self.transactionSigner = transactionSigner
        self.transactionBuilder = transactionBuilder
        self.logger = logger

        reachabilityManager.reachabilitySignal
                .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                .subscribe(onNext: { [weak self] in
                    self?.sync()
                })
                .disposed(by: disposeBag)
    }

    private func sync() {
        guard started else {
            return
        }

        guard reachabilityManager.isReachable else {
            syncState = .notSynced
            return
        }

        if case .syncing = syncState {
            return
        }

        syncState = .syncing(progress: nil)

        Single.zip(
                        rpcApiProvider.lastBlockHeightSingle(),
                        rpcApiProvider.balanceSingle()
                )
                .subscribeOn(serialQueueScheduler)
                .subscribe(onSuccess: { [weak self] lastBlockHeight, balance in
                    self?.update(lastBlockHeight: lastBlockHeight)
                    self?.update(balance: balance)

                    self?.syncState = .synced
                }, onError: { [weak self] error in
                    self?.syncState = .notSynced
                    self?.logger?.error("Sync Failed: lastBlockHeight and balance: \(error)")
                })
                .disposed(by: disposeBag)

    }

    private func update(lastBlockHeight: Int) {
        storage.save(lastBlockHeight: lastBlockHeight)
        delegate?.onUpdate(lastBlockHeight: lastBlockHeight)
    }

    private func update(balance: BigUInt) {
        storage.save(balance: balance)
        delegate?.onUpdate(balance: balance)
    }

    private func sendSingle(rawTransaction: RawTransaction, nonce: Int) throws -> Single<Transaction> {
        let signature = try transactionSigner.signature(rawTransaction: rawTransaction, nonce: nonce)
        let transaction = transactionBuilder.transaction(rawTransaction: rawTransaction, nonce: nonce, signature: signature)
        let encoded = transactionBuilder.encode(rawTransaction: rawTransaction, signature: signature, nonce: nonce)

        return rpcApiProvider.sendSingle(signedTransaction: encoded)
                .subscribeOn(serialQueueScheduler)
                .map {
                    transaction
                }
    }

    private func pullTransactionTimestamps(ethereumLogs: [EthereumLog]) -> Single<[EthereumLog]> {
        let logsByBlockNumber = Dictionary(grouping: ethereumLogs, by: { $0.blockNumber })

        var requestSingles = [Single<Block>]()
        for blockNumber in logsByBlockNumber.keys {
            requestSingles.append(rpcApiProvider.getBlock(byNumber: blockNumber))
        }

        return Single.zip(requestSingles)
                .map { (blocks: [Block]) in
                    var resultLogs = [EthereumLog]()

                    for block in blocks {
                        guard let logsOfBlock = logsByBlockNumber[block.number] else {
                            continue
                        }

                        for log in logsOfBlock {
                            log.timestamp = Double(block.timestamp)
                            resultLogs.append(log)
                        }
                    }

                    return resultLogs
                }
    }

}

extension ApiBlockchain: IBlockchain {

    var source: String {
        "RPC \(rpcApiProvider.source)"
    }

    func start() {
        started = true

        sync()
    }

    func stop() {
        started = false
    }

    func refresh() {
        sync()
    }

    var lastBlockHeight: Int? {
        storage.lastBlockHeight
    }

    var balance: BigUInt? {
        storage.balance
    }

    func sendSingle(rawTransaction: RawTransaction) -> Single<Transaction> {
        rpcApiProvider.transactionCountSingle()
                .subscribeOn(serialQueueScheduler)
                .flatMap { [unowned self] nonce -> Single<Transaction> in
                    try self.sendSingle(rawTransaction: rawTransaction, nonce: nonce)
                }
                .do(onSuccess: { [weak self] transaction in
                    self?.sync()
                })
    }

    func getLogsSingle(address: Data?, topics: [Any?], fromBlock: Int, toBlock: Int, pullTimestamps: Bool) -> Single<[EthereumLog]> {
        rpcApiProvider.getLogs(address: address, fromBlock: fromBlock, toBlock: toBlock, topics: topics)
                .subscribeOn(serialQueueScheduler)
                .flatMap { [unowned self] logs in
                    topics.enumerated().forEach { index, any in
                        let anyData = (any as? Data) ?? Data([0])
                    }
                    if pullTimestamps {
                        return self.pullTransactionTimestamps(ethereumLogs: logs)
                    } else {
                        return Single.just(logs)
                    }
                }
    }

    func transactionReceiptStatusSingle(transactionHash: Data) -> Single<TransactionStatus> {
        rpcApiProvider.transactionReceiptStatusSingle(transactionHash: transactionHash)
                .subscribeOn(serialQueueScheduler)
    }

    func transactionExistSingle(transactionHash: Data) -> Single<Bool> {
        rpcApiProvider.transactionExistSingle(transactionHash: transactionHash)
                .subscribeOn(serialQueueScheduler)
    }

    func getStorageAt(contractAddress: Data, positionData: Data, blockHeight: Int) -> Single<Data> {
        rpcApiProvider.getStorageAt(contractAddress: contractAddress.toHexString(), position: positionData.toHexString(), blockNumber: blockHeight)
                .subscribeOn(serialQueueScheduler)
                .flatMap { value -> Single<Data> in
                    guard let data = Data(hex: value) else {
                        return Single.error(ApiError.invalidData)
                    }

                    return Single.just(data)
                }
    }

    func call(contractAddress: Data, data: Data, blockHeight: Int?) -> Single<Data> {
        rpcApiProvider.call(contractAddress: contractAddress.toHexString(), data: data.toHexString(), blockNumber: blockHeight)
                .subscribeOn(serialQueueScheduler)
                .flatMap { value -> Single<Data> in
                    guard let data = Data(hex: value) else {
                        return Single.error(ApiError.invalidData)
                    }

                    return Single.just(data)
                }
    }

    func estimateGas(from: String?, contractAddress: String, amount: BigUInt?, gasLimit: Int?, gasPrice: Int?, data: Data?) -> Single<Int> {
        rpcApiProvider.getEstimateGas(from: from, contractAddress: contractAddress, amount: amount, gasLimit: gasLimit, gasPrice: gasPrice, data: data?.toHexString())
                .subscribeOn(serialQueueScheduler)
                .flatMap { (value: String) -> Single<Int> in
                    guard let data = Int(value.stripHexPrefix(), radix: 16) else {
                        return Single.error(ApiError.invalidData)
                    }

                    return Single.just(data)
                }
    }

}

extension ApiBlockchain {

    static func instance(storage: IApiStorage, transactionSigner: TransactionSigner, transactionBuilder: TransactionBuilder, rpcApiProvider: IRpcApiProvider, logger: Logger? = nil) -> ApiBlockchain {
        let reachabilityManager: IReachabilityManager = ReachabilityManager()

        return ApiBlockchain(storage: storage, rpcApiProvider: rpcApiProvider, reachabilityManager: reachabilityManager, transactionSigner: transactionSigner, transactionBuilder: transactionBuilder, logger: logger)
    }

}