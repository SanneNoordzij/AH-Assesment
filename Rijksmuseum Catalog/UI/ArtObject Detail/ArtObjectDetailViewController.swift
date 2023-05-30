//
//  ArtObjectDetailViewController.swift
//  Rijksmuseum Catalog
//
//  Created by Sanne Noordzij on 29/05/2023.
//

import Foundation
import UIKit
import SnapKit
import SDWebImage
import Combine

class ArtObjectDetailViewController: UIViewController {

    private let viewModel: ArtObjectDetailViewModel

    private var imageView = UI.imageView()
    private var titleLabel = UI.multilineLable()
    private var makerLabel = UI.multilineLable()
    private var descriptionLabel = UI.multilineLable()
    private let activityIndicator = UIActivityIndicatorView()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ArtObjectDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupViews()
        bind()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
    
    private func bind() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .loading:
                    self?.activityIndicator.startAnimating()
                case .error:
                    self?.activityIndicator.stopAnimating()
                    self?.showError()
                case .data(let data):
                    self?.activityIndicator.stopAnimating()
                    self?.procesData(details: data)
                }
            }.store(in: &cancellables)
    }

    private func procesData(details: CatalogItemDetails) {
        self.titleLabel.text = details.title
        self.descriptionLabel.text = details.description
        self.makerLabel.text = details.maker
        self.imageView.sd_setImage(with: details.imageURL)
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Error", message: "Er is iets mis gegaan", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Probeer opnieuw", style: .default, handler: { [weak self] _ in
            self?.viewModel.fetchDetails()
        }))
        present(alert, animated: true)
    }
    
    private func setupViews() {
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(makerLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(activityIndicator)
        setupConstraints()
    }
    
    private func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.leading)
            make.trailing.equalTo(imageView.snp.trailing)
            make.top.equalTo(imageView.snp.bottom).offset(30)
        }
        
        makerLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.leading)
            make.trailing.equalTo(imageView.snp.trailing)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.leading)
            make.trailing.equalTo(imageView.snp.trailing)
            make.top.equalTo(makerLabel.snp.bottom).offset(8)
        }
    }
    
    
    private enum UI {
        static func imageView() -> UIImageView {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFit
            return iv
        }
        
        static func multilineLable() -> UILabel {
            let l = UILabel()
            l.numberOfLines = 0
            return l
        }
    }
}
