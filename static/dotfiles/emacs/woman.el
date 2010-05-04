;; -*- emacs-lisp -*-

(require 'woman)

(setq woman-use-own-frame nil
      woman-cache-filename "~/.var-emacs/wmncache.el"
      woman-topic-at-point t
      woman-fill-frame t)

(global-set-key [C-f1] 'woman)
