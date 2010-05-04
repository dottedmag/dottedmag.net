;; -*- emacs-lisp -*-

(add-to-list 'load-path "~/.lib-emacs/org-mode/lisp")
(require 'org-install)

(add-to-mode-alist-ext 'org-mode "org")

; Global hotkey for agenda
(define-key global-map "\C-ca" 'org-agenda)

(defun gtd ()
  (interactive)
  (find-file "~/.org/Main.org"))

(global-set-key (kbd "C-S-s") 'gtd)

(defun fix-org-mode-hotkey ()
  (define-key org-mode-map [?\C-,] 'switch-to-prev-window))

(add-hook 'org-mode-hook 'switch-to-prev-window)

(setq org-log-done t
      org-agenda-files '("~/.org")
      org-stuck-projects '("+LEVEL=2/-DONE" nil ("*") ""))

; Shortcut for M-x calendar

(defalias 'cal 'calendar)
