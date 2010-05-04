;; -*- emacs-lisp -*-

(defun indent-buffer ()
  "Indent current buffer"
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))

(defun hard-indent ()
  "Fully reindent current buffer (python users: beware!)"
  (interactive)
  (save-excursion
    (goto-char 0)
    (while (re-search-forward "^ " nil t)
      (replace-match "" nil nil)
      (goto-char 0))
    (while (re-search-forward "^\t" nil t)
      (replace-match "" nil nil)
      (goto-char 0))
    (indent-buffer)))
