//
//  ViewController.swift
//  TripCards
//
//  Created by Adnann Muratovic on 06.09.21.
//

import UIKit

class TripViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var trips = [
        Trip(tripID: "Paris001",
             city: "Paris",
             country: "France",
             featureImage: UIImage(named: "paris"),
             price: 200,
             totalDays: 5,
             isLiked: false),
        Trip(tripID: "Instablu001",
             city: "Instanbul",
             country: "Turkey",
             featureImage: UIImage(named: "istanbul"),
             price: 999,
             totalDays: 10,
             isLiked: false),
        Trip(tripID: "London001",
             city: "London",
             country: "United Kingdom",
             featureImage: UIImage(named: "london"),
             price: 699,
             totalDays: 4,
             isLiked: false),
        Trip(tripID: "Rome001",
             city: "Rome",
             country: "Italy",
             featureImage: UIImage(named: "rome"),
             price: 299,
             totalDays: 6,
             isLiked: false),
        Trip(tripID: "Syndney001",
             city: "Syndney",
             country: "Austalia",
             featureImage: UIImage(named: "sydney"),
             price: 2999,
             totalDays: 11,
             isLiked: false),
        Trip(tripID: "Zurich001",
             city: "Zurich",
             country: "Switzerland",
             featureImage: UIImage(named: "zurich"),
             price: 1099,
             totalDays: 8,
             isLiked: false),
        Trip(tripID: "NewYork001",
             city: "New York",
             country: "United States",
             featureImage: UIImage(named: "newyork"),
             price: 3499,
             totalDays: 14,
             isLiked: false),
        Trip(tripID: "Santorini001",
             city: "Santorini",
             country: "Greece",
             featureImage: UIImage(named: "santorini"),
             price: 1099,
             totalDays: 8,
             isLiked: false),
    ]
    
    enum Section {
        case all
    }
    
    lazy var dataSource = configureDataSource()
    
    // MARK: - ViewLifeCycel
    override func viewDidLoad() {
        super.viewDidLoad()
        addBlurImage()
        
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
        collectionView.backgroundColor = .clear
        
        updateSnapshot()
    }
    
}

// MARK: - Blur backgorundImage
extension TripViewController {
    private func addBlurImage() {
        backgroundImageView.image = UIImage(named: "cloud")
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
    }
}

// MARK: - TableView DataSource
extension TripViewController {
    func configureDataSource() -> UICollectionViewDiffableDataSource<Section, Trip> {
        let dataSource = UICollectionViewDiffableDataSource<Section,Trip>(collectionView: collectionView) {
            (collectionView, indexPath, imageName) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TripCollectionViewCell
            
            cell.delegate = self
            
            if let trip = self.dataSource.itemIdentifier(for: indexPath) {
                cell.cityLabel.text = trip.city
                cell.countryLabel.text = trip.country
                cell.daysLabel.text = "\(trip.totalDays) Days"
                cell.priceLabel.text = "\(trip.price)$"
                cell.imageView.image = trip.featureImage
            }
            
            // Add rounded corner
            cell.layer.cornerRadius = 20.0
            return cell
        }
        
        return dataSource
    }
    
    func updateSnapshot(animatingChange: Bool = false) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Trip>()
        snapshot.appendSections([.all])
        snapshot.appendItems(trips, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    // MARK: - Layout
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 20,
                                                     leading: 20,
                                                     bottom: 20,
                                                     trailing: 20)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

// MARK: - Like Button
extension TripViewController: TripCollectionViewCellDelegate {
    func didTapLikeButton(cell: TripCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            trips[indexPath.row].isLiked = trips[indexPath.row].isLiked ? false : true
            cell.isLiked = trips[indexPath.row].isLiked
            
        }
    }
}
