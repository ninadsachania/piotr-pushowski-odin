package main

import rl "vendor:raylib"

// @Scope #scope_file

@(private="file")
reveal: f32 = 0
done: bool = false

scene_splash_init :: proc() {
}

scene_splash_enter :: proc() {
    reveal = 0
}

scene_splash_exit :: proc() {
    // @Uncomment audio_play_music("res/music_build.ogg", 0.5)
}

scene_splash_render :: proc() {
    height : f32 = f32(window_height) * 0.75
    width := height

    x0 := f32(window_width / 2) - (width / 2)
    y0 := f32(window_height / 2) - (height / 2)
    x1 := width
    y1 := height

    rl.DrawTexturePro(logo, rl.Rectangle{auto_cast 0, auto_cast 0, auto_cast 1024, auto_cast 1024}, rl.Rectangle{auto_cast x0, auto_cast y0, auto_cast width, auto_cast height}, [2]f32{0, 0}, 0, rl.WHITE)
}

scene_splash_update :: proc() {
    reveal += time_delta * 0.65
    if reveal > 1 {
        if !done {
            game_set_scene(.TITLE)
            done = true
        }
        reveal = 1
    }
}
