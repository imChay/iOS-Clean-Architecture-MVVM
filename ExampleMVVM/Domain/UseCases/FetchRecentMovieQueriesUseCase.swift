//
//  FetchRecentMovieQueriesUseCase.swift
//  ExampleMVVM
//
//  Created by Oleh Kudinov on 11.08.19.
//

import Foundation

// This is another option to create Use Case using more generic way
final class FetchRecentMovieQueriesUseCase: UseCase {

    // 请求
    struct RequestValue {
        let maxCount: Int
    }
    
    // 响应
    typealias ResultValue = (Result<[MovieQuery], Error>)

    private let requestValue: RequestValue
    private let completion: (ResultValue) -> Void
    
    // 数据层协议，用来获取最近的搜索数据方法
    private let moviesQueriesRepository: MoviesQueriesRepository

    init(requestValue: RequestValue,
         completion: @escaping (ResultValue) -> Void,
         moviesQueriesRepository: MoviesQueriesRepository) {

        self.requestValue = requestValue
        self.completion = completion
        self.moviesQueriesRepository = moviesQueriesRepository
    }
    
    func start() -> Cancellable? {

        moviesQueriesRepository.fetchRecentsQueries(maxCount: requestValue.maxCount, completion: completion)
        return nil
    }
}
