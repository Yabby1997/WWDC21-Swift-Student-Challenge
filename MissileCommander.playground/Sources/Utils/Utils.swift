
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
