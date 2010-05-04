;; -*- emacs-lisp -*-

(require 'python)

; Autoindentation after "Return"
(define-key python-mode-map "\C-m" 'newline-and-indent)

(show-trailing-whitespace-in 'python-mode-hook)

(require 'jinja)

(add-to-mode-alist-ext 'jinja-mode "jt")
