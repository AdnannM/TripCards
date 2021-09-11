//
//  ViewController.swift
//  TripCards
//
//  Created by Adnann Muratovic on 06.09.21.
//

import UIKit
import Parse
import ViewAnimator

class TripViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var trips = [Trip]()
    
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
        loadTripFromParse()
    }
    
    // AnimateView
    private func animateView() {
        let animations: [Animation] = [
                   AnimationType.from(direction: .bottom, offset: 300),
                   AnimationType.rotate(angle: .pi / 4),
                   AnimationType.zoom(scale: 3)
            ]
        UIView.animate(views: collectionView.visibleCells, animations: animations, duration: 1)
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
                cell.daysLabel.text = "\(trip.numberOfDays) Days"
                cell.priceLabel.text = "\(trip.price)$"
                
                // Load Image in Background
                cell.imageView.image = UIImage()
                if let featuredImage = trip.featuredImage {
                    featuredImage.getDataInBackground { imageData, error in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        
                        if let tripImageData = imageData {
                            cell.imageView.image = UIImage(data: tripImageData)
                        }
                    }
                }
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
        section.orthogonalScrollingBehavior = .paging
        
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
            
            // Update date Parse
            trips[indexPath.row].toPFObject().saveInBackground { success, error in
                if (success) {
                    print("Successefully update the Trip")
                } else {
                    print("Error: \(error?.localizedDescription ?? "Unknow error")")
                }
            }
        }
    }
    
    func didTapTrashButton(cell: TripCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        
        guard let selectedTrip = self.dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        // Delete Trip
        trips[indexPath.row].toPFObject().deleteInBackground { success, error in
            if (success) {
                var snapshot = self.dataSource.snapshot()
                snapshot.deleteItems([selectedTrip])
                self.dataSource.apply(snapshot)
            } else {
                print("Error: \(error?.localizedDescription ?? "Unknow error")")
                return
            }
        }
    }
}

// MARK: - Load Parse Items
extension TripViewController {
    func loadTripFromParse() {
        // Clear array
        trips.removeAll(keepingCapacity: true)
        
        // Pull data from Parse
        let query = PFQuery(className: "Trip")
        // Chache Image
        query.cachePolicy = PFCachePolicy.cacheElseNetwork
        query.findObjectsInBackground { (objects, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let objects = objects {
                objects.forEach { object in
                    // Convert PFObject into Trip object
                    let trip = Trip(pfObject: object)
                    self.trips.append(trip)
                }
            }
            self.updateSnapshot()
        }
    }
}

// MARK: - Refresh Parse
extension TripViewController {
    @IBAction func reloadButtonPressed(sender: Any) {
        loadTripFromParse()
    }
}
