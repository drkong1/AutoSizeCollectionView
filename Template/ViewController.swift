//
//  ViewController.swift
//
// Copyright (c) 2020 Hunjong Bong
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxViewController

/*
 If numberOfItemsInSection == 20,
 func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
 is called 20 times just after reloadData() whether cell is visible or not.

 If we use estimatedItemSize propely, we can calculate only visible cells.
 */

class ViewController: UIViewController {
    private var items: [String] = []
    private var disposeBag = DisposeBag()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        // When using estimatedItemSize, both minimumLineSpacing, minimumInteritemSpacing should be zero or nonzero.
        layout.minimumLineSpacing = 0 // Apple: The default value of this property is 10.0.
        layout.minimumInteritemSpacing = 0 // Apple: The default value of this property is 10.0.

        /*
         If we set estimatedItemSize too small, we can not improve performance.
         For instance,
         If we set layout.estimatedItemSize = CGSize(width: 1, height: 40),
         all cell's (include non visible cell's) preferredLayoutAttributesFitting are called immediately
         */
        if #available(iOS 10, *) {
            /*
             It seems UICollectionViewFlowLayout.automaticSize is (50.0, 50.0).
             Because In func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes
             layoutAttributes.frame is (50.0, 50.0).

             So if UICollectionView's height is less than 50.0, Xcode console prints
             "the item height must be less than the height of the UICollectionView minus the section insets top and bottom values, minus the content insets top and bottom values."
             */
            layout.estimatedItemSize = CGSize(width: 50, height: 40) // UICollectionViewFlowLayout.automaticSize
        } else {
            layout.estimatedItemSize = CGSize(width: 50, height: 40)
        }

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SimpleTextCell.self, forCellWithReuseIdentifier: "SimpleTextCell")

        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemTeal
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let button = UIButton()
        button.setTitle("Add Items to collectionView", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        view.addSubview(button)
        button.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(150)
        }
        button.rx.tap
            .bind(onNext: {[weak self] in
                guard let self = self else { return }

                let count = self.items.count
                for i in 0..<20 {
                    self.items.append("item: \(count + i)")
                }
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(40)
            $0.top.equalTo(button.snp.bottom).offset(50)
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return self.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SimpleTextCell", for: indexPath) as! SimpleTextCell
        cell.bindData(items[indexPath.item])
        if indexPath.item % 2 == 0 {
            cell.backgroundColor = .systemYellow
        } else {
            cell.backgroundColor = .systemBlue
        }
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    //    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    //        print("size", indexPath.item)
    //        return CGSize(width: 100, height: 40)
    //    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select \(indexPath)")
    }
}


class SimpleTextCell: UICollectionViewCell {
    private let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        // Apple: If you override this method and want the cell size adjustments, call super first and make your own modifications to the returned
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        print("preferred", attributes.indexPath.item, attributes.frame, layoutAttributes.frame)
        attributes.size.width = 100
        attributes.size.height = 40
        return attributes
    }
}

extension SimpleTextCell {
    private func setup() {
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        contentView.addSubview(titleLabel)
        titleLabel.snp.remakeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension SimpleTextCell {
    internal func bindData(_ text: String) {
        titleLabel.text = text
    }
}
