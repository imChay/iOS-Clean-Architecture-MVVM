//
//  MoviesRepositoryInterfaces.swift
//  ExampleMVVM
//
//  Created by Oleh Kudinov on 01.10.18.
//

import Foundation

protocol MoviesRepository {
    /// swift 正常的方法如果有返回值的话,调用的时候必须有一个接收方,否则的话编译器会报一个警告,如果在方法前加上 @discardableResult 不处理的时候就不会有警告了。
    @discardableResult
    func fetchMoviesList(query: MovieQuery, page: Int,
                         cached: @escaping (MoviesPage) -> Void,
                         completion: @escaping (Result<MoviesPage, Error>) -> Void) -> Cancellable?
}
