;; -*- emacs-lisp -*-

(require 'tramp)

(setq tramp-persistency-file-name "~/.var-emacs/tramp.cache")

; Matching default ZSH prompt
(setq tramp-shell-prompt-pattern "[^#$%>\n]*[#$%>] *\\(ESC\\[[0-9;]*[a-zA-Z] *\\)*")

