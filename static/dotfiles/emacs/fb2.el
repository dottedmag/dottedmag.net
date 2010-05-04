
(defun fb2-link (link-name)
  (interactive "MLink name: ")
  (insert (concat "<a xlink:href=\"#n"
                  link-name
                  "\" type=\"note\">"
                  link-name
                  "</a>")))

(defun fb2-footnote (footnote-name)
  (interactive "MFootnote name: ")
  (insert (concat "<subtitle id=\"n"
                  footnote-name
                  "\">"
                  footnote-name
                  "</subtitle>")))


(defun fb2-opso-format-footnotes (chapter)
  (interactive "MChapter: ")
  (while (re-search-forward "^<p>\\([0-9]+\\)[ 	]" nil t)
    (replace-match
     (format "    <subtitle id=\"n%s.\\1\">%s.\\1</subtitle>\n    <p>\n      " chapter chapter))))
; 
;
;  (while (re-search-forward regexp nil t)
;    (replace-match to-string nil nil))
