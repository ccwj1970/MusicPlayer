//
//  Second.swift
//  MusicPlayer
//
//  Created by 紀韋如 on 22/07/2024.
//  文組班U8-Page Control

import UIKit

class Second: UIViewController {
    
    let images = ["singer 1", "singer 2", "singer 3", "singer 4", "singer 5"]
    let texts = ["ABAO", "Bunun", "Lynn", "Vox", "Madal"]
    let descs =
       ["阿仍仍（1981年8月25日—）（排灣語：Aljenljeng Tjaluvie，藝名阿爆、Abao，漢語名張靜雯）是台灣台東縣金峰鄉嘉蘭正興部落出身的原住民歌手、詞曲作家及主持人，排灣族人。2020年10月3日阿爆以《kinakaian 母親的舌頭》二度獲頒金曲獎最佳原住民語專輯獎，以及金曲最大獎-年度專輯獎，並以專輯中的〈Thank You 感謝〉拿下年度歌曲獎。",
        "《從此刻起-布農孩子的傳承與跨界》由社團法人中華民國雙躍關懷成長協會製作發行。發現部落青年因求學與生存移居至都市，身處都市而經歷生活文化的衝擊，面對傳統部落文化精神與都市競爭適應的矛盾，內心茫然迷惘。因此，透過傳統歌謠錄製傳承布農文化，結合流行跨界發揚布農勇士精神，祝福每個布農孩子在未來的社會中，延續布農生命生生不息，保有自我、跨越文化藩籬、躍出生命嶄新的一頁。",
        "「莎莉木可的拐杖」演唱為年輕的明日之星歌手何祖伶，古調歌頌 Ludja 部落核心家族 Zingrur，大約兩百年前的老祖宗莉木（Ljimuk）跟布度（Pudju） 兩姊弟。 展現王族 Pudju 豪氣萬千的氣魄； 在莉木、布度上幾輩的世代，Zingrur家族的領地包含淺山草原到海邊的廣大地區，因而歌詞提到了海與淺山草原；爾後莉木與布度的父親古哩哩（Kuljilji）才引領由 Tjakualim（萬金）遷徙到了山上的路口 Taciqaven。",
        "改變一個部落孩子的未來，就有機會改變部落的未來。2008年春天，台灣原聲教育協會成立，同時在南投縣信義鄉成立了「原聲音樂學校」及「台灣原聲童聲合唱團」，十餘年來，以提升學科能力及藉由合唱實施品格教育的雙軌並行方式，培育了眾多原住民學童；合唱團的純淨天籟也揚名海內外，被譽為台灣的維也納。",
        "來自臺東長濱的阿美族語音樂創作者 馬樂Madal(陳祈宏)喜歡採集、記錄部落的傳統歌謠，並將蒐集的古調以現代的音樂形式，融入到音樂教學與創作裡，也透過接觸耆老的生命故事和投入文化事務的心路歷程，將之萃取成族語音樂創作的養分。"]

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var descView: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    var index = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func next(_ sender: Any) {
        index = (index + 1 ) % images.count
        let image = images[index]
        let text = texts[index]
        let desc = descs[index]
        imageView.image = UIImage(named: image)
        textView.text = text
        descView.text = desc
        pageControl.currentPage = index // 小圓點位置
    }
    
    
    @IBAction func previous(_ sender: Any) {
        
        index = (index - 1 + images.count ) % images.count
        let image = images[index]
        let text = texts[index]
        let desc = descs[index]
        imageView.image = UIImage(named: image)
        textView.text = text
        descView.text = desc
        pageControl.currentPage = index // 小圓點位置
    }
    
}
