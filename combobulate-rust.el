;;; combobulate-rust.el --- rust support for combobulate  -*- lexical-binding: t; -*-

;; Copyright (C) 2023  Mickey Petersen

;; Author: Mickey Petersen <mickey@masteringemacs.org>
;; Keywords:

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(require 'combobulate-settings)
(require 'combobulate-navigation)
(require 'combobulate-setup)
(require 'combobulate-manipulation)
(require 'combobulate-rules)

(defgroup combobulate-rust nil
  "Configuration switches for Rust"
  :group 'combobulate
  :prefix "combobulate-rust-")

(defun combobulate-rust-pretty-print-node-name (node default-name)
  "Pretty printer for Rust nodes"
  (combobulate-string-truncate
   (replace-regexp-in-string
    (rx (| (>= 2 " ") "\n")) ""
    (pcase (combobulate-node-type node)
      ("function_item"
       (concat "fn "
               (combobulate-node-text (combobulate-node-child-by-field node "name"))))
      ("struct_item"
       (concat "struct "
               (combobulate-node-text (combobulate-node-child-by-field node "name"))))
      ("enum_item"
       (concat "enum "
               (combobulate-node-text (combobulate-node-child-by-field node "name"))))
      ("union_item"
       (concat "union "
               (combobulate-node-text (combobulate-node-child-by-field node "name"))))
      ("trait_item"
       (concat "trait "
               (combobulate-node-text (combobulate-node-child-by-field node "name"))))
      ;; impl blocks have no name of their own: print the type that is
      ;; being implemented instead.
      ("impl_item"
       (concat "impl "
               (combobulate-node-text (combobulate-node-child-by-field node "type"))))
      ("mod_item"
       (concat "mod "
               (combobulate-node-text (combobulate-node-child-by-field node "name"))))
      ("type_item"
       (concat "type "
               (combobulate-node-text (combobulate-node-child-by-field node "name"))))
      ("macro_definition"
       (concat "macro_rules! "
               (combobulate-node-text (combobulate-node-child-by-field node "name"))))
      ;; a use declaration has no name field, so print the entire (and
      ;; thanks to the truncation, abbreviated) use tree.
      ("use_declaration" (combobulate-node-text node))
      (_ default-name)))
   40))

(eval-and-compile
  (defvar combobulate-rust-definitions
    '((procedure-discard-rules
       ;; unlike most grammars, Rust's comments are named
       ;; `line_comment' and `block_comment' and not `comment', so the
       ;; default discard rule does not apply.
       '("line_comment" "block_comment"))
      (plausible-separators '(";" ","))
      (procedures-defun
       '((:activation-nodes
          ((:nodes ("function_item" "function_signature_item"
                    "struct_item" "enum_item" "union_item"
                    "trait_item" "impl_item" "mod_item"
                    "type_item" "const_item" "static_item"
                    "macro_definition" "foreign_mod_item"))))))
      (procedures-logical
       '((:activation-nodes ((:nodes (all))))))
      (procedures-sibling
       '(;; match arms.  `:position at' is required so that point
         ;; inside an arm's body navigates the statements of that
         ;; body (below) instead of the arms themselves.
         (:activation-nodes
          ((:nodes ((rule "match_block"))
                   :position at
                   :has-parent ("match_block")))
          :selector (:choose parent :match-children t))
         ;; statements and items of a block or the source file.  This
         ;; must come before the position-agnostic container rules
         ;; below so that, say, point on a statement inside a closure
         ;; in a function argument navigates statements and not
         ;; arguments.
         (:activation-nodes
          ((:nodes ((rule "block") (rule "source_file"))
                   :position at
                   :has-parent ("block" "source_file")))
          :selector (:choose parent
                             :match-children
                             ;; attributes are decoration for
                             ;; whatever follows them and would
                             ;; otherwise pollute navigation.
                             (:discard-rules ("attribute_item"))))
         ;; struct and union fields.
         (:activation-nodes
          ((:nodes ((rule "field_declaration_list"))
                   :has-parent ("field_declaration_list")))
          :selector (:choose parent
                             :match-children
                             (:discard-rules ("attribute_item"))))
         ;; enum variants.
         (:activation-nodes
          ((:nodes ((rule "enum_variant_list"))
                   :has-parent ("enum_variant_list")))
          :selector (:choose parent
                             :match-children
                             (:discard-rules ("attribute_item"))))
         ;; function parameters.
         (:activation-nodes
          ((:nodes ((rule "parameters"))
                   :has-parent ("parameters")))
          :selector (:choose parent
                             :match-children
                             (:discard-rules ("attribute_item"))))
         ;; closure parameters.
         (:activation-nodes
          ((:nodes ((rule "closure_parameters"))
                   :has-parent ("closure_parameters")))
          :selector (:choose parent :match-children t))
         ;; function/macro call arguments.  `(rule "_literal")' is
         ;; required because the generated rules do not fold the
         ;; `_literal' supertype into `_expression', which would
         ;; otherwise exclude string and number arguments from
         ;; activating the procedure.
         (:activation-nodes
          ((:nodes ((rule "arguments") (rule "_literal"))
                   :has-parent ("arguments")))
          :selector (:choose parent
                             :match-children
                             (:discard-rules ("attribute_item"))))
         ;; use lists, both the top-level braced list and any nested
         ;; ones.  Items must have a use list as their immediate
         ;; parent: the path of a `scoped_use_list' (the `fmt' in
         ;; `fmt::{...}') also sits inside one, and treating it as an
         ;; item selects the item itself, which dead-ends navigation
         ;; instead of moving between the items of the enclosing list.
         ;; The `(rule "use_list")' expansion covers every item type,
         ;; including nested `scoped_use_list's.
         (:activation-nodes
          ((:nodes ((rule "use_list"))
                   :has-parent ("use_list")))
          :selector (:choose parent :match-children t))
         ;; trait/impl/mod/foreign module bodies.  The action node is
         ;; the declaration list itself: from anywhere inside it
         ;; navigate its items.
         (:activation-nodes
          ((:nodes ("declaration_list")))
          :selector (:choose node
                             :match-children
                             (:discard-rules ("attribute_item"
                                              "inner_attribute_item"))))
         ;; fall back to the top-level items of the source file when
         ;; point is inside one but not at a statement start, such as
         ;; in a function's return type or a struct's where clause.
         (:activation-nodes
          ((:nodes ((rule "source_file"))
                   :has-parent ("source_file")))
          :selector (:choose parent
                             :match-children
                             (:discard-rules ("attribute_item" "shebang"))))))
      (procedures-hierarchy
       '((:activation-nodes
          ((:nodes ("block") :position at))
          :selector (:choose node :match-children t))
         ;; descending from a declaration statement should take us
         ;; straight into its body, if it has one.
         (:activation-nodes
          ((:nodes ((rule "_declaration_statement")
                    "expression_statement"
                    "source_file")
                   :position at))
          :selector (:choose node
                             :match-children
                             (:match-rules ("block" "declaration_list"
                                            "match_block"
                                            "field_declaration_list"
                                            "enum_variant_list"))))
         (:activation-nodes
          ((:nodes ((all))))
          :selector (:choose node :match-children t))))
      (procedures-sexp nil)
      (procedures-edit nil)
      (context-nodes
       '("identifier" "field_identifier" "type_identifier"
         "shorthand_field_identifier" "integer_literal"
         "float_literal" "char_literal" "string_literal"
         "boolean_literal" "lifetime"))
      (pretty-print-node-name-function
       #'combobulate-rust-pretty-print-node-name)
      (indent-after-edit nil)
      (envelope-indent-region-function #'indent-region)
      (envelope-procedure-shorthand-alist
       '((general-statement
          . ((:activation-nodes
              ((:nodes ((rule "block") (rule "_declaration_statement")
                        (rule "source_file"))
                       :has-parent ("block" "source_file"))))))))
      (envelope-list
       '((:description
          "if ... { ... }"
          :key "i"
          :mark-node t
          :shorthand general-statement
          :name "if-statement"
          :template
          ("if " (p cond "Condition") " {" n> @ n> "}" > n>))
         (:description
          "for ... in ... { ... }"
          :key "f"
          :mark-node t
          :shorthand general-statement
          :name "for-loop"
          :template
          ("for " (p pattern "Pattern") " in " (p iterator "Iterator")
           " {" n> @ n> "}" > n>)))))))

(define-combobulate-language
 :name rust
 :major-modes (rust-mode rust-ts-mode)
 :custom combobulate-rust-definitions
 :setup-fn combobulate-rust-setup)

(defun combobulate-rust-setup (_))

(provide 'combobulate-rust)
;;; combobulate-rust.el ends here
