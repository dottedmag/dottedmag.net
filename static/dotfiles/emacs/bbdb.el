;; -*- emacs-lisp -*-

(require 'bbdb)

(bbdb-initialize 'gnus 'message 'sc)

(setq bbdb-file "~/.org/bbdb"
      bbdb-north-american-phone-numbers-p nil
      bbdb-offer-save 'yes-please-save-all-files-automatically
      bbdb-use-pop-up nil)
