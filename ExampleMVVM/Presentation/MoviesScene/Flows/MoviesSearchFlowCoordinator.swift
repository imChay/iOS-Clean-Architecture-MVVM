//
//  MoviesSearchFlowCoordinator.swift
//  ExampleMVVM
//
//  Created by Oleh Kudinov on 03.03.19.
//

import UIKit

protocol MoviesSearchFlowCoordinatorDependencies  {
    func makeMoviesListViewController(actions: MoviesListViewModelActions) -> MoviesListViewController
    func makeMoviesDetailsViewController(movie: Movie) -> UIViewController
    func makeMoviesQueriesSuggestionsListViewController(didSelect: @escaping MoviesQueryListViewModelDidSelectAction) -> UIViewController
}

/// 影视搜索
final class MoviesSearchFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: MoviesSearchFlowCoordinatorDependencies

    /// 电影列表
    private weak var moviesListVC: MoviesListViewController?
    private weak var moviesQueriesSuggestionsVC: UIViewController?

    init(navigationController: UINavigationController,
         dependencies: MoviesSearchFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        let actions = MoviesListViewModelActions(showMovieDetails: showMovieDetails,
                                                 showMovieQueriesSuggestions: showMovieQueriesSuggestions,
                                                 closeMovieQueriesSuggestions: closeMovieQueriesSuggestions)
        let vc = dependencies.makeMoviesListViewController(actions: actions)

        navigationController?.pushViewController(vc, animated: false)
        moviesListVC = vc
    }
    
    /// 展示电影详情
    /// - Parameter movie:
    private func showMovieDetails(movie: Movie) {
        let vc = dependencies.makeMoviesDetailsViewController(movie: movie)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /// 展示搜索建议
    /// - Parameter didSelect:
    private func showMovieQueriesSuggestions(didSelect: @escaping (MovieQuery) -> Void) {
        guard let moviesListViewController = moviesListVC, moviesQueriesSuggestionsVC == nil,
            let container = moviesListViewController.suggestionsListContainer else { return }

        let vc = dependencies.makeMoviesQueriesSuggestionsListViewController(didSelect: didSelect)

        moviesListViewController.add(child: vc, container: container)
        moviesQueriesSuggestionsVC = vc
        container.isHidden = false
    }
    
    /// 关闭搜索建议
    private func closeMovieQueriesSuggestions() {
        moviesQueriesSuggestionsVC?.remove()
        moviesQueriesSuggestionsVC = nil
        moviesListVC?.suggestionsListContainer.isHidden = true
    }
}
