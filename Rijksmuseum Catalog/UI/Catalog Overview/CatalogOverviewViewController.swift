//
//  CatalogOverviewViewController.swift
//  Rijksmuseum Catalog
//
//  Created by Sanne Noordzij on 29/05/2023.
//

import UIKit
import Combine
import SnapKit

class CatalogOverviewViewController: UIViewController {

    private let viewModel: CatalogOverviewViewModel
    private let collectionView = UI.collectionView()
    private let activityIndicator = UIActivityIndicatorView()
    private var currentListOfItems: [Int:[CatalogItem]] = [:]
    private var cancellables = Set<AnyCancellable>()
    private var isLoading = false
    private var didReachEndOfList = true

    init(viewModel: CatalogOverviewViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        setupView()
        bind()
    }

    private func bind() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                    self.activityIndicator.stopAnimating()
                switch state {
                case .loading where self.currentListOfItems.keys.isEmpty:
                    self.activityIndicator.startAnimating()
                    break
                case .loading:
                    self.isLoading = true
                case .error:
                    self.isLoading = false
                    self.showError()
                case .data(let data):
                    self.isLoading = false
                    self.currentListOfItems = data.currentItems
                    self.didReachEndOfList = data.reachedEndOfList
                    self.collectionView.reloadData()
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupView() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func showError() {
        let alert = UIAlertController(title: "Error", message: "Er is iets mis gegaan", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Probeer opnieuw", style: .default, handler: { [weak self] _ in
            self?.viewModel.fetchCatalogItems()
        }))
        present(alert, animated: true)
    }

    private enum UI {
        static func collectionView() -> UICollectionView {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: UIScreen.main.bounds.height/3 + 40)
            layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 30)
            let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
            cv.register(CatalogItemCollectionViewCell.self, forCellWithReuseIdentifier: "CatalogItemCollectionViewCell")
            cv.register(ItemLoadingCollectionViewCell.self, forCellWithReuseIdentifier: "ItemLoadingCollectionViewCell")
            cv.register(SectionHeaderCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeaderCollectionViewCell")
            cv.backgroundColor = UIColor.white
            return cv
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension CatalogOverviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.currentListOfItems.keys.count + 1 // for the loading section
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section < currentListOfItems.keys.count {
            return currentListOfItems[section + 1]?.count ?? 0
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
             let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeaderCollectionViewCell", for: indexPath) as! SectionHeaderCollectionViewCell
            sectionHeader.title.text = "Page \(indexPath.section + 1)"
             return sectionHeader
        } else { //No footer in this case but can add option for that
             return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section < currentListOfItems.keys.count {
            let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatalogItemCollectionViewCell", for: indexPath)
            (itemCell as? CatalogItemCollectionViewCell)?.updateView(catalogItem: currentListOfItems[indexPath.section + 1]?[indexPath.row])
            return itemCell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemLoadingCollectionViewCell", for: indexPath)
            if isLoading {
                (cell as? ItemLoadingCollectionViewCell)?.activityIndicator.startAnimating()
            } else {
                (cell as? ItemLoadingCollectionViewCell)?.activityIndicator.stopAnimating()
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelect(item: currentListOfItems[indexPath.section + 1]?[indexPath.row])
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == currentListOfItems.keys.count, !currentListOfItems.keys.isEmpty, !isLoading, !didReachEndOfList {
            (cell as? ItemLoadingCollectionViewCell)?.activityIndicator.startAnimating()
            viewModel.fetchNextSetOfItems()
        }
    }
}
