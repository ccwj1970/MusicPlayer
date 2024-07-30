//
//  Third.swift
//  MusicPlayer
//
//  Created by 紀韋如 on 20/07/2024.
//



import UIKit
import AVFoundation
class Third: UIViewController {
 
    // 連接界面上的 UIImageView，用於顯示專輯封面
    @IBOutlet weak var imageView: UIImageView!
    // 連接界面上的 UILabel，用於顯示音樂名稱
    @IBOutlet weak var musicName: UILabel!
    // 連接界面上的 UILabel，用於顯示歌手名稱
    @IBOutlet weak var singerName: UILabel!
    // 連接界面上的 UISlider，用於顯示和控制音樂播放進度
    @IBOutlet weak var playTimeSlider: UISlider!
    // 連接界面上的 UILabel，用於顯示音樂開始播放的時間
    @IBOutlet weak var startTime: UILabel!
    // 連接界面上的 UILabel，用於顯示音樂結束的時間
    @IBOutlet weak var endTime: UILabel!
    // 連接界面上的 UIButton，用於控制播放上一首音樂
    @IBOutlet weak var backButton: UIButton!
    // 連接界面上的 UIButton，用於控制播放下一首音樂
    @IBOutlet weak var nextButton: UIButton!
    // 連接界面上的 UIButton，用於控制暫停和播放音樂
    @IBOutlet weak var pauseButton: UIButton!
    // 連接界面上的 UIButton，用於切換重複播放模式
    @IBOutlet weak var repeatButton: UIButton!
    // 連接界面上的 UIButton，用於切換隨機播放模式
    @IBOutlet weak var shuffleButton: UIButton!
    // 連接界面上的 UISlider，用於調節音量
    @IBOutlet weak var volumeSlider: UISlider!
    
    // 定義播放器，用於播放音樂
    let player = AVPlayer()
    // 定義播放器項目，用於保存當前播放的音樂
    var playerItem: AVPlayerItem!
    // 定義音頻資產，用於處理音樂文件
    var asset: AVAsset?
    // 定義當前播放音樂的索引，用於管理播放列表
    var playmusicIndex = 0
    // 定義音樂列表，用於保存所有音樂
    var musics = music()
    // 定義音樂索引，用於記錄當前播放的音樂
    var musicIndex = 0
    // 定義重複播放索引，用於管理重複播放模式
    var repeatIndex = 0
    // 定義重複播放狀態，用於指示是否啟用了重複播放
    var repeatBool = false
    // 定義隨機播放索引，用於管理隨機播放模式
    var shuffleIndex = 0
    
