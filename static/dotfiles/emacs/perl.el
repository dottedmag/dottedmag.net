;;; -*- emacs-lisp -*-

(require 'cperl-mode)

(add-to-mode-alist-ext 'cperl-mode "pl" "pm")

(put 'cperl-indent-level 'safe-local-variable 'integerp)

(show-trailing-whitespace-in 'cperl-mode-hook)
