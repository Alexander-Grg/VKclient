//
//  NewsTableViewCellVideo.swift
//  VKclient
//
//  Created by Alexander Grigoryev on 11/12/24.
//  Copyright © 2024–2025 Alexander Grigoryev. All rights reserved.
//

import UIKit
import WebKit

final class FeedTableViewCellVideo: UITableViewCell {

    private var webView: WKWebView = {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .black
        return webView
    }()

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

    private var videoURL: URL?

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
        webView.frame = videoContainerView.bounds
    }

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

        videoContainerView.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: videoContainerView.topAnchor),
            webView.bottomAnchor.constraint(equalTo: videoContainerView.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: videoContainerView.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: videoContainerView.trailingAnchor)
        ])

        webView.isHidden = true
    }

    func configure(_ video: VideoItem?) {
        guard let playerURLString = video?.player,
              let url = URL(string: playerURLString) else {
            print("No video URL found for news item.")
            cleanupWebView()
            return
        }

        self.videoURL = url

        if let imageUrl = video?.image.last?.url,
           let url = URL(string: imageUrl) {
            loadImage(from: url)
        }

        cleanupWebView()
    }

    @objc private func didTapPlayButton() {
        guard let url = videoURL else { return }

        thumbnailImageView.isHidden = true
        playButton.isHidden = true
        webView.isHidden = false

        let request = URLRequest(url: url)
        webView.load(request)
    }

    private func cleanupWebView() {
        webView.stopLoading()
        webView.loadHTMLString("", baseURL: nil)
        webView.isHidden = true
        thumbnailImageView.isHidden = false
        playButton.isHidden = false
    }

    private func loadImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.thumbnailImageView.image = image
                    self.thumbnailImageView.isHidden = false
                }
            } else {
                DispatchQueue.main.async {
                    self.thumbnailImageView.image = UIImage(named: "video_placeholder")
                }
                print("Error loading thumbnail image from URL: \(url.absoluteString)")
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.thumbnailImageView.image = nil
        cleanupWebView()
    }
}

extension FeedTableViewCellVideo: ReusableView {
    static var identifier: String {
        return String(describing: self)
    }
}
