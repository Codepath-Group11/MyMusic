//
//  ViewController.swift
//  InteractivePlayerView
//
//  Created by AhmetKeskin on 02/09/15.
//  Copyright (c) 2015 Mobiwise. All rights reserved.
//

import UIKit
import Spartan

class MusicPlayerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var ipv: InteractivePlayerView!
     @IBOutlet weak var blurBgImage: UIImageView!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var playPauseButtonView: UIView!
    
    var userID: String?
    var playlistID: String?
    var playlistType: String?
    var isReplaying: Bool = false
    
    var playlistTracks:[PlaylistTrack]?
    var copyPlaylistTracks:[PlaylistTrack]?
    var shuffledPlaylistTracks:[PlaylistTrack]?
    
    var currentSongIndex: Int = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.layoutIfNeeded()
        self.view.backgroundColor = UIColor.clear
        self.makeItRounded(view: self.playPauseButtonView, newSize: self.playPauseButtonView.frame.width)

        self.ipv!.delegate = self
        
        // duration of music
        self.ipv.progress = 20.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissPlaylist(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "UnwindSegue", sender: self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func loadSongFromURI(uri: String){
        let duration = (playlistTracks?[currentSongIndex].track.durationMs)!/1000

        MusicClient.player().playSpotifyURI(uri, startingWith: 0, startingWithPosition: 0, callback: nil)
        playButton.isHidden = true
        pauseButton.isHidden = false
        
        ipv.restartWithProgress(duration: Double(duration))
    }
    
    func changePlayPause(){
        if playButton.isHidden{
            playButton.isHidden = false
            pauseButton.isHidden = true
        }else{
            playButton.isHidden = true
            pauseButton.isHidden = false
        }
    }
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
            ipv.start()
            MusicClient.player().setIsPlaying(true, callback: nil)
            changePlayPause()
        
    }

    @IBAction func pauseButtonTapped(_ sender: UIButton) {
            ipv.stop()
            MusicClient.player().setIsPlaying(false, callback: nil)
            changePlayPause()
        
    }
    
    
    @IBAction func nextTapped(sender: AnyObject) {
        var trackURI = ""
        if playlistTracks != nil,  (currentSongIndex+1) < (playlistTracks?.count)!{
            currentSongIndex += 1
            
            trackURI = (playlistTracks?[currentSongIndex].track.uri)!
            
            loadSongFromURI(uri: trackURI)
            ipv.stop()
        }
    }
    
    @IBAction func previousTapped(sender: AnyObject) {
        var trackURI = ""
        if playlistTracks != nil, (currentSongIndex-1) > -1{
            currentSongIndex -= 1
            
            trackURI = (playlistTracks?[currentSongIndex].track.uri)!
            
            loadSongFromURI(uri: trackURI)
            ipv.stop()
        }
    }
    
    func makeItRounded(view : UIView!, newSize : CGFloat!){
        let saveCenter : CGPoint = view.center
        let newFrame : CGRect = CGRect(x: view.frame.origin.x,y: view.frame.origin.y,width: newSize,height : newSize)
        view.frame = newFrame
        view.layer.cornerRadius = newSize / 2.0
        view.clipsToBounds = true
        view.center = saveCenter
        
    }
    
    //MARK: tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if playlistTracks?.count != nil{
            return (playlistTracks?.count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let trackURI = playlistTracks?[indexPath.row].track.uri
        currentSongIndex = indexPath.row
        
        if trackURI != nil{
            loadSongFromURI(uri: trackURI!)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell") as! TrackCell
        
        let track = playlistTracks?[indexPath.row].track
        
        cell.textLabel?.text = track?.name
        cell.detailTextLabel?.text = track?.artists[0].name
        
        return cell
    }
    
}

extension MusicPlayerViewController: InteractivePlayerViewDelegate{
    
    /* InteractivePlayerViewDelegate METHODS */
    func actionOneButtonTapped(sender: UIButton, isSelected: Bool) {
        if isSelected{
            copyPlaylistTracks = playlistTracks
            
            shuffledPlaylistTracks = copyPlaylistTracks
            shuffledPlaylistTracks?.shuffle()
            
            playlistTracks = shuffledPlaylistTracks
            tableView.reloadData()
        }else{
            shuffledPlaylistTracks = []
            playlistTracks = copyPlaylistTracks
            tableView.reloadData()
        }
        
    }
    
    func actionTwoButtonTapped(sender: UIButton, isSelected: Bool) {
        print("like \(isSelected.description)")
    }
    
    func actionThreeButtonTapped(sender: UIButton, isSelected: Bool) {
        isReplaying = isSelected
        
    }
    
    func interactivePlayerViewDidChangedDuration(playerInteractive: InteractivePlayerView, currentDuration: Double) {
        let currentRoundedDuration = Int(currentDuration)
        let songTotalDuration = (playlistTracks?[currentSongIndex].track.durationMs)!/1000

        if currentRoundedDuration == songTotalDuration{
            if !isReplaying{
                currentSongIndex += 1
            }
            
            let trackURI = playlistTracks?[currentSongIndex].track.uri
            loadSongFromURI(uri: trackURI!)
        }
    }
    
    func interactivePlayerViewDidStartPlaying(playerInteractive: InteractivePlayerView) {
        print("interactive player did started")
    }
    
    func interactivePlayerViewDidStopPlaying(playerInteractive: InteractivePlayerView) {
        print("interactive player did stop")
    }
    
}

extension MutableCollection where Indices.Iterator.Element == Index {
    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled , unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            guard d != 0 else { continue }
            let i = index(firstUnshuffled, offsetBy: d)
            swap(&self[firstUnshuffled], &self[i])
        }
    }
}
