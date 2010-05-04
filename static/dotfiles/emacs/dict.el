;; -*- emacs-lisp -*-

(require 'dictem nil t)

(if (fboundp 'dictem)
    (progn
      (setq dictem-default-database "*"
            dictem-default-strategy "."
            dictem-empty-initial-input t
            dictem-server "localhost"
            dictem-use-existing-buffer t)
      (dictem-initialize)

      (defun my-dictem-run-search (query)
        "Asks user for a word, creates *dictem* buffer and shows definitions in it."
        (interactive
         (list
          (dictem-read-query "")))
        (dictem-run 'dictem-base-search "*" query "."))

      (define-key dictem-mode-map "s" 'my-dictem-run-search)))
