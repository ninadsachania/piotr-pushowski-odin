package main

import "core:fmt"
import "core:strings"
import "core:os"
import "core:time"

import rl "vendor:raylib"

// @Scope #scope_module

SceneType :: enum {
    NONE,
    SPLASH,
    TITLE,
    GAME,
    QUIT,
}

game_width: i32
game_height: i32

window_width: i32 = 1280
window_height: i32 = 720

time_delta: f32
time_prev: f64

SavedGame :: struct {
    version: u32,
    res_width: u32,
    res_height: u32,
    sfx_volume: u32,
    music_volume: u32,
    fullscreen: u32,
    current_level: i32,
}

frame_count: int = 0

// @Scope #scope_file

// @Uncomment prev_window_info: Saved_Window_Info;

// @Uncomment window: Window_Type;

// @Uncomment pixel_surf: Simp.Texture;

should_quit_game: bool = false;

current_scene: SceneType;
next_scene: SceneType = .NONE;
scene_reveal: f32 = 0.0;

save_game_file: string;
save_game_path: string;

SAVE_VERSION: u32 : 1;

// @Scope #scope_module

game_set_scene :: proc(scene: SceneType) {
    if scene != .SPLASH && current_scene != .SPLASH {
        // @Uncomment audio_play_sound(sound_scene_swish, true)
    }

    #partial switch current_scene {
        // @Uncomment case .TITLE:  scene_title_exit()
        // @Uncomment case .GAME:   scene_game_exit()
        // @Uncomment case .SPLASH: scene_splash_exit()
    }

    next_scene = scene

    // Reveal immediately if there is no other scene
    if current_scene == .NONE {
        current_scene = next_scene
        scene_reveal = 1.0
        next_scene = .NONE
    }
}

game_quit :: proc() {
    should_quit_game = true;
}

game_toggle_fullscreen :: proc(fullscreen: bool) {
    // @Uncomment fullscreen_success, window_width, window_height := toggle_fullscreen(window, fullscreen, *prev_window_info);
}

game_save :: proc() {
    // @Stub
}

game_load :: proc() {
    // @Stub
}

main :: proc() {
	width  := window_width
    height := window_height

    rl.InitWindow(window_width, window_height, "Piotr Pushowski and the Crates")

	init()
	game_set_scene(.SPLASH);

	time_prev = rl.GetTime()

	// @Uncomment audio_update();

	for !rl.WindowShouldClose() {
        rl.BeginDrawing()

        // @Temporary.
        rl.ClearBackground(rl.BLACK);

        time_current := rl.GetTime()
        time_delta = auto_cast (time_current - time_prev)
        time_prev = time_current

        update()
        render()

        frame_count += 1

        rl.EndDrawing()
    }

    rl.CloseWindow()
}

render :: proc() {
    // @Stub.
}


update :: proc() {
    // @Stub.
}

init :: proc() {
    game_width = 640;
    game_height = 360;

    // @Uncomment pixel_surf = Simp.texture_create_render_target(game_width, game_height, .RGBA8, .Render_Target);

    // @Uncomment audio_init();
    // @Uncomment gamepad_init();

    assets_init();
    // @Uncomment map_init();

    // @Uncomment scene_title_init();
    // @Uncomment scene_game_init();
}

Vector4 :: struct {
    // Wrong order?
    x: f32,
    y: f32,
    z: f32,
    w: f32,
}

U16_MAX: int : 65535
