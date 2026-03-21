package main

import "core:math"
import "core:slice"
import rl "vendor:raylib"

// @Scope #scope_file

OptionType :: enum {
    CONTINUE,
    NEW_GAME,
    OPTIONS,
    QUIT,
    SFX_VOL,
    MUSIC_VOL,
    FULLSCREEN,
    BACK,
}

OptionValueType :: enum {
    NONE,
    INTEGER,
    BOOL,
}

Option :: struct {
    type: OptionType,
    name: string,
    enabled: bool,               // @DefaultValues = false,
    value_type: OptionValueType, // @DefaultValues = .NONE,
    value_int: int,              // @DefaultValues = 0,
    value_int_min: int,          // @DefaultValues = 0,
    value_int_max: int,          // @DefaultValues = 5,
}

@(private="file")
reveal: f32 = 0

options_main := [4]Option{
    Option{.CONTINUE, "CONTINUE", true, .NONE, 0, 0, 0},
    Option{.NEW_GAME, "NEW GAME", true, .NONE, 0, 0, 0},
    Option{.OPTIONS,  "OPTIONS",  true, .NONE, 0, 0, 0},
    Option{.QUIT,     "QUIT",     true, .NONE, 0, 0, 0}
}

options_config := [4]Option{
    Option{.SFX_VOL,    "SFX VOLUME",   true, .INTEGER, 3, 0, 4},
    Option{.MUSIC_VOL,  "MUSIC VOLUME", true, .INTEGER, 3, 0, 4},
    Option{.FULLSCREEN, "FULLSCREEN",   true, .BOOL,    1, 0, 1},
    Option{.BACK,       "BACK",         true, .NONE,    0, 0, 0}
}

current_options: []Option  // @FIXME. Is there right?
next_options:    []Option  // @FIXME. Is there right?

options_reveal: f32 = 0

first_option_y :: 160
option_spacing :: 20
hand_pos: f32 = auto_cast first_option_y
current_option := 0

// @Scope #scope_module

// These are a little backwards, getting value from UI rather than the other way around!
options_get_sfx_volume :: proc() -> f32 {
    return (cast (f32) options_config[0].value_int) / (cast (f32) options_config[0].value_int_max)
}

options_get_music_volume :: proc() -> f32 {
    return (cast (f32) options_config[1].value_int) / (cast (f32) options_config[1].value_int_max)
}

options_get_fullscreen :: proc() -> bool {
    return auto_cast options_config[2].value_int
}

options_save :: proc(opts: ^SavedGame) {
    opts.sfx_volume = auto_cast options_config[0].value_int
    opts.music_volume = auto_cast options_config[1].value_int
    opts.fullscreen = auto_cast options_config[2].value_int
}

options_load :: proc(opts: ^SavedGame) {
    options_config[0].value_int = auto_cast opts.sfx_volume 
    options_config[1].value_int = auto_cast opts.music_volume
    options_config[2].value_int = auto_cast opts.fullscreen
}

scene_title_init :: proc() {
    current_options = options_main[:]
    // @Uncomment options_main[0].enabled = map_save_available()

    set_first_valid_option()
}

scene_title_enter :: proc() {
    // @Uncomment options_main[0].enabled = map_save_available()

    reveal = 0
    options_reveal = 0
    current_options = options_main[:]
    set_first_valid_option()
}

scene_title_exit :: proc() {

}

scene_title_render :: proc() {
    // Menu
    offset := 0
    t := options_reveal
    if t > 0 {
        draw_menu(t)
    }

    // Title Text
    t = ease_range_map(reveal, 0.5, 0.7)
    tt := ease_interp(.BOUNCE_IN, 0.0, 1.0, (1 - t))
    offset = auto_cast (tt * (-110))

    draw_copy(&arts, sprite_title_text1, Vector2i{12, auto_cast (8 + offset)}, Vector4{1, 1, 1, 1})
    draw_copy(&arts, sprite_title_text2, Vector2i{48, auto_cast (64 + offset)}, Vector4{1, 1, 1, 1})

    // Art
    t = ease_range_map(reveal, 0, 0.4)
    t = ease_interp(.EXPO_IN, 0.0, 1.0, (1 - t))
    offset = auto_cast (t * f32(-game_width))

    draw_copy(&arts, sprite_title_art, Vector2i{auto_cast (180 + offset), 18}, Vector4{1, 1, 1, 1})
}

