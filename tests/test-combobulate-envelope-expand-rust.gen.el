;; This file is generated auto generated. Do not edit directly.

(require 'combobulate)

(require 'combobulate-test-prelude)

(ert-deftest
    combobulate-test-rust-combobulate-envelope-expand-rust-rust-if-statement-blank-1
    ()

  "Test `combobulate' with `fixtures/envelope/blank.rs' in `rust-ts-mode' mode."
  (combobulate-test
      (:language rust :mode rust-ts-mode :fixture
		 "fixtures/envelope/blank.rs")
    :tags
    '(combobulate rust rust-ts-mode combobulate-envelope-expand-rust)
    (combobulate-test-go-to-marker 1)
    (let
	((combobulate-envelope-proffer-choices '(0))
	 (combobulate-envelope-prompt-actions '("cond > 0"))
	 (combobulate-envelope-expansion-actions 'nil)
	 (combobulate-envelope-registers 'nil)
	 (instructions
	  '("if " (p cond "Condition") " {" n> @ n> "}" > n>)))
      (combobulate-with-stubbed-prompt-expansion
	  (combobulate-with-stubbed-envelope-prompt
	      (combobulate-with-stubbed-proffer-choices
		  (:choices combobulate-envelope-proffer-choices)
		(combobulate-test-go-to-marker 1)
		(combobulate-envelope-expand-instructions instructions)
		(combobulate-compare-action-with-fixture-delta
		 "./fixture-deltas/combobulate-envelope-expand-rust/blank.rs[rust-if-statement@1~after].rs")))))))


(ert-deftest
    combobulate-test-rust-combobulate-envelope-expand-rust-rust-for-loop-blank-1
    ()

  "Test `combobulate' with `fixtures/envelope/blank.rs' in `rust-ts-mode' mode."
  (combobulate-test
      (:language rust :mode rust-ts-mode :fixture
		 "fixtures/envelope/blank.rs")
    :tags
    '(combobulate rust rust-ts-mode combobulate-envelope-expand-rust)
    (combobulate-test-go-to-marker 1)
    (let
	((combobulate-envelope-proffer-choices '(0))
	 (combobulate-envelope-prompt-actions '("0..10" "x"))
	 (combobulate-envelope-expansion-actions 'nil)
	 (combobulate-envelope-registers 'nil)
	 (instructions
	  '("for " (p pattern "Pattern") " in "
	    (p iterator "Iterator") " {" n> @ n> "}" > n>)))
      (combobulate-with-stubbed-prompt-expansion
	  (combobulate-with-stubbed-envelope-prompt
	      (combobulate-with-stubbed-proffer-choices
		  (:choices combobulate-envelope-proffer-choices)
		(combobulate-test-go-to-marker 1)
		(combobulate-envelope-expand-instructions instructions)
		(combobulate-compare-action-with-fixture-delta
		 "./fixture-deltas/combobulate-envelope-expand-rust/blank.rs[rust-for-loop@1~after].rs")))))))


