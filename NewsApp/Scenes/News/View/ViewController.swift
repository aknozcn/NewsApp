//
//  ViewController.swift
//  NewsApp
//
//  Created by Akin O. on 1.06.2021.
//

import UIKit
import Kingfisher
import FFPopup


class NewsViewController: UIViewController, APIFetching {


    @IBOutlet var popupView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var germanyRadioButton: UIButton!
    @IBOutlet weak var turkeyRadioButton: UIButton!
    @IBOutlet weak var usaRadioButton: UIButton!

    var currentPage = 0
    var isLoadingList = false
    var searchedNews = [Article]()
    var searching = false
    var popup = FFPopup()
    let layout = FFPopupLayout(horizontal: .center, vertical: .center)

    let viewModel = NewsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")

        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count - 1] as URL)


        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        searchBar.delegate = self

        popupView.layer.cornerRadius = 15
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 1
        popupView.layer.shadowOffset = .zero
        popupView.layer.shadowRadius = 10
        popupView.layer.shadowPath = UIBezierPath(rect: popupView.bounds).cgPath
        popupView.layer.shouldRasterize = true
        popupView.layer.rasterizationScale = UIScreen.main.scale

        viewModel.delegate = self
        viewModel.getAllNews()
    }
    @IBAction func buttonFilterTapped(_ sender: Any) {
        popup = FFPopup(contentView: popupView, showType: .growIn, dismissType: .shrinkOut, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)

        popup.show(layout: layout)
    }

    @IBAction func radioButtonGermanyTapped(_ sender: UIButton) {
        if let image = UIImage(systemName: "circle.fill") {
            turkeyRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
            usaRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
            germanyRadioButton.setImage(image, for: .normal)
        }
    }

    @IBAction func radioButtonTurkeyTapped(_ sender: UIButton) {
        if let image = UIImage(systemName: "circle.fill") {
            germanyRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
            usaRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
            turkeyRadioButton.setImage(image, for: .normal)
        }
    }
    @IBAction func radioButtonUsaTapped(_ sender: UIButton) {
        if let image = UIImage(systemName: "circle.fill") {
            turkeyRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
            germanyRadioButton.setImage(UIImage(systemName: "circle"), for: .normal)
            usaRadioButton.setImage(image, for: .normal)
        }
    }



    func didFetched() {
        tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewcontroller viewDidAppear çalıştı")
    }

}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }


    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action = UIContextualAction(style: .normal, title: "Favori") { [weak self] (action, view, completionHandler) in

            self?.viewModel.handleMarkAsFavourite(indexPath: indexPath)

            completionHandler(true)
        }
        action.backgroundColor = .systemYellow
        return UISwipeActionsConfiguration(actions: [action])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchedNews.count
        } else {
            return viewModel.allNews?.articles.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsTableViewCell
        if searching {

            let url = URL(string: "\(searchedNews[indexPath.row].urlToImage ?? "")")
            cell.imageViewAuthor.kf.setImage(with: url)
            cell.labelAuthor.text = searchedNews[indexPath.row].author
            cell.labelDate.text = String.getFormattedDate(formatter: "\(searchedNews[indexPath.row].publishedAt ?? "")")
            cell.labelTitle.text = searchedNews[indexPath.row].title
            cell.labelDescription.text = searchedNews[indexPath.row].articleDescription
        } else {
            let url = URL(string: "\(viewModel.allNews?.articles[indexPath.row].urlToImage ?? "")")
            cell.imageViewAuthor.kf.setImage(with: url)
            cell.labelAuthor.text = viewModel.allNews?.articles[indexPath.row].author
            cell.labelDate.text = String.getFormattedDate(formatter: "\(viewModel.allNews?.articles[indexPath.row].publishedAt ?? "")")
            cell.labelTitle.text = viewModel.allNews?.articles[indexPath.row].title
            cell.labelDescription.text = viewModel.allNews?.articles[indexPath.row].articleDescription
        }
        return cell
    }
}

extension NewsViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        searchedNews = viewModel.allNews?.articles.filter({ data -> Bool in
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
