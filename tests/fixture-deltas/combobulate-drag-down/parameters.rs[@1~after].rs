// -*- combobulate-test-point-overlays: ((1 outline 181) (2 outline 192) (3 outline 205) (4 outline 218)); eval: (combobulate-test-fixture-mode t); -*-

impl Counter {
    fn bump(amount: u32, &mut self, label: &str, step: u32) -> u32 {
        self.count += amount;
        self.count
    }
}
