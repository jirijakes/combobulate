// -*- combobulate-test-point-overlays: ((1 outline 214) (2 outline 235) (3 outline 255) (4 outline 281)); eval: (combobulate-test-fixture-mode t); -*-

fn describe(n: u32) -> &'static str {
    match n {
        0 => "zero",
        1 => "one",
        _ => "many",
        2..=9 => "small",
    }
}
