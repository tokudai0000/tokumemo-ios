//
//  AcknowledgementsViewController.swift
//  univIP
//
//  Created by Akihiro Matsuyama on 2023/08/23.
//

import UIKit
import RxSwift
import Entity

final class AcknowledgementsViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    private let leftBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: nil, action: nil)

    private let disposeBag = DisposeBag()

    var viewModel: AcknowledgementsViewModelInterface!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureNavigation()
        binding()
        viewModel.input.viewDidLoad.accept(())
    }
}

// MARK: Binding
private extension AcknowledgementsViewController {
    func binding() {
        leftBarButton.rx
            .tap
            .subscribe(with: self) { owner, _ in
                owner.viewModel.input.didTapBackButton.accept(())
            }
            .disposed(by: disposeBag)

        viewModel.output
            .acknowledgementsItems
            .bind(to: tableView.rx.items(cellIdentifier: R.nib.licenseCell.identifier, cellType: LicenseCell.self)) { index, item, cell in
                cell.configure(item: item)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: Layout
private extension AcknowledgementsViewController {
    private func configureTableView() {
        // TableViewの基本的な設定
        tableView.register(R.nib.licenseCell)
        tableView.showsVerticalScrollIndicator = true
        tableView.indicatorStyle = .black
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }

    func configureNavigation() {
        title = R.string.localizable.acknowledgements()
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationItem.setLeftBarButton(leftBarButton, animated: true)
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
}

extension AcknowledgementsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.input.didTapAcknowledgementsItem.accept(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
