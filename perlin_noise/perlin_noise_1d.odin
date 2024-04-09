package perlin_noise_1d

import "core:math"
import "core:math/rand"
import R "vendor:raylib"

main :: proc() {
    WIDTH :: 800
    HEIGHT :: 800
    BG: R.Color = R.GetColor(0x0D0E1CFF)

    R.InitWindow(WIDTH, HEIGHT, "Perlin Noise 1D")
    defer R.CloseWindow()

    R.SetTargetFPS(20)
    points : [800]R.Vector2

    for x in 0..<len(points) {
        y := noise(x) + noise(x * 2) + noise(x * 4)
        points[x] = R.Vector2 {f32(x), y / 3}
    }

    x : int
    for !R.WindowShouldClose() {
        R.BeginDrawing()
        R.ClearBackground(BG)
        R.DrawCircleV(points[x], 80, R.RED)
        /* for p in points { */
        /*     R.DrawCircleV(p, 1, R.RED) */
        /* } */
        R.EndDrawing()

        x = (x + 1) % len(points)
    }
}

noise :: proc(x: int) -> f32 {
    HEIGHT :: 800
    amp: f32 = 100
    wl: int = 600
    fq: f32 = 100 / f32(wl)

    a := lcg()
    b := lcg()

    y : f32
    if(x % wl == 0) {
        a = b
        b = lcg()
        y = HEIGHT / 2 + a * amp
    } else {
        y = HEIGHT / 2 + interpolate(a, b, f32(x % wl) / f32(wl)) * amp
    }
    return y
}

/* Linear Congruential Generator */
lcg :: proc() -> f32 {
    M :: 4294967296
    A :: 1664525
    C :: 1
    Z := i64(rand.float32() * M)
    return f32(f64((A * Z + C) % M) / M)
}

interpolate :: proc(a: f32, b: f32, x: f32) -> f32 {
    w := (1 - math.cos(math.PI * x)) * 0.5
    return a * (1 - w) + a * w
}
