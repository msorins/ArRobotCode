//
//  PublicLevelsViewController.swift
//  ArRobotCode
//
//  Created by Sorin Sebastian Mircea on 15/12/2018.
//  Copyright © 2018 Sorin Sebastian Mircea. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

struct CustomData {
    var anInt: Int
    var aString: String
    var aCGPoint: CGPoint
}

struct SectionOfCustomData {
    var header: String
    var footer: String
    var items: [Item]
}
extension SectionOfCustomData: SectionModelType {
    typealias Item = CustomData
    
    init(original: SectionOfCustomData, items: [Item]) {
        self = original
        self.items = items
    }
}

class PublicLevelsViewController: UIViewController {
    @IBOutlet weak var publicLevelsCollectionView: UICollectionView!
    
    private let viewModel = PublicLevelsViewModel()
    private let disposeBag = DisposeBag()
    
    private var minimumLineSpacing:      Int = 5;
    private var minimumInteritemSpacing: Int = 5;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupCollectionViewTap()
        passDataToViewModel()
        setupCollectionView()
        setupCollectionViewBinding()
    }
    
    private func passDataToViewModel() {
        LevelsRepository.shared.dataSource
            .subscribe({ev in
                self.viewModel.input.listOfLevels.onNext(ev.element!)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func setupCollectionView() {
        self.publicLevelsCollectionView.delegate = nil
        self.publicLevelsCollectionView.dataSource = nil
    }
    
    private func setupCollectionViewBinding() {
        
        let ds = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Double>>(configureCell: { (ds, cv, indexPath, element)-> UICollectionViewCell in
            let cell = cv.dequeueReusableCell(withReuseIdentifier: "PublicLevelCell", for: indexPath) as! PublicLevelCell
            cell.setProperties(levelName: "\(element) @ row \(indexPath.row)")
            return cell
        }, configureSupplementaryView: { (ds, cv, element, indexPath) -> UICollectionReusableView in
            let cell = cv.dequeueReusableSupplementaryView(ofKind: element, withReuseIdentifier: "PublicHeaderCell", for: indexPath) as! PublicHeaderCell
            cell.setProperties(chapterName: ds[indexPath.section].model)
            return cell
        })
    
        
        let items = Observable.just([
            SectionModel(model: "First section", items: [
                1.0,
                2.0,
                3.0,
                4.0,
                5.0
                ]),
            SectionModel(model: "Second section", items: [
                1.0,
                2.0,
                3.0
                ]),
            SectionModel(model: "Third section", items: [
                1.0,
                2.0,
                3.0
                ])
            ])
        
            items
            .bind(to: publicLevelsCollectionView.rx.items(dataSource: ds))
            .disposed(by: disposeBag)
        

        publicLevelsCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func setupCollectionViewTap() {
        self.publicLevelsCollectionView.rx
            .anyGesture(.tap())
            .when(.recognized)
            .subscribe(onNext: { gesture in
                if let index = self.publicLevelsCollectionView!.indexPathForItem(at: gesture.location(in: self.publicLevelsCollectionView)) {
                    print("Clicked on: ", index.row)
                }
            })
            .disposed(by: self.disposeBag)
    }

}


extension PublicLevelsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var sz = CGSize(width:  collectionView.frame.width / CGFloat(2) - CGFloat(minimumInteritemSpacing),
                        height: collectionView.frame.width / CGFloat(2) - CGFloat(minimumInteritemSpacing))

        return sz
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(minimumLineSpacing)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(minimumInteritemSpacing)
    }
}