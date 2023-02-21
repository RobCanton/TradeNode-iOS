//
//  SearchVC.swift
//  TradeLink
//
//  Created by Robert Canton on 2021-01-04.
//

import Foundation
import UIKit
import Combine

protocol SymbolSearchDelegate:class {
    func symbolSearchDidSelect(_ symbol:SymbolSearchResult)
}

class SearchViewController:UIViewController {
    
    var closeButton:UIButton!
    var textField:UITextField!
    
    var tableView:UITableView!
    var tableViewBottomAnchor:NSLayoutConstraint!
    
    var requests = Set<AnyCancellable>()
    
    var searchResults = [SymbolSearchResult]()
    
    let debouncer = Debouncer(timeInterval: 0.1)
    
    weak var delegate:SymbolSearchDelegate?
    
//    init(delegate:SymbolSearchDelegate?=nil){
//        self.delegate = delegate
//        super.init(nibName: nil, bundle: nil)
//    }

    deinit {
        self.log("Deinit")
    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        view.backgroundColor = UIColor.theme.background
        let navView = UIView()
        view.addSubview(navView)
        navView.constraintToSuperview(0, 0, nil, 0, ignoreSafeArea: false)
        navView.constraintHeight(to: 44)
        navView.backgroundColor = UIColor.theme.background
        
        closeButton = UIButton(type: .system)
        navView.addSubview(closeButton)
        closeButton.constraintToSuperview(0, 4, 0, nil, ignoreSafeArea: true)
        closeButton.widthAnchor.constraint(equalTo: navView.heightAnchor).isActive = true
        let mediumConfig = UIImage.SymbolConfiguration(weight: .light)
        closeButton.setImage(UIImage(named: "Full Arrow Left"), for: .normal)
        closeButton.tintColor = UIColor.label
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        textField = UITextField()
        navView.addSubview(textField)
        textField.constraintToSuperview(0, nil, 0, 12, ignoreSafeArea: true)
        textField.autocapitalizationType = .allCharacters
        textField.placeholder = "Search Name or Symbol"
        textField.tintColor = UIColor.label
        textField.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: 6).isActive = true
        textField.addTarget(self, action: #selector(textViewDidChange), for: .editingChanged)
        
        let separator = UIView()
        separator.backgroundColor = UIColor.opaqueSeparator.withAlphaComponent(0.5)
        view.addSubview(separator)
        separator.constraintToSuperview(nil, 0, nil, 0, ignoreSafeArea: true)
        separator.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 0).isActive = true
        separator.constraintHeight(to: 0.5)
        
        /*
        let filterRow = SearchFilterRow()
        view.addSubview(filterRow)
        filterRow.constraintToSuperview(nil, 0, nil, 0, ignoreSafeArea: true)
        filterRow.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 0).isActive = true*/
        
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.constraintToSuperview(nil, 0, nil, 0, ignoreSafeArea: false)
        tableView.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        tableViewBottomAnchor = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        tableViewBottomAnchor.isActive = true
        
        tableView.register(TickerSearchResultCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        //tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.theme.secondaryBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.textField.becomeFirstResponder()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
        self.delegate = nil
    }
    
    @objc func handleDismiss() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func textViewDidChange() {
        let text = textField.text ?? ""
        
        guard !text.isEmpty else {
            self.searchResults = []
            self.tableView.reloadData()
            return
        }
        
        API.Ref.searchSymbols(query: text)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { state in
            }, receiveValue: { response in
                self.searchResults = response
                self.tableView.reloadData()
            }).store(in: &self.requests)
        
//        debouncer.renewInterval()
//        debouncer.handler = {
//            API.Ref.searchSymbols(query: text)
//                .receive(on: DispatchQueue.main)
//                .sink(receiveCompletion: { state in
//                }, receiveValue: { response in
//                    self.searchResults = response
//                    self.tableView.reloadData()
//                }).store(in: &self.requests)
//        }
        
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue  else { return }
        tableViewBottomAnchor.constant = -keyboardSize.height
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        view.layoutIfNeeded()
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TickerSearchResultCell
        let result = searchResults[indexPath.row]
        cell.titleLabel.text = result.s
        cell.subtitleLabel.text = result.n
        cell.backgroundColor = UIColor.theme.secondaryBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()
        
        delegate?.symbolSearchDidSelect(searchResults[indexPath.row])
        handleDismiss()
    }
}