scene_title_update :: proc() {
    reveal += time_delta * 0.65
    if reveal > 1 { reveal = 1 }

    if reveal >= 1 && len(next_options) == 0 {
        options_reveal += time_delta * 1.25
        if options_reveal > 1 {
            options_reveal = 1
        }
    }
    else {
        options_reveal -= time_delta * 1.75
        if options_reveal < 0 {
            options_reveal = 0
            if len(next_options) != 0 {
                current_options = next_options
                next_options = {}
                set_first_valid_option()
            }
        }
    }

    hand_pos_dest: f32 = auto_cast (first_option_y + (current_option * option_spacing))
    hand_pos = auto_cast lerp(hand_pos, hand_pos_dest, (time_delta * 40))

    prev_option := current_option

    // Don't process any input if transitioning
    if (reveal < 0.8 || options_reveal < 0.6) { return }

    if input_button_pressed(.UP) {
        current_option = current_option - 1
        for (current_option < 0 || !current_options[current_option].enabled) {
            current_option = current_option - 1
            if (current_option < 0) {
                current_option = len(current_options) - 1
            }
        }
    }

    if input_button_pressed(.DOWN) {
        current_option += 1
        for (current_option >= len(current_options) || !current_options[current_option].enabled) {
            current_option += 1
            if (current_option >= len(current_options)) {
                current_option = 0
            }
        }
    }

    if current_options[current_option].value_type == .INTEGER {
        if input_button_pressed(.LEFT) {
            if current_options[current_option].value_int > current_options[current_option].value_int_min {
                current_options[current_option].value_int -= 1
                // @Uncomment audio_play_sound(sound_select, true)
            }
        }
        else if input_button_pressed(.RIGHT) {
            if current_options[current_option].value_int < current_options[current_option].value_int_max {
                current_options[current_option].value_int += 1
                // @Uncomment audio_play_sound(sound_select, true)
            }
        }
    }

    if current_option < 0 { current_option = 0 }
    if current_option >= len(current_options) { current_option = len(current_options) - 1 }

    if input_button_pressed(.SELECT) {
        if current_options[current_option].enabled {
            #partial switch current_options[current_option].type {
                // Main
                case .CONTINUE:
                    game_set_scene(.GAME)
                    // @Uncomment audio_play_sound(sound_select, true)
                
                case .NEW_GAME:
                    // @Uncomment map_load(0)
                    game_set_scene(.GAME)
                    // @Uncomment audio_play_sound(sound_select, true)

                case .OPTIONS:
                    next_options = options_config[:]
                    // @Uncomment audio_play_sound(sound_select, true)

                case .QUIT:
                    game_save()
                    game_set_scene(.QUIT)
                    // @Uncomment audio_play_sound(sound_cancel, true)

                // Config
                case .SFX_VOL:
                    
                case .MUSIC_VOL:

                case .FULLSCREEN:
                    if options_config[2].value_int == 0 {
                        options_config[2].value_int = 1
                    }
                    else {
                        options_config[2].value_int = 0
                    }

                    game_toggle_fullscreen(options_get_fullscreen())

                    // @Uncomment audio_play_sound(sound_select, true)

                case .BACK:
                    game_save()
                    next_options = options_main[:]
                    // @Uncomment audio_play_sound(sound_cancel, true)
            }
        }
    }

    // Back out of options using cancel button
    if input_button_pressed(.CANCEL) && slice.equal(options_config[:], current_options) {
        game_save()
        // @Uncomment audio_play_sound(sound_cancel, true)
        next_options = options_main[:]
    }

    if prev_option != current_option {
        // @Uncomment audio_play_sound(sound_option, true)
    }
}

// @Scope #scope_file
draw_menu :: proc(t: f32) {
    t1 := ease_interp(.ELASTIC_IN, 0.0, 1.0, (1 - t))
    offset: int = auto_cast (t1 * 300)

    for i in 0..=len(current_options) - 1 {
        color := pal[7]
        if !current_options[i].enabled { color = pal[2] }

        #partial switch current_options[i].value_type {
            case .NONE:
                draw_text(&font_expire, Vector2i{auto_cast (125 + offset), auto_cast (first_option_y + (i * option_spacing))}, color, current_options[i].name)

            case .INTEGER:
                draw_text(&font_expire, Vector2i{auto_cast (125 + offset), auto_cast (first_option_y + (i * option_spacing))}, color, current_options[i].name)
                draw_copy(&arts, sprite_slider_bar, Vector2i{auto_cast (125 + offset + 100), auto_cast (first_option_y + (i * option_spacing))}, pal[3])
                draw_copy(&arts, sprite_slider_tag, Vector2i{auto_cast (125 + offset + 103 + (current_options[i].value_int * 3)), auto_cast (first_option_y + (i * option_spacing))}, pal[7])

            case .BOOL:
                draw_text(&font_expire, Vector2i{auto_cast (125 + offset), auto_cast (first_option_y + (i * option_spacing))}, color, current_options[i].name)
                if (current_options[i].value_int > 0) {
                    draw_copy(&arts, sprite_checkbox_on, Vector2i{auto_cast (125 + offset + 100), auto_cast (first_option_y + (i * option_spacing))}, pal[7])
                } else {
                    draw_copy(&arts, sprite_checkbox_off, Vector2i{auto_cast (125 + offset + 100), auto_cast (first_option_y + (i * option_spacing))}, pal[3])
                }
        }
    }

    pointer_offset: f32 = auto_cast (math.sin(rl.GetTime() * 10) * 4)

    draw_sprite(&arts, sprite_get_index(SpriteType.UI_HAND), Vector2i{auto_cast (f32(105 + offset) + pointer_offset), auto_cast (hand_pos - 2)}, pal[7])
}

set_first_valid_option :: proc() {
    // Find first enabled option
    for i in 0..=len(current_options) - 1 {
        if current_options[i].enabled {
            current_option = i
            hand_pos: f32 = auto_cast (first_option_y + (current_option * option_spacing))
            break
        }
    }
}
