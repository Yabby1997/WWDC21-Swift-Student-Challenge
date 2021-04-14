
import SpriteKit
import AVFoundation

func soundPlayer(sound: String) -> AVAudioPlayer? {
    if let path = Bundle.main.path(forResource: sound, ofType: nil) {
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            return audioPlayer
        } catch {
            print("Could not find and play the sound file")
        }
    }
    return nil
}

func getWarheadSize(blastRange: Int) -> Int {
    if blastRange <= 40 {
        return 5
    } else {
        return 7
    }
}

func loadFont(font: String) {
    let fontURL = Bundle.main.url(forResource: "Font/\(font)", withExtension: "ttf")
    CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
}
