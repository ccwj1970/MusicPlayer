//
//  Third.swift
//  MusicPlayer
//
//  Created by 紀韋如 on 20/07/2024.
//


import UIKit
import AVFoundation

class Third: UIViewController {
    // 畫面設定
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var musicName: UILabel!
    @IBOutlet weak var singerName: UILabel!
    @IBOutlet weak var playTimeSlider: UISlider!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var repeatButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var volumeSlider: UISlider!
    
    
    let player = AVPlayer()
    var playerItem: AVPlayerItem!
    var asset: AVAsset?
    var playmusicIndex = 0
    var musics = music()
    var musicIndex = 0
    var repeatIndex = 0
    var repeatBool = false
    var shuffleIndex = 0
    
    override func viewDidLoad() {
        
        // 問題一：無法自動開始，第二首，無法迴轉到第一首（圖片對、音樂不對） (解決：檔名有問題)
        // 問題二：暫停按鈕，應該要取代後面那一個（加上背景），刪除預先設定，顏色變成白色
        // 問題三：音量沒有改變（大聲、小聲、大聲） 右邊設定問題
        // 問題四：排版 ok
        // 問題五：真的了解語法
        // shuffle never work 調整
        // repeat overlapping 調整
        // volumn is weird 調整
        // 跳下一首，符號自動變化 pause 調整
        
        
        
        
        
        super.viewDidLoad()
        
        // 設置漸層背景
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor(red: 40/255, green: 52/255, blue: 89/255, alpha: 0.8).cgColor,
            UIColor(red: 50/255, green: 42/255, blue: 46/255, alpha: 1.0).cgColor,
        ]
        
        // 背景放置後面
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        
        
