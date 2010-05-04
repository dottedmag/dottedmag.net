;; -*- emacs-lisp -*-

(setq default-frame-alist
      '((menu-bar-lines . 0)
        (tool-bar-lines . 0)
        (vertical-scroll-bars . nil)))

(setq mouse-yank-at-point t
      frame-title-format "%b - emacs")
(mouse-avoidance-mode 'exile)

(defun x ()
  "Run X terminal in current directory"
  (interactive)
  (save-window-excursion
    (let ((b (get-buffer-create " *rxvt*")))
      (shell-command "x-terminal-emulator&" b))))
