package random_walker_eight

import "core:math/rand"
import R "vendor:raylib"

Points :: [600]R.Vector2

main :: proc() {
    WIDTH :: 1000
    HEIGHT :: 1000
    ORIGIN: R.Vector2 = {WIDTH/2, HEIGHT/2}
    STEP_SIZE: f32 = 50
    BG: R.Color = R.GetColor(0x0D0E1CFF)

    R.InitWindow(WIDTH, HEIGHT, "Random Walk (8 directions)")
    defer R.CloseWindow()

    points := get_points(ORIGIN, STEP_SIZE)
    for !R.WindowShouldClose() {
        R.BeginDrawing()
        R.ClearBackground(BG)
        draw_points(&points)
        R.EndDrawing()
    }
}

get_points :: proc (start: R.Vector2, step_size: f32) -> Points {
    steps: [9]R.Vector2
    dirs : [3]f32 = {0, 1, -1}
    for x, ix in dirs {
        for y, iy in dirs {
            steps[ix * 3 + iy] = {x * step_size, y * step_size}
        }
    }

    points: Points
    points[0] = start
    for i in 1..<len(points) {
        points[i] = points[i - 1] + rand.choice(steps[1:])
    }
    return points
}

draw_points :: proc (points: ^Points) {
    COLOR: R.Color = R.GetColor(0x00D3D0FF)
    l := len(points) - 2
    for i in 0..<l {
        R.DrawLineV(points[i], points[i + 1], COLOR)
    }
}
