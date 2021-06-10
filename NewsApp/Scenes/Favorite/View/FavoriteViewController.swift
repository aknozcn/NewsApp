//
//  FavoriteViewController.swift
//  NewsApp
//
//  Created by Akin O. on 4.06.2021.
//

import UIKit

class FavoriteViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!

    var viewModel = FavoriteViewModel()
    var searchedNews = [Article]()
    var searching = false
    var coordinator: AppCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        searchBar.delegate = self
        viewModel.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.getAllFavoriteNews()
    }
}

extension FavoriteViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        coordinator?.startWebView(webURL: viewModel.allNews?[indexPath.row].url ?? "")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 260
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .normal, title: "Sil") { (action, view, completionHandler) in

            let alert = UIAlertController(title: "Dikkat", message: "Bu favori haberi silmek istiyor musun?", preferredStyle: UIAlertController.Style.alert)

            alert.addAction(UIAlertAction(title: "Sil", style: UIAlertAction.Style.default, handler: { action in
                self.viewModel.handleDeleteFavorite(title: (self.viewModel.allNews?[indexPath.row].title)!)
            }))
            alert.addAction(UIAlertAction(title: "İptal Et", style: UIAlertAction.Style.cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)

            tableView.reloadData()
            completionHandler(true)
        }
        action.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [action])
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchedNews.count
        } else {
            return viewModel.allNews?.count ?? 0
        }

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellFavorite", for: indexPath) as! FavoriteTableViewCell
        if searching {

            let url = URL(string: "\(searchedNews[indexPath.row].urlToImage ?? "")")
            cell.imageViewAuthor.kf.setImage(with: url)
            cell.labelAuthor.text = searchedNews[indexPath.row].author
            cell.labelDate.text = String.getFormattedDate(formatter: "\(searchedNews[indexPath.row].publishedAt ?? "")")
            cell.labelTitle.text = searchedNews[indexPath.row].title
            cell.labelDescription.text = searchedNews[indexPath.row].articleDescription
        } else {
            let url = URL(string: "\(viewModel.allNews?[indexPath.row].urlToImage ?? "")")
            cell.imageViewAuthor.kf.setImage(with: url)
            cell.labelAuthor.text = viewModel.allNews?[indexPath.row].author
            cell.labelDate.text = String.getFormattedDate(formatter: "\(viewModel.allNews?[indexPath.row].publishedAt ?? "")")
            cell.labelTitle.text = viewModel.allNews?[indexPath.row].title
            cell.labelDescription.text = viewModel.allNews?[indexPath.row].articleDescription
        }
        return cell
    }
}

extension FavoriteViewController: FavoriteViewModelDelegate {
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
}

extension FavoriteViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        searchedNews = viewModel.allNews?.filter({ data -> Bool in
            let searchLowercased = searchText.lowercased()
            let matches: [String?] = [data.title, data.articleDescription]
            let nonNilElements = matches.compactMap { $0 }

            for element in nonNilElements {
                if element.lowercased().contains(searchLowercased) {
                    return true
                }
            }
            return false
        }) ?? []

        searching = true
        tableView.reloadData()
        if searchText.count < 1 {
            searching = false
            tableView.reloadData()
        }
    }

    func searchBarTextDidBeginEditing(_searchBar: UISearchBar) {
        
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        searchBar.endEditing(true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.endEditing(true)
    }

    func searchBarCancelButtonClicked(_searchBar: UISearchBar) {
        
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searching = false
        tableView.reloadData()
        searchBar.endEditing(true)
    }
}
