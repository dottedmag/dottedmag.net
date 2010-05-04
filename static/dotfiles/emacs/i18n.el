;; -*- emacs-lisp -*-

(set-language-environment "UTF-8")

; should be moved out of i18n.el
; (set-input-mode nil nil 'we-will-use-eighth-bit-of-input-byte)

; ?? probably unnecessary anymore
; (standard-display-8bit 127 255)

(define-coding-system-alias 'UTF-8 'utf-8)

(add-to-list 'safe-local-variable-values '(encoding . utf-8))
