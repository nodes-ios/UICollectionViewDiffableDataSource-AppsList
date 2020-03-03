//
//  AppsPresenter.swift
//  AppsList
//
//  Created by Bob De Kort on 28/02/2020.
//  Copyright © 2020 Nodes. All rights reserved.
//

import UIKit

class AppsPresenter {
    // MARK: - Properties -
    // The below 2 properties contain all the data used in the app.
    // The sections are the apps that are shown when launch and the other apps
    // are the ones you can add.
    // Of course in a real app this will be setup with a changing data set to keep the state between launches
    let otherApps = Bundle.main.decode([App].self, from: "otherApps.json")
    let sections = Bundle.main.decode([Section].self, from: "installedApps.json")
    
    // This is the main point for the tutorial and will be the base of the information shown in the collection view
    var dataSource: UICollectionViewDiffableDataSource<Section, App>?
    var isModifying: Bool = false
    
    // MARK: - Life cycle -
    func viewCreated(with collectionView: UICollectionView) {
        createDataSource(for: collectionView)
        reloadData()
    }
    
    // MARK: - Public methods -
    
    /// This methods deletes the item present at the given index path
    func deleteApp(at indexPath: IndexPath) {
        
    }
    
    /// This method adds the given app to the collection view in the last position
    func add(app: App) {
        
    }
    
    /// This method will move an app in the collection view when using the Drag and Drop functionality
    func moveApp(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        
    }
    
    /// This is a convenience method that will reset the collection view to its initial setup
    func resetToInitialData(in collectionView: UICollectionView) {
        createDataSource(for: collectionView)
        reloadData()
    }
    
    /// This is a convenience method that will return the app associated with the given indexpath, if available
    func item(at indexPath: IndexPath) -> App? {
        return dataSource?.itemIdentifier(for: indexPath)
    }
    
    // MARK: - Private methods -
    
    /// This method sets up the inital data source
    private func createDataSource(for collectionView: UICollectionView) {
        
    }

    
    /// Reloads the inital data into the data source
    private func reloadData() {
        
    }
}
