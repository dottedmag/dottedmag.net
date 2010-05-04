;; -*- emacs-lisp -*-

(defun run-on-article (cmd)
  (dolist (art gnus-newsgroup-processable)
    (gnus-summary-goto-article art)
    (gnus-summary-show-raw-article)
    (gnus-summary-save-in-pipe cmd)))

(defun spam ()
  "Submit Spam."
  (interactive)
  (if (is-local-mail)
      (run-on-article "spamc -L spam")
    (run-on-article "ssh vertex spamc -L spam")))

(defun ham ()
  "Submit Ham."
  (interactive)
  (if (is-local-mail)
      (run-on-article "spamc -L ham")
    (run-on-article "ssh vertex spamc -L ham")))
