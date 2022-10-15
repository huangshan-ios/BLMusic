//
//  SongListViewController.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import UIKit

class SongListViewController: ViewControllerType<SongListViewModel, SongListCoordinator> {
    
    @IBOutlet weak var listSongTableView: UITableView!
    
    private lazy var tableHeaderView: UIView = {
        let view = UIView()
        view.frame = .zero
        return view
    }()
    
    private lazy var tableFooterView: UIView = {
        let view = UIView()
        view.frame = .zero
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadNewSongs()
    }
    
    override func setupViews() {
        title = "New Songs"
        
        let cellNib = UINib(nibName: SongTableViewCell.className, bundle: nil)
        listSongTableView.register(cellNib, forCellReuseIdentifier: SongTableViewCell.className)
        
        listSongTableView.tableHeaderView = tableHeaderView
        listSongTableView.tableFooterView = tableFooterView
        
        listSongTableView.delegate = self
        listSongTableView.dataSource = self
    }
    
    override func setupBindings() {
        viewModel.errorObservable = { [weak self] error in
            guard let self = self else {
                return
            }
            self.handleError(error: error)
        }
        
        viewModel.loadingObservable = { [weak self] isLoading in
            guard let self = self else {
                return
            }
            self.showIndicator(isLoading)
        }
        
        viewModel.loadSongsObservable = { [weak self] in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.listSongTableView.reloadData()
            }
        }
        
        viewModel.songStateObservable = { [weak self] index in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                if self.listSongTableView.indexPathsForVisibleRows?.contains(IndexPath(row: index, section: 0)) ?? false {
                    self.listSongTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
                }
            }
        }
        
        
    }

}

extension SongListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getSongs().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let songTableViewCell = tableView.dequeueReusableCell(withIdentifier: SongTableViewCell.className, for: indexPath) as? SongTableViewCell else {
            return UITableViewCell()
        }
        songTableViewCell.setupSongView(viewModel.getSongs()[indexPath.row])
        songTableViewCell.onTapActionButton = { [weak self] state in
            guard let self = self else {
                return
            }
            switch state {
            case .inCloud:
                self.viewModel.downloadSong(at: indexPath.row)
            case .ready:
                self.viewModel.playSong(at: indexPath.row)
            case .playing:
                self.viewModel.stopPlay(at: indexPath.row)
            default: break
            }
        }
        return songTableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
