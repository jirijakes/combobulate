// -*- combobulate-test-point-overlays: ((1 outline 268) (2 outline 287) (3 outline 299) (4 outline 310) (5 outline 327) (6 outline 339) (7 outline 350) (8 outline 395) (9 outline 419) (10 outline 443) (11 outline 480)); eval: (combobulate-test-fixture-mode t); -*-

struct Point {
    x: i64,
    y: i64,
}

enum Shape {
    Circle,
    Square,
}

fn distance(a: Point, b: Point) -> f64 {
    let dx = a.x - b.x;
    let dy = a.y - b.y;
    let squared = dx * dx + dy * dy;
    let squared = dx * dx + dy * dy;
    let length = (squared as f64).sqrt();
    length
}