        // 更新 UI 並開始播放第一首歌曲
        playMusic()
        updateUI()
        nowPlayTime()
        updateMusicUI()
        musicEnd()
        
    }
    
    // 重複播放
    @IBAction func repeatButton(_ sender: UIButton) {
        // 按一下＋1
        repeatIndex += 1
        //        等於1圖示就會改變
        if repeatIndex == 1 {
            repeatButton.setImage(setbuttonImage(systemName: "repeat.1", pointSize: 15), for: .normal)
            
            
            
            // 如果repeatBool = true 就會重複播放
            repeatBool = true
        }else{
            repeatIndex = 0
            repeatButton.setImage(setbuttonImage(systemName: "repeat", pointSize: 15), for: .normal)
            
            //            是false就不會重複播放
            repeatBool = false
        }
    }
    
    //    是否隨機播放
    @IBAction func shuffleButton(_ sender: Any) {
        //        按一下+1
        shuffleIndex += 1
        //        等於1時圖示就會變
        if shuffleIndex == 1{
            shuffleButton.setImage(setbuttonImage(systemName: "shuffle.circle.fill", pointSize: 20), for: .normal)
            print("musicIndex\(musicIndex)")
            print("allmusic.count\(allmusic.count)")
        }else{
            shuffleIndex = 0
            shuffleButton.setImage(setbuttonImage(systemName: "shuffle", pointSize: 15), for: .normal)
        }
    }
    
    
    
    
    
    //    音樂暫停播放
    @IBAction func stopButton(_ sender: UIButton) {
        //        按一下+1
        playmusicIndex += 1
        //        等於1音樂暫停圖示變成播放按鈕
        if playmusicIndex == 1{
            player.pause()
            pauseButton.setImage(setbuttonImage(systemName: "play.fill", pointSize: 30), for: .normal)
            pauseButton.tintColor = UIColor(red: 47/255.0, green: 47/255.0, blue: 59/255.0, alpha: 1.0)// 設置背景顏色
        }else{
            //            如果超過1就會歸0繼續播放按鈕換成暫停鍵
            player.play()
            playmusicIndex = 0
            pauseButton.setImage(setbuttonImage(systemName: "pause.fill", pointSize: 30), for: .normal)
            pauseButton.tintColor = UIColor(red: 47/255.0, green: 47/255.0, blue: 59/255.0, alpha: 1.0)// 設置背景顏色
            
        }
        
        //            pauseButton.tintColor = UIColor(red: 221/255.0, green: 176/255.0, blue: 238/255.0, alpha: 1.0) // 按鈕顏色
    }
    
    //    下一首
    @IBAction func nextSoundButton(_ sender: UIButton) {
        playNextSound()
        pauseButton.setImage(setbuttonImage(systemName: "pause.fill", pointSize: 30), for: .normal)
        pauseButton.tintColor = UIColor(red: 47/255.0, green: 47/255.0, blue: 59/255.0, alpha: 1.0)// 設置背景顏色
        
    }
    //    上一首
    @IBAction func backSoundButton(_ sender: UIButton) {
        backSound()
        pauseButton.setImage(setbuttonImage(systemName: "pause.fill", pointSize: 30), for: .normal)
        pauseButton.tintColor = UIColor(red: 47/255.0, green: 47/255.0, blue: 59/255.0, alpha: 1.0)// 設置背景顏色
    }
    //    調音量
    @IBAction func volumeChange(_ sender: UISlider) {
        player.volume = volumeSlider.value
    }
    
    
    //    拉Slider 音樂也會跟著動
    @IBAction func timeChage(_ sender: UISlider) {
        //        設定slider的value
        let changeTime = Int64(sender.value)
        //        宣告一個CMTime來控制音樂到跑到哪
        let time:CMTime = CMTimeMake(value: changeTime , timescale: 1)
        //        音樂會跟著slider拉到的地方播放
        player.seek(to: time)
        print("sender.value\(sender.value)")
        print("sender.maximumValue\(sender.maximumValue)")
    }
    
    //    更新歌曲、歌手、畫面圖片
    func updateUI(){
        musicName.text = allmusic[musicIndex].musicName
        singerName.text = allmusic[musicIndex].singer
        imageView.image = UIImage(named: allmusic[musicIndex].musicPic)
        //        starTimeLB.text = String(player.currentTime().seconds)
    }
    //    更新歌曲時確認歌的時間讓Slider也更新
    func updateMusicUI() {
        //        宣告一個算歌曲秒數的timeduration
        guard let timeduration = playerItem?.asset.duration else {
            return
        }
        //        在轉換型態成CMTimeGetSeconds
        let seconds = CMTimeGetSeconds(timeduration)
        //      總秒數就會等於timeShow(time: seconds)func裡的秒數
        endTime.text = timeShow(time: seconds)
        //        拉秒數的Slider最小值為0
        playTimeSlider.minimumValue = 0
        //        最大值就是這首歌的總秒數
        playTimeSlider.maximumValue = Float(seconds)
        //        slider會不會持續動作
        playTimeSlider.isContinuous = true
        print("second:\(seconds)")
    }
    //    顯示播放幾秒func
    func timeShow(time: Double) -> String {
        //        轉換成秒數
        let time = Int(time).quotientAndRemainder(dividingBy: 60)
        //        顯示分鐘與秒數
        let timeString = ("\(String(time.quotient)) : \(String(format:"%02d", time.remainder))")
        //        回傳到顯示
        return timeString
    }
    //    播放幾秒的Func
    func nowPlayTime(){
        //        播放的計數器從1開始每一秒都在播放
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main, using: { (CMTime) in
            //          如果音樂要播放
            if self.player.currentItem?.status == .readyToPlay{
                //                就會得到player播放的時間
                let currenTime = CMTimeGetSeconds(self.player.currentTime())
                //                Slider移動就會等於currenTime的時間
                self.playTimeSlider.value = Float(currenTime)
                //                顯示播放了幾秒
                self.startTime.text = self.timeShow(time: currenTime)
            }
        })
    }
    //    確認音樂結束
    func musicEnd(){
        //        叫出  NotificationCenter.default.addObserver來確認音樂是否結束
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { (_) in
            //            如果結束有打開repeatBool 就會從頭播放
            if self.repeatBool{
                let musicEndTime: CMTime = CMTimeMake(value: 0, timescale: 1)
                self.player.seek(to: musicEndTime)
                self.player.play()
            }else{
                //            如果結束沒有打開repeatBool就會撥下一首歌
                self.playNextSound()
                
            }
            
        }
    }
    //    播放音樂
    func playMusic() {
        // 宣告一個 fileUrl 來獲取音樂檔案的路徑
        guard let fileUrl = Bundle.main.url(forResource: allmusic[musicIndex].music, withExtension: "mp3") else {
            print("音樂檔案未找到")
            return
        }
        
        // 創建一個 AVPlayerItem 來保存播放的音樂
        playerItem = AVPlayerItem(url: fileUrl)
        
        // 將音樂項目替換為新的 playerItem
        player.replaceCurrentItem(with: playerItem)
        
        // 播放音樂
        player.play()
        
    }
    
    
    //    設定Button圖示大小跟圖案
    func setbuttonImage(systemName:String,pointSize: Int)-> UIImage?{
        //        設定一個圖示以及他的長寬
        let sfsymbol = UIImage.SymbolConfiguration(pointSize: CGFloat(pointSize), weight: .bold,scale: .large)
        //        設定圖片名字，跟他的出處
        let sfsymbolImage = UIImage(systemName: systemName, withConfiguration: sfsymbol)
        //        回傳
        return sfsymbolImage
    }
    
    // 類屬性
    var playedIndices: [Int] = []
    var previousIndex: Int? = nil

    // 隨機播放下一首歌
    func playNextSound() {
        if shuffleIndex == 1 {
            if playedIndices.count == allmusic.count {
                // 重置播放記錄
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
        if shuffleIndex == 1 {
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

   


}
