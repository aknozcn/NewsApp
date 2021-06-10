//
//  ViewController.swift
//  NewsApp
//
//  Created by Akin O. on 1.06.2021.
//

import UIKit
import Kingfisher
import FFPopup
import MotionToastView

enum CountryFilter {
    case Germany, Turkey, USA
}

class NewsViewController: UIViewController, APIFetching, Storyboarded {

    @IBOutlet var popupView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var germanyRadioButton: UIButton!
    @IBOutlet weak var turkeyRadioButton: UIButton!
    @IBOutlet weak var usaRadioButton: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!

    var refreshControl = UIRefreshControl()
    var searchedNews = [Article]()
    var searching = false
    var popup = FFPopup()
    var turkeyFilter = false
    var germanyFilter = false
    var usaFilter = false
    var selectedFilter: CountryFilter?
    
    var coordinator: AppCoordinator?
    
    let viewModel = NewsViewModel()
    let layout = FFPopupLayout(horizontal: .center, vertical: .center)
 
    override func viewDidLoad() {
        super.viewDidLoad()

        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

        searchBar.delegate = self

        pickerView.delegate = self
        pickerView.dataSource = self

        popupView.layer.cornerRadius = 15
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 1
        popupView.layer.shadowOffset = .zero
        popupView.layer.shadowRadius = 10
        popupView.layer.shadowPath = UIBezierPath(rect: popupView.bounds).cgPath
        popupView.layer.shouldRasterize = true
        popupView.layer.rasterizationScale = UIScreen.main.scale
        popup = FFPopup(contentView: popupView, showType: .growIn, dismissType: .shrinkOut, maskType: .dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        
        viewModel.delegate = self
        viewModel.getNews(categoryType: .general, languageType: .turkey)

        refreshControl.attributedTitle = NSAttributedString(string: "Yenileniyor")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)

    }

    @objc func refresh(_ sender: AnyObject) {
        
        viewModel.getNews(categoryType: .general, languageType: .turkey)
    }

    @IBAction func buttonFilterTapped(_ sender: Any) {

        popup.show(layout: layout)
    }

    @IBAction func radioButtonGermanyTapped(_ sender: UIButton) {

        selectCountryRadioButton(which: sender)
    }

    @IBAction func radioButtonTurkeyTapped(_ sender: UIButton) {

        selectCountryRadioButton(which: sender)
    }
    @IBAction func radioButtonUsaTapped(_ sender: UIButton) {

        selectCountryRadioButton(which: sender)
    }

    func selectCountryRadioButton(which: UIButton) {
        
        let mapping: [UIButton: CountryFilter] = [germanyRadioButton: .Germany, turkeyRadioButton: .Turkey, usaRadioButton: .USA];
        for (rb, _) in mapping where rb != which {
            if let image = UIImage(systemName: "circle") {
                rb.setImage(image, for: .normal)
            }
        }
        which.setImage(UIImage(systemName: "circle.fill"), for: UIControl.State.normal)
        self.selectedFilter = mapping[which]
    }


    @IBAction func filterButtonTapped(_ sender: UIButton) {

        let selectedRow = pickerView.selectedRow(inComponent: 0)
        let categoryName = CategortyType(rawValue: CategortyType.allCases[selectedRow].rawValue)!

        switch selectedFilter {
        case .Turkey:
            viewModel.getNews(categoryType: categoryName, languageType: .turkey)
        case .Germany:
            viewModel.getNews(categoryType: categoryName, languageType: .germany)
        case .USA:
            viewModel.getNews(categoryType: categoryName, languageType: .usa)
        case .none:
            print("none")
        }
        popup.dismiss(animated: false)
    }

    func didFetched() {
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        coordinator?.startWebView(webURL: viewModel.allNews?.articles[indexPath.row].url ?? "")
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 260
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action = UIContextualAction(style: .normal, title: "Favori") { (action, view, completionHandler) in

            if self.viewModel.handleMarkAsFavourite(indexPath: indexPath) {
                self.MotionToast_Customisation(header: "Başarılı", message: "Favorilere Eklendi.", headerColor: .white, messageColor: .white, primary_color: #colorLiteral(red: 0.3352797031, green: 0.8016245365, blue: 0.4457932711, alpha: 1), secondary_color: .white, icon_image: UIImage(named: "success_icon")!, toastCornerRadius: 12)
            } else {

                self.MotionToast_Customisation(header: "Hata", message: "Bu haber favorilerde mevcut.", headerColor: .white, messageColor: .white, primary_color: #colorLiteral(red: 0.9213091731, green: 0.3403865695, blue: 0.3403876424, alpha: 1), secondary_color: .white, icon_image: UIImage(named: "error_icon")!, toastCornerRadius: 12)
            }
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

extension NewsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return CategortyType.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return CategortyType.allCases[row].rawValue
    }
}
