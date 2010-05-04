;; -*- emacs-lisp -*-

;;
;; FIDO-like citation. based on SNP config.
;;
;; Don't try to figure out what's going on here, you'll end up in a nut
;; hospital. I nearly did.
;;

(defun snp:timezone (seconds-offset)
  (if seconds-offset
      (progn
        (let ((hour-offset (/ seconds-offset 3600)))
          (if (>= hour-offset 0)
              (format "UTC+%02d" hour-offset)
            (format "UTC-%02d" (- hour-offset)))))
    ""))

(defun snp:simple-date (date)
  (let ((parsed-date (parse-time-string date)))
    (format "%02d:%02d:%02d %02d.%02d.%02d %s"
            (nth 2 parsed-date)
            (nth 1 parsed-date)
            (nth 0 parsed-date)
            (nth 3 parsed-date)
            (nth 4 parsed-date)
            (nth 5 parsed-date)
            (snp:timezone (nth 8 parsed-date)))))

(defun snp:citation-line ()
  (let ((from-name (snp:email->stripped-full-name
                    (mail-header-from message-reply-headers)))
        (to-name (message-fetch-reply-field "X-Comment-To")))
    (insert "Twas brillig at " (snp:simple-date (mail-header-date message-reply-headers)) " when " (snp:email->email (mail-header-from message-reply-headers)) " did gyre and gimble:\n\n")))

(setq message-citation-line-function 'snp:citation-line)

;; Based on code by Sergey Dolin <dsa-ugur@chel.surnet.ru>
;; and message-indent-citation function of Gnus
(defun snp:citation ()
  (insert "<#part sign=pgpmime>\n")
  (let ((beg (point))
        (end (mark t))
        (initials (snp:full-name->initials
                   (snp:email->stripped-full-name
                    (message-fetch-reply-field "From")))))
    (save-excursion
      (narrow-to-region beg end)

      ;; Удалим заголовки
      (goto-char (point-min))
      (search-forward "\n\n")
      (delete-region (point-min) (point))

      ;; Удалим пустые строки в начале текста...
      (while (and (point-min)
                  (eolp)
                  (not (eobp)))
        (message-delete-line))

      ;; ... и в конце текста
      (goto-char (point-max))
      (unless (eolp)
        (insert "\n"))
      (while (and (zerop (forward-line -1))
                  (looking-at "$"))
        (message-delete-line))

      ;; Собственно цитирование
      (goto-char beg)
      (while (not (eobp))
        ;; Заменим табуляции на пробелы
        (beginning-of-line)
        (while (re-search-forward "\011" (point-at-eol) t)
          (replace-match "        "))

        ;; Отквотим
        (beginning-of-line)
        (unless (eolp)
          (if (not snp:quote-initials)
              (insert "> ")
            (if (re-search-forward
                 "^ *\\([a-zA-ZЮ-Ъю-ъ]*\\)\\(>+\\)"
                 (point-at-eol) t)
                (replace-match " \\1>\\2")
              (insert " " initials "> "))))

        (forward-line 1))

      (widen))
    (insert "\n")))

(setq mail-citation-hook
      '(lambda ()
         (snp:citation)
         (goto-char (point-min))
         (search-forward "\n\n")
         (snp:citation-line)))

(defun snp:break-cited-line ()
  (interactive)
  (if (or (bolp) (eolp))
      (insert "\n")
    (let ((quote-string nil))
      (save-excursion
        (beginning-of-line)
        (when (re-search-forward "^ *[a-zA-Zю-ъЮ-Ч]*>+"
                                 (point-at-eol) t)
          (setq quote-string (match-string 0))))
      (if quote-string
          (insert (concat "\n" quote-string))
        (insert "\n")))))

;;
;; Удалить пробелы в начале и в конце строки
;;
(defun snp:strip-string (str)
  (let ((s str))
    (when (string-match "^[ \"]+" s)
      (setq s (substring s (match-end 0))))
    (when (string-match "[ \"]+$" s)
      (setq s (substring s 0 (match-beginning 0))))
    (symbol-value 's)))

;;
;; Получить имя из e-mail'а
;;
(defun snp:email->full-name (from)
  (let ((s))
    (if (cdr (setq s (split-string from "<\\|>")))
        (car s)
      (if (cdr (setq s (split-string from "\(\\|\)")))
          (cadr s)
        from))))

;;
;; Получить мыло
;;
(defun snp:email->email (from)
  (let ((s))
    (if (cdr (setq s (split-string from "<\\|>")))
        (cadr s)
      (if (cdr (setq s (split-string from "\(\\|\)")))
          (snp:strip-string (car s))
        from))))

(defun snp:email->stripped-full-name (from)
  (snp:strip-string (snp:email->full-name from)))

;;
;; Получить начало имени из полного имени
;;
(defun snp:full-name->first-name (name)
  (when (string-match "[^ ]*" name)
    (substring name (match-beginning 0) (match-end 0))))

;;
;; Получить инициалы из имени
;;
(defun snp:full-name->initials (name)
  (let ((lst (split-string name " +"))
        (out ""))
    (while lst
      (setq out (concat out (char-to-string
                             (car (string-to-list (car lst))))))
      (setq lst (cdr lst)))
    (symbol-value 'out)))

(add-hook 'message-setup-hook
          '(lambda ()
             (let ((from-value (message-fetch-reply-field "From")))
               (local-set-key [return] 'snp:break-cited-line)
               )))
