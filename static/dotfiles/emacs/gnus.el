;; -*- emacs-lisp -*-

(defun is-local-mail ()
  (equal (system-name) "vertex"))

(load-init
 "gnus-fidocite"
 "gnus-spam")

;; Personalities

(setq user-mail-address "dottedmag@dottedmag.net"
      user-full-name "Mikhail Gusarov"
      gnus-posting-styles
      '((".*"
         (signature "  http://fossarchy.blogspot.com/")
         (body "<#part sign=pgpmime>\n")
         (name "Mikhail Gusarov")
         (address "dottedmag@dottedmag.net")
         (eval (setq snp:quote-initials t)))
        ((header "message-id" ".*")
         (body ""))
        ("altlinux.*"
         (address "dottedmag@altlinux.org"))))

;; Directories, files

(setq gnus-save-newsrc-file nil
      gnus-read-newsrc-file nil
      gnus-always-read-dribble-file t
      gnus-read-active-file 'some)

;; Look and feel

(setq gnus-summary-line-format "%U%R%z%{|%}%4k%{|%}%-25,25f%{|%B%}%s\n"
      gnus-treat-display-smiles nil ; NO STUPID GRAPHICAL SMILES!
      gnus-use-full-window nil)

(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)

;; HTML rendering

(setq mm-text-html-renderer 'html2text
      mm-discouraged-alternatives '("text/html"
                                    "text/richtext"))

;; PGP

(setq mml2015-signers '("3E338888"))

;; BBDB

(require 'bbdb)
(require 'bbdb-gnus)

(add-hook 'gnus-startup-hook 'bbdb-insinuate-gnus)
(add-hook 'gnus-startup-hook 'bbdb-insinuate-message)

;; Sent mail

(setq gnus-outgoing-message-group "sent")

;; Threading

(setq gnus-build-sparse-threads t
      gnus-summary-thread-gathering-function 'gnus-gather-threads-by-references
      gnus-simplify-subject-functions '(gnus-simplify-subject-re
                                        gnus-simplify-subject-fuzzy
                                        gnus-simplify-whitespace)
      gnus-fetch-old-headers t)

;; Subscription

(setq gnus-subscribe-newsgroup-method 'gnus-subscribe-interactively)
(setq gnus-check-new-newsgroups 'ask-server)

;; Hotkeys

(defun my-switch-to-gnus-group-buffer ()
  "Switch to gnus group buffer if it exists, otherwise start gnus"
  (interactive)
  (if (or (not (fboundp 'gnus-alive-p))
          (not (gnus-alive-p)))
      (gnus)
    (switch-to-buffer "*Group*"))
  (gnus-group-get-new-news))

(global-set-key (kbd "C-S-g") 'my-switch-to-gnus-group-buffer)

;; Groups

(setq gnus-parameters
      '(("debian-.*" (gnus-mailing-list-followup-to))))