    // 覆寫 viewDidLoad 方法，當視圖載入後會被調用
    override func viewDidLoad() {
        // 調用父類別的 viewDidLoad 方法
        super.viewDidLoad()
        
        // 設置漸層背景
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 40/255, green: 52/255, blue: 89/255, alpha: 0.8).cgColor,
            UIColor(red: 50/255, green: 42/255, blue: 46/255, alpha: 1.0).cgColor,
        ]
        
        // 將背景放置到視圖後面
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // 初始化 UI 並開始播放第一首歌曲
        playMusic()
        updateUI()
        nowPlayTime()
        updateMusicUI()
        musicEnd()
    }
    
    // 切換重複播放狀態
    @IBAction func repeatButton(_ sender: UIButton) {
        // 每次點擊按鈕，重複播放索引增加1
        repeatIndex += 1
        // 如果重複播放索引等於1，表示開啟重複播放模式
        if repeatIndex == 1 {
            // 設置按鈕圖標為單曲重複
            repeatButton.setImage(setbuttonImage(systemName: "repeat.1", pointSize: 15), for: .normal)
            // 設置重複播放狀態為 true
            repeatBool = true
        } else {
            // 如果重複播放索引不等於1，表示關閉重複播放模式
            // 重置重複播放索引為0
            repeatIndex = 0
            // 設置按鈕圖標為循環播放
            repeatButton.setImage(setbuttonImage(systemName: "repeat", pointSize: 15), for: .normal)
            // 設置重複播放狀態為 false
            repeatBool = false
        }
    }
    
    // 切換隨機播放狀態
    @IBAction func shuffleButton(_ sender: Any) {
        // 每次點擊按鈕，隨機播放索引增加1
        shuffleIndex += 1
        // 如果隨機播放索引等於1，表示開啟隨機播放模式
        if shuffleIndex == 1 {
            // 設置按鈕圖標為已填充的隨機播放
            shuffleButton.setImage(setbuttonImage(systemName: "shuffle.circle.fill", pointSize: 20), for: .normal)
            print("musicIndex\(musicIndex)")
            print("allmusic.count\(allmusic.count)")
        } else {
            // 如果隨機播放索引不等於1，表示關閉隨機播放模式
            // 重置隨機播放索引為0
            shuffleIndex = 0
            // 設置按鈕圖標為隨機播放
            shuffleButton.setImage(setbuttonImage(systemName: "shuffle", pointSize: 15), for: .normal)
        }
    }
    
    // 暫停或播放音樂
    @IBAction func stopButton(_ sender: UIButton) {
        // 每次點擊按鈕，播放音樂索引增加1
        playmusicIndex += 1
        // 如果播放音樂索引等於1，表示暫停播放
        if playmusicIndex == 1 {
            // 暫停播放器
            player.pause()
            // 設置按鈕圖標為播放按鈕
            pauseButton.setImage(setbuttonImage(systemName: "play.fill", pointSize: 30), for: .normal)
            // 設置按鈕背景顏色
            pauseButton.tintColor = UIColor(red: 47/255.0, green: 47/255.0, blue: 59/255.0, alpha: 1.0)
        } else {
            // 如果播放音樂索引不等於1，表示恢復播放
            // 播放播放器
            player.play()
            // 重置播放音樂索引為0
            playmusicIndex = 0
            // 設置按鈕圖標為暫停按鈕
            pauseButton.setImage(setbuttonImage(systemName: "pause.fill", pointSize: 30), for: .normal)
            // 設置按鈕背景顏色
            pauseButton.tintColor = UIColor(red: 47/255.0, green: 47/255.0, blue: 59/255.0, alpha: 1.0)
        }
    }
    
    // 播放下一首音樂
    @IBAction func nextSoundButton(_ sender: UIButton) {
        // 調用播放下一首音樂的函數
        playNextSound()
        // 設置按鈕圖標為暫停按鈕
        pauseButton.setImage(setbuttonImage(systemName: "pause.fill", pointSize: 30), for: .normal)
        // 設置按鈕背景顏色
        pauseButton.tintColor = UIColor(red: 47/255.0, green: 47/255.0, blue: 59/255.0, alpha: 1.0)
    }
    
    // 播放上一首音樂
    @IBAction func backSoundButton(_ sender: UIButton) {
        // 調用播放上一首音樂的函數
        backSound()
        // 設置按鈕圖標為暫停按鈕
        pauseButton.setImage(setbuttonImage(systemName: "pause.fill", pointSize: 30), for: .normal)
        // 設置按鈕背景顏色
        pauseButton.tintColor = UIColor(red: 47/255.0, green: 47/255.0, blue: 59/255.0, alpha: 1.0)
    }
    
    // 調節音量
    @IBAction func volumeChange(_ sender: UISlider) {
        // 設置播放器的音量為音量滑桿的值
        player.volume = volumeSlider.value
    }
    
    // 拖動播放進度條
    @IBAction func timeChage(_ sender: UISlider) {
        // 設置改變時間為滑桿的值
        let changeTime = Int64(sender.value)
        // 創建 CMTime 來控制音樂播放到的位置
        let time: CMTime = CMTimeMake(value: changeTime, timescale: 1)
        // 將播放器的播放時間設置為滑桿拖動到的位置
        player.seek(to: time)
        print("sender.value\(sender.value)")
        print("sender.maximumValue\(sender.maximumValue)")
    }
    
    // 更新歌曲、歌手、畫面圖片
    func updateUI() {
        // 設置音樂名稱標籤的文字為當前播放的音樂名稱
        musicName.text = allmusic[musicIndex].musicName
        // 設置歌手名稱標籤的文字為當前播放的歌手名稱
        singerName.text = allmusic[musicIndex].singer
        // 設置圖片視圖的圖片為當前播放的專輯封面
        imageView.image = UIImage(named: allmusic[musicIndex].musicPic)
    }
    
    // 更新歌曲時確認歌的時間讓 Slider 也更新
    func updateMusicUI() {
        // 獲取播放器項目的資產持續時間
        guard let timeduration = playerItem?.asset.duration else {
            return
        }
        // 將持續時間轉換為秒數
        let seconds = CMTimeGetSeconds(timeduration)
        // 設置結束時間標籤的文字為轉換後的秒數
        endTime.text = timeShow(time: seconds)
        // 設置播放進度滑桿的最小值為0
        playTimeSlider.minimumValue = 0
        // 設置播放進度滑桿的最大值為歌曲的總秒數
        playTimeSlider.maximumValue = Float(seconds)
        // 設置播放進度滑桿為可連續拖動
        playTimeSlider.isContinuous = true
        print("second:\(seconds)")
    }
    
    // 顯示播放時間
    func timeShow(time: Double) -> String {
        // 將時間轉換為分鐘和秒數
        let time = Int(time).quotientAndRemainder(dividingBy: 60)
        // 返回格式化的時間字符串
        let timeString = ("\(String(time.quotient)) : \(String(format:"%02d", time.remainder))")
        return timeString
    }
    
    // 播放當前時間
    func nowPlayTime() {
        // 添加時間觀察者，每秒調用一次
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main, using: { (CMTime) in
            // 如果播放器準備就緒
            if self.player.currentItem?.status == .readyToPlay {
                // 獲取播放器的當前播放時間
                let currenTime = CMTimeGetSeconds(self.player.currentTime())
                // 設置播放進度滑桿的值為當前播放時間
                self.playTimeSlider.value = Float(currenTime)
                // 設置開始時間標籤的文字為當前播放時間
                self.startTime.text = self.timeShow(time: currenTime)
            }
        })
    }
    
    // 確認音樂結束
    func musicEnd() {
        // 添加通知觀察者，監聽音樂播放結束事件
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { (_) in
            // 如果重複播放狀態為 true
            if self.repeatBool {
                // 將播放器的播放時間設置為0，從頭開始播放
                let musicEndTime: CMTime = CMTimeMake(value: 0, timescale: 1)
                self.player.seek(to: musicEndTime)
                self.player.play()
            } else {
                // 否則播放下一首音樂
                self.playNextSound()
            }
        }
    }
    
    // 播放音樂
    func playMusic() {
        // 獲取音樂文件的路徑
        guard let fileUrl = Bundle.main.url(forResource: allmusic[musicIndex].music, withExtension: "mp3") else {
            print("音樂檔案未找到")
            return
        }
        // 創建播放器項目，保存播放的音樂
        playerItem = AVPlayerItem(url: fileUrl)
        // 將播放器的當前項目替換為新的播放器項目
        player.replaceCurrentItem(with: playerItem)
        // 播放音樂
        player.play()
    }
    
    // 設定按鈕圖示大小與圖案
    func setbuttonImage(systemName: String, pointSize: Int) -> UIImage? {
        // 創建圖標配置，設置大小和比例
        let sfsymbol = UIImage.SymbolConfiguration(pointSize: CGFloat(pointSize), weight: .bold, scale: .large)
        // 創建圖標圖片，使用系統圖標名稱和配置
        let sfsymbolImage = UIImage(systemName: systemName, withConfiguration: sfsymbol)
        // 返回圖標圖片
        return sfsymbolImage
    }
    
    // 類屬性
    var playedIndices: [Int] = []
    var previousIndex: Int? = nil

    // 隨機播放下一首歌
    func playNextSound() {
        // 如果隨機播放模式開啟
        if shuffleIndex == 1 {
            // 如果所有歌曲都已播放過，重置播放記錄
            if playedIndices.count == allmusic.count {
                playedIndices.removeAll()
            }

            var nextIndex: Int
            repeat {
                nextIndex = Int.random(in: 0..<allmusic.count)
            } while nextIndex == musicIndex || nextIndex == previousIndex || playedIndices.contains(nextIndex)

            playedIndices.append(nextIndex)
            previousIndex = musicIndex
            musicIndex = nextIndex

            updateUI()
            playMusic()
            updateMusicUI()
        } else {
            musicIndex += 1
            if musicIndex < allmusic.count {
                updateUI()
                playMusic()
                updateMusicUI()
            } else {
                musicIndex = 0
                updateUI()
                playMusic()
                updateMusicUI()
            }
        }
    }
    
    // 隨機播放上一首歌
    func backSound() {
        // 如果隨機播放模式開啟
        if shuffleIndex == 1 {
            // 如果所有歌曲都已播放過，重置播放記錄
            if playedIndices.count == allmusic.count {
                playedIndices.removeAll()
            }

            var nextIndex: Int
            repeat {
                nextIndex = Int.random(in: 0..<allmusic.count)
            } while nextIndex == musicIndex || nextIndex == previousIndex || playedIndices.contains(nextIndex)

            playedIndices.append(nextIndex)
            previousIndex = musicIndex
            musicIndex = nextIndex

            updateUI()
            playMusic()
            updateMusicUI()
        } else {
            musicIndex -= 1
            if musicIndex >= 0 {
                updateUI()
                playMusic()
                updateMusicUI()
            } else {
                musicIndex = allmusic.count - 1
                updateUI()
                playMusic()
                updateMusicUI()
            }
        }
    }
}
