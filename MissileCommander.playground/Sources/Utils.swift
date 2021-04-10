
import AVFoundation

func playSound(sound: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: nil) {
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer.play()
            print("왜안되냐고")
        } catch {
            print("Could not find and play the sound file")
        }
    }
}
