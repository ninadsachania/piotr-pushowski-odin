package main

import rl "vendor:raylib"

loaded_once := false

scene_game_init :: proc() {
}

scene_game_enter :: proc() {
    if !loaded_once {
        // @Uncomment.
        /*
        if current_level >= 0 {
            map_load(current_level);
        }
        */

        loaded_once = true;
    }
}

scene_game_exit :: proc() {
    game_save();
}

scene_game_render :: proc() {
    // @Uncomment map_draw();

    {
    
        //
        // @Temp.
        //
        rl.ClearBackground(rl.SKYBLUE);

        text := "GAME!!!"

        w, h := measure_text(&font_expire, text);
        draw_text(&font_expire, { (window_width - i32(w)) / 2, (window_height - i32(h)) / 2 }, { 1, 1, 1, 1 }, text);
    }
}

scene_game_update :: proc() {
    // @Uncomment map_update();

    if input_button_pressed(.ESCAPE) {
        game_set_scene(.TITLE);
    }
}
