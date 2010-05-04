;; -*- emacs-lisp -*-

(require 'backup-dir)

(setq bkup-backup-directory-info
      '((t "~/.var-emacs/backup" ok-create full-path prepend-name)))

(setq tramp-bkup-backup-directory-info
      '((t "~/.var-emacs/backup" ok-create full-path prepend-name)))

(setq delete-old-versions t
      kept-old-versions 1
      kept-new-versions 3
      version-control t)
