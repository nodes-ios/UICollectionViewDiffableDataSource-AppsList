//
//  ViewController.swift
//  AppsList
//
//  Created by Bob De Kort on 28/02/2020.
//  Copyright © 2020 Nodes. All rights reserved.
//

import UIKit

class AppsViewController: UIViewController {
    
    // MARK: - Properties -
    // The presenter will take care of all the data and data manipulation
    private var presenter: AppsPresenter = AppsPresenter()
    // Some nav bar buttons to help editing and resetting
    private var addButton: UIBarButtonItem!
    private var deleteButton: UIBarButtonItem!
    private var doneButton: UIBarButtonItem!
    private var refreshButton: UIBarButtonItem!
    /// Helper property to reduce the use of presenter.
    var isModifying: Bool {
        get { return presenter.isModifying }
        set { presenter.isModifying = newValue }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavBarButtons()
        presenter.viewCreated(with: collectionView)
    }
    
    // MARK: - Setup methods -
    /// Configures the collection view
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dragInteractionEnabled = isModifying
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.backgroundColor = .clear
        collectionView.collectionViewLayout = createCompositionalLayout()
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        collectionView.register(AppCell.self, forCellWithReuseIdentifier: AppCell.identifier)
    }
    
    /// Adds the necessary nav bar buttons
    private func setupNavBarButtons() {
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPressed))
        deleteButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(deletePressed))
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        navigationItem.rightBarButtonItems = isModifying ? [addButton, doneButton] : [addButton, deleteButton]
        navigationItem.leftBarButtonItem = refreshButton
    }
    
    // MARK: - Callbacks -
    /// Displays the list of apps available to add
    @objc private func addPressed() {
        let vc = AddAppViewController.instantiate(with: presenter.otherApps)
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
    /// Sets the modifying state and updates the collection view and nav bar buttons appropriately
    @objc private func deletePressed() {
        isModifying = !isModifying
        for cell in collectionView.visibleCells {
            guard let cell = cell as? AppCell else { continue }
            cell.setIsEditing(isModifying)
        }
        
        collectionView.dragInteractionEnabled = isModifying
        
        navigationItem.rightBarButtonItems = isModifying ? [addButton, doneButton] : [addButton, deleteButton]
    }
    
    /// Only used to disable the modifying state
    @objc private func donePressed() {
        if isModifying {
            deletePressed()
        }
    }
    
    /// Reloads the initial data in the collection view
    @objc private func refresh() {
        if isModifying {
            deletePressed()
        }
        presenter.resetToInitialData(in: collectionView)
    }
    
    // MARK: - CollectionView layout -
    /// Sets up the layout for the collection view
    /// See the blog posts on UICollectionViewCompositionalLayout for details
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = self.presenter.sections[sectionIndex]
            return self.createGridSection(using: section)
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        return layout
    }
    
    /// Sets up a layout for a section
    /// See the blog posts on UICollectionViewCompositionalLayout for details
    func createGridSection(using section: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25),
                                              heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10,
                                                           bottom: 5, trailing: 10)
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                     heightDimension: .fractionalWidth(0.3))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize,
                                                             subitems: [layoutItem])
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        
        return layoutSection
    }
}

extension AppsViewController: UICollectionViewDelegate {
    /// I setup the deletion so you can just press on the app to delete and not use the delete button itself
    /// If you want to use the actual button have a look at the AddAppCell who implements the add button in a way you could use for the deletion as well
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isModifying {
            presenter.deleteApp(at: indexPath)
        }
    }
}

extension AppsViewController: AddAppViewControllerDelegate {
    /// Callback from the AddAppVC to add an app
    func add(_ app: App) {
        presenter.add(app: app)
    }
}

/// The drag and drop functionality was copied from a hacker noon article: https://medium.com/hackernoon/how-to-drag-drop-uicollectionview-cells-by-utilizing-dropdelegate-and-dragdelegate-6e3512327202
/// The only change is that we use the moveApp method in the presenter which uses the UICollectionViewDiffableDataSource
/// instead of modifying the collection view directly
extension AppsViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        guard let item = presenter.item(at: indexPath) else { return [] }
        let itemProvider = NSItemProvider(object: item.name as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}

extension AppsViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .forbidden)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        var destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath {
            destinationIndexPath = indexPath
        } else {
            let row = collectionView.numberOfItems(inSection: 0)
            destinationIndexPath = IndexPath(row: row - 1, section: 0)
        }
        
        if coordinator.proposal.operation == .move {
            presenter.moveApp(coordinator: coordinator,
                              destinationIndexPath: destinationIndexPath,
                              collectionView: collectionView)
        }
    }
}
