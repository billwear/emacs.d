;;; 16-org-doodads.el --- org extensions and extras -*- lexical-binding: t -*-

;; ── attachments ─────────────────────────────────
(with-eval-after-load 'org
  (setq org-attach-id-dir (expand-file-name "attach" org-directory)
        org-attach-auto-tag "attach"
        org-attach-store-link-p 'attached
        ;; use relative links so attachments work across machines
        org-attach-id-to-path-function-list
        '(org-attach-id-uuid-folder-format)))

;; ── org-download: drag/drop and paste images ────
(use-package org-download
  :after org
  :custom
  (org-download-method 'attach)
  ;; screenshot tool — scrot on linux, screencapture on mac
  (org-download-screenshot-method
   (if (eq system-type 'darwin)
       "screencapture -i %s"
     "scrot -s %s"))
  ;; annotate images with timestamp
  (org-download-annotate-function
   (lambda (_link) (format "#+ATTR_ORG: :width 600\n")))
  :hook (dired-mode . org-download-enable)
  :bind (:map org-mode-map
         ("C-c y" . org-download-yank)
         ("C-c Y" . org-download-screenshot)))

;; ── org-present: presentations in emacs ─────────
(use-package org-present
  :after org
  :hook
  ((org-present-mode . (lambda ()
                         (org-present-big)
                         (org-display-inline-images)
                         (org-present-hide-cursor)
                         (org-present-read-only)
                         ;; hide modeline during presentations
                         (setq-local header-line-format " ")
                         (setq-local mode-line-format nil)))
   (org-present-mode-quit . (lambda ()
                              (org-present-small)
                              (org-remove-inline-images)
                              (org-present-show-cursor)
                              (org-present-read-write)
                              (kill-local-variable 'header-line-format)
                              (kill-local-variable 'mode-line-format)))))

;; ── org-appear: reveal emphasis markers at point ─
;; with org-hide-emphasis-markers t, you can't see *bold* markers
;; until your cursor is on them — this makes them appear/disappear
(use-package org-appear
  :after org
  :hook (org-mode . org-appear-mode)
  :custom
  (org-appear-autoemphasis t)     ; show *bold* /italic/ markers at cursor
  (org-appear-autolinks t)        ; expand [[links]] at cursor
  (org-appear-autosubmarkers t)   ; show sub/superscript markers at cursor
  (org-appear-autoentities t)     ; show \alpha etc at cursor
  (org-appear-delay 0.2))

;; ── org-modern: prettier org buffers ────────────
;; replaces stars with clean symbols, prettifies tables,
;; makes TODO keywords into badges
(use-package org-modern
  :after org
  :hook ((org-mode . org-modern-mode)
         (org-agenda-finalize . org-modern-agenda))
  :custom
  ;; heading bullets
  (org-modern-star '("◉" "○" "◈" "◇" "▸"))
  ;; TODO keyword styling
  (org-modern-todo t)
  (org-modern-done t)
  ;; pretty timestamps
  (org-modern-timestamp t)
  ;; table styling
  (org-modern-table t)
  ;; priority badges
  (org-modern-priority t)
  ;; tag styling
  (org-modern-tag t)
  ;; don't touch block delimiters — our theme handles those
  (org-modern-block-fringe nil))

;; ── org-cliplink: paste URL with auto-fetched title ─
;; kill a URL, then C-c C-l pastes it as [[url][Page Title]]
;; with the title fetched automatically from the page
(use-package org-cliplink
  :after org
  :bind (:map org-mode-map
         ("C-c L" . org-cliplink)))

;; ── toc-org: auto-generate table of contents ────
;; add :TOC: tag to a heading and it maintains itself
(use-package toc-org
  :after org
  :hook (org-mode . toc-org-mode))

;; ── org export improvements ─────────────────────
(with-eval-after-load 'org
  ;; don't include table of contents by default
  (setq org-export-with-toc nil)
  ;; don't number headings
  (setq org-export-with-section-numbers nil)
  ;; smart quotes
  (setq org-export-with-smart-quotes t)
  ;; don't include the postamble (generated-by footer)
  (setq org-html-postamble nil)
  ;; use html5
  (setq org-html-doctype "html5"
        org-html-html5-fancy t)
  ;; syntax highlighting in exported code blocks
  (setq org-html-htmlize-output-type 'css))

;; ── org-auto-tangle: tangle on save ────────────
;; add #+auto_tangle: t to an org file and it tangles
;; every time you save — great for literate config files
(use-package org-auto-tangle
  :after org
  :hook (org-mode . org-auto-tangle-mode)
  :custom
  (org-auto-tangle-default nil))  ; opt-in per file, not global

;; ── olivetti: centered writing mode ─────────────
;; distraction-free writing — centers text, hides margins
;; toggle with M-x olivetti-mode
(use-package olivetti
  :commands olivetti-mode
  :custom
  (olivetti-body-width 80)
  (olivetti-minimum-body-width 60))

;; ── writing mode: olivetti + present combined ───
(defun my/writing-mode ()
  "Distraction-free writing: centered text, no chrome."
  (interactive)
  (if (bound-and-true-p olivetti-mode)
      (progn
        (olivetti-mode -1)
        (visual-fill-column-mode -1)
        (read-only-mode -1)
        (message "Writing mode off"))
    (olivetti-mode 1)
    (message "Writing mode on — C-c m F to exit")))

;; ── wordcount in modeline for org buffers ───────
(use-package wc-mode
  :hook (org-mode . wc-mode)
  :custom
  (wc-modeline-format " %tw"))   ; just total words, compact



