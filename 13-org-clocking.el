;;; 13-org-clocking.el --- time tracking and pomodoro -*- lexical-binding: t -*-

(with-eval-after-load 'org
  (setq org-clock-persist 'history
        org-clock-in-resume t
        org-clock-out-remove-zero-time-clocks t
        org-clock-out-when-done t
        org-clock-report-include-clocking-task t
        org-clock-idle-time 15

        ;; show current clock in the modeline
        org-clock-modeline-total 'current

        ;; clock into the LOGBOOK drawer, not inline
        org-clock-into-drawer t

        ;; include running clock in agenda
        org-clock-in-switch-to-state "TODO"

        ;; clock history: remember last 15 tasks for quick resume
        org-clock-history-length 15

        ;; if you clock in and forget to clock out, resolve next session
        org-clock-persist-query-resume t

        ;; round clock times to 5-minute intervals in reports
        org-time-stamp-rounding-minutes '(0 5)

        ;; clocktable defaults: show 3 levels, include all files
        org-clocktable-defaults
        '(:maxlevel 3 :scope agenda :block today
          :link t :compact t :formula %))

  (org-clock-persistence-insinuate)

  ;; clock report shortcut: weekly summary of where time went
  ;; insert with C-c C-x C-r in any org buffer
  (setq org-agenda-clockreport-parameter-plist
        '(:link t :maxlevel 3 :fileskip0 t :compact t :narrow 60)))

;; ── pomodoro ────────────────────────────────────
(use-package org-pomodoro
  :after org
  :custom
  (org-pomodoro-length 25)
  (org-pomodoro-short-break-length 5)
  (org-pomodoro-long-break-length 20)
  (org-pomodoro-long-break-frequency 4)
  ;; format for modeline during a pomodoro
  (org-pomodoro-format " 🍅 %s")
  ;; what to do when the timer finishes
  (org-pomodoro-keep-killed-pomodoro-time t)  ; count partial pomodoros
  ;; audio notifications — set to nil if no sound wanted
  (org-pomodoro-play-sounds t)
  :bind (:map org-agenda-mode-map
         ("P" . org-pomodoro))
  :config
  ;; auto-clock-out when pomodoro finishes (break starts)
  ;; auto-clock-in when break ends (next pomodoro starts)
  (add-hook 'org-pomodoro-break-finished-hook
            (lambda ()
              (interactive)
              (org-agenda-clock-in)))

  ;; log pomodoro completions in the LOGBOOK drawer
  (add-hook 'org-pomodoro-finished-hook
            (lambda ()
              (org-set-property "LAST_POMODORO"
                                (format-time-string "%Y-%m-%d %H:%M")))))

;; ── convenience: quick clock commands ───────────
(defun my/clock-in-last ()
  "Clock into the most recently clocked task."
  (interactive)
  (org-clock-in-last))

(defun my/clock-report-today ()
  "Show what I clocked today in the agenda."
  (interactive)
  (org-agenda nil "a")
  (org-agenda-clockreport-mode))

(defun my/clock-report-week ()
  "Generate a weekly clock report in a temp buffer."
  (interactive)
  (let ((buf (get-buffer-create "*weekly clock report*")))
    (with-current-buffer buf
      (org-mode)
      (erase-buffer)
      (insert "#+TITLE: Weekly Clock Report\n\n")
      (insert "#+BEGIN: clocktable :scope agenda :maxlevel 3 "
              ":block thisweek :link t :compact t :formula %\n")
      (insert "#+END:\n")
      (goto-char (point-min))
      (search-forward "#+BEGIN:")
      (org-ctrl-c-ctrl-c))
    (switch-to-buffer buf)))
