//
//  NewsTableViewCellVideo.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 11/12/24.
//

import UIKit
import AVFoundation

class NewsTableViewCellVideo: UITableViewCell {

    // MARK: - Properties
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "video_placeholder")
        return imageView
    }()

    private lazy var videoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.clipsToBounds = true
        return view
    }()

    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.setTitle("▶︎", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = videoContainerView.bounds
    }

    // MARK: - Setup

    private func setupView() {
        self.selectionStyle = .none
        contentView.addSubview(videoContainerView)
        videoContainerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            videoContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            videoContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            videoContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            videoContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])

        videoContainerView.addSubview(thumbnailImageView)
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: videoContainerView.topAnchor),
            thumbnailImageView.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor),
            thumbnailImageView.leadingAnchor.constraint(equalTo: videoContainerView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: videoContainerView.trailingAnchor)
        ])

        videoContainerView.addSubview(playButton)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            playButton.centerXAnchor.constraint(equalTo: videoContainerView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: videoContainerView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 50),
            playButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Configuration

    func configure(_ news: News) {
        guard let videoURL = news.attachmentVideoUrl else {
            print("No video URL found for news item.")
            cleanupPlayer()
            return
        }

        generateThumbnail(from: videoURL)

        cleanupPlayer()
        let player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill

        videoContainerView.layer.insertSublayer(playerLayer, below: playButton.layer)
        self.player = player
        self.playerLayer = playerLayer
        playerLayer.frame = videoContainerView.bounds
    }

    // MARK: - Actions
    @objc private func didTapPlayButton() {
        guard let player = player else { return }

        if player.timeControlStatus == .playing {
            player.pause()
            playButton.setTitle("▶︎", for: .normal)
        } else {
            thumbnailImageView.isHidden = true
            playButton.isHidden = true
            player.play()
        }
    }

    // MARK: - Helper Methods
    private func cleanupPlayer() {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
        thumbnailImageView.isHidden = false
        playButton.isHidden = false
    }

    private func generateThumbnail(from url: URL) {
        DispatchQueue.global().async {
            let asset = AVAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true

            do {
                let cgImage = try imageGenerator.copyCGImage(at: .zero, actualTime: nil)
                let image = UIImage(cgImage: cgImage)

                DispatchQueue.main.async {
                    self.thumbnailImageView.image = image
                    self.thumbnailImageView.isHidden = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.thumbnailImageView.image = UIImage(named: "video_placeholder")
                }
                print("Error generating thumbnail: \(error.localizedDescription)")
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cleanupPlayer()
    }
}

extension NewsTableViewCellVideo: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
