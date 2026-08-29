// -*- combobulate-test-point-overlays: ((1 outline 173) (2 outline 183) (3 outline 198) (4 outline 225)); eval: (combobulate-test-fixture-mode t); -*-

enum Payment {
    Cash,
    Card(u64),
    Cancelled,
    Transfer(u64, String),
}
