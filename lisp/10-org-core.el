;;; 10-org-core.el --- org-mode foundation -*- lexical-binding: t -*-

;; org modules — only load what we actually use
(setq org-modules
      '(ol-docview ol-doi ol-eww ol-gnus
        org-habit org-id org-attach ol-info
        org-tempo))

(use-package org
  :hook ((org-mode . org-indent-mode)
         (org-mode . visual-line-mode))
  :custom
  ;; display
  (org-hide-emphasis-markers t)
  (org-ellipsis " ▾")
  (org-pretty-entities t)
  (org-image-actual-width '(600))
  ;; behaviour
  (org-return-follows-link t)
  (org-startup-folded 'overview)
  (org-startup-with-inline-images t)
  (org-cycle-separator-lines 0)
  ;; speed commands: single keystrokes when cursor is on a leading star
  ;; press ? on a star to see the full list
  (org-use-speed-commands t)
  ;; logging
  (org-log-done 'time)
  (org-log-into-drawer t)
  (org-log-redeadline 'note)
  (org-log-reschedule 'note)
  ;; agenda — NOT compact, so day separators and date headers show
  (org-agenda-compact-blocks nil)
  (org-agenda-show-habits t)
  (org-agenda-span 3)
  (org-agenda-start-on-weekday nil)  ; always start from today
  (org-agenda-start-with-entry-text t)
  (org-agenda-entry-text-maxlines 8)
  (org-agenda-prefix-format
   '((agenda . "%?-02t ")
     (todo   . "")
     (tags   . " %i %-12:c")
     (search . " %i %-12:c")))
  ;; habits
  (org-habit-graph-column 32)
  (org-habit-following-days 3)
  (org-habit-preceding-days 3))

;; org directory — dynamic scan, not a static file list
(setq org-directory (expand-file-name "~/org"))
(unless (file-directory-p org-directory)
  (make-directory org-directory t))
(setq org-agenda-files (list org-directory))

;; explicit date format so every day gets a real date header
(setq org-agenda-format-date
      (lambda (date)
        (let* ((day-name  (calendar-day-name date))
               (day       (cadr date))
               (month     (car date))
               (year      (nth 2 date))
               (today     (calendar-current-date))
               (label     (cond
                           ((equal date today)
                            (format "  %s %d %s %d — Today"
                                    day-name day
                                    (calendar-month-name month) year))
                           (t
                            (format "  %s %d %s %d"
                                    day-name day
                                    (calendar-month-name month) year)))))
          (concat "\n"
                  (make-string (length label) ?─)
                  "\n" label "\n"))))

;; numeric priorities 0..63
(setq org-priority-highest 0
      org-priority-lowest  63
      org-priority-default 63)

;; todo keyword sequence
(setq org-todo-keywords
      '((sequence "TODO(t)" "PROJ(p)" "APPT(a)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELLED(c@)")))

;; colour-code each keyword on aubergine
(setq org-todo-keyword-faces
      '(("TODO"      . (:foreground "#FF6B6B" :weight bold))
        ("PROJ"      . (:foreground "#AEC6FF" :weight bold))
        ("APPT"      . (:foreground "#FB8B24" :weight bold))
        ("WAIT"      . (:foreground "#FFD580" :weight bold))
        ("DONE"      . (:foreground "#6B4560" :strike-through t))
        ("CANCELLED" . (:foreground "#6B4560" :strike-through t))))

;; stuck projects: a PROJ with no TODO child is stuck
(setq org-stuck-projects
      '("+TODO=\"PROJ\"" ("TODO" "APPT") nil ""))

;; refile targets: any headline up to 3 levels deep in agenda files
(setq org-refile-targets
      '((org-agenda-files :maxlevel . 3))
      org-refile-use-outline-path 'file
      org-outline-path-complete-in-steps nil
      org-refile-allow-creating-parent-nodes 'confirm)

;; org-id: give every node a unique ID on capture/refile
(setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)

;; ── faces: rainbow on aubergine ──────────────────
(custom-theme-set-faces
 'user
 ;; heading levels — scaled sizes for visual hierarchy
 '(org-level-1 ((t (:foreground "#FF6B6B" :weight bold :height 1.15))))
 '(org-level-2 ((t (:foreground "#FB8B24" :weight bold :height 1.1))))
 '(org-level-3 ((t (:foreground "#FFD580" :weight bold :height 1.05))))
 '(org-level-4 ((t (:foreground "#77DD77" :weight bold))))
 '(org-level-5 ((t (:foreground "#77E4D4" :weight bold))))
 '(org-level-6 ((t (:foreground "#AEC6FF" :weight bold))))
 '(org-level-7 ((t (:foreground "#D5BAFF" :weight bold))))
 ;; agenda date headers
 '(org-agenda-date
   ((t (:foreground "#FB8B24" :weight bold :height 1.1))))
 '(org-agenda-date-today
   ((t (:foreground "#FF6B6B" :weight bold :height 1.15 :underline t))))
 '(org-agenda-date-weekend
   ((t (:foreground "#D5BAFF" :weight bold :height 1.1))))
 ;; todo keyword in headings
 '(org-todo ((t (:foreground "#FF6B6B" :weight bold))))
 ;; scheduled/deadline
 '(org-scheduled          ((t (:foreground "#F0E6EC"))))
 '(org-scheduled-today    ((t (:foreground "#77DD77" :weight bold))))
 '(org-scheduled-previously ((t (:foreground "#FF6B6B"))))
 '(org-upcoming-deadline  ((t (:foreground "#FFD580"))))
 '(org-warning            ((t (:foreground "#FF6B6B" :weight bold))))
 ;; done/cancelled
 '(org-done          ((t (:foreground "#6B4560" :strike-through t))))
 '(org-headline-done ((t (:foreground "#6B4560" :strike-through t))))
 ;; blocks / code
 '(org-block            ((t (:background "#1A0014"))))
 '(org-block-begin-line ((t (:foreground "#6B4560" :background "#1A0014"))))
 '(org-block-end-line   ((t (:foreground "#6B4560" :background "#1A0014")))))
