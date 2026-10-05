;;; 17-spelling-grammar-diction.el --- writing craft tools -*- lexical-binding: t -*-

;; sentences end with one space
(setq sentence-end-double-space nil)

;; ── spell checking (flyspell + hunspell) ────────
;; hunspell is better than aspell for multi-language and custom dictionaries
;; install: sudo apt install hunspell hunspell-en-us
(setq ispell-program-name
      (or (executable-find "hunspell")
          (executable-find "aspell")
          "ispell"))

;; hunspell-specific config
(when (string-match-p "hunspell" ispell-program-name)
  (setq ispell-local-dictionary "en_US"
        ispell-local-dictionary-alist
        '(("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8))))

;; personal dictionary — syncs across machines via syncthing
(setq ispell-personal-dictionary
      (expand-file-name "~/org/.ispell_personal"))

;; flyspell: check spelling as you type
;; in text/org modes: check everything
;; in code modes: check only comments and strings
(add-hook 'text-mode-hook #'flyspell-mode)
(add-hook 'org-mode-hook  #'flyspell-mode)
(add-hook 'prog-mode-hook #'flyspell-prog-mode)

;; don't slow down typing — check after idle
(setq flyspell-issue-message-flag nil
      flyspell-issue-welcome-flag nil)

;; correct with C-; (ivy-powered suggestions)
(use-package flyspell-correct
  :after flyspell
  :bind (:map flyspell-mode-map
         ("C-;" . flyspell-correct-wrapper)))

(use-package flyspell-correct-ivy
  :after flyspell-correct)

;; ── writegood-mode: flag weak writing ───────────
;; highlights weasel words, passive voice, and duplicate words
;; "very" "really" "quite" "just" "actually" → weasel
;; "was written by" → passive
;; "the the" → duplicate
(use-package writegood-mode
  :hook ((text-mode . writegood-mode)
         (org-mode  . writegood-mode))
  :custom
  ;; add your own weasel words — these are the ones editors flag
  (writegood-weasel-words
   '("very" "really" "quite" "just" "actually" "basically"
     "practically" "virtually" "simply" "extremely" "fairly"
     "rather" "somewhat" "pretty" "stuff" "thing" "things"
     "obviously" "clearly" "of course" "needless to say"
     "in order to" "literally" "honestly" "genuinely"
     "straightforward" "interesting" "nice" "good" "bad"
     "important" "significant")))

;; ── languagetool: grammar checking ──────────────
;; install: sudo apt install languagetool
;; or download from https://languagetool.org/
(use-package langtool
  :commands (langtool-check langtool-correct-buffer langtool-check-done)
  :custom
  ;; try to find languagetool automatically
  (langtool-language-tool-jar
   (car (file-expand-wildcards
         "/usr/share/java/languagetool-commandline*.jar")))
  ;; fallback to server if no local install
  (langtool-language-tool-server-jar nil)
  (langtool-http-server-host "localhost")
  (langtool-http-server-port "8081")
  ;; default language
  (langtool-default-language "en-US")
  ;; rules to disable — these fire too often on informal writing
  (langtool-disabled-rules
   '("WHITESPACE_RULE"
     "EN_QUOTES"
     "COMMA_PARENTHESIS_WHITESPACE"
     "DASH_RULE")))

;; ── dictionary: look up definitions at point ────
(use-package define-word
  :commands (define-word define-word-at-point)
  :custom
  (define-word-default-service 'wordnik))

;; ── thesaurus: find better words ────────────────
(use-package powerthesaurus
  :commands (powerthesaurus-lookup-dwim
             powerthesaurus-lookup-synonyms-dwim
             powerthesaurus-lookup-antonyms-dwim))

;; ── titlecase: fix headline capitalization ──────
;; select a region and titlecase it properly
;; handles articles, prepositions, conjunctions correctly
(use-package titlecase
  :commands titlecase-dwim)

;; ── abbrev: auto-correct common typos ───────────
;; type "teh" and it becomes "the" automatically
(setq abbrev-file-name
      (expand-file-name "abbrevs" user-emacs-directory))
(setq save-abbrevs 'silently)

;; enable abbrev mode in text and org
(add-hook 'text-mode-hook #'abbrev-mode)
(add-hook 'org-mode-hook  #'abbrev-mode)

;; seed with common typos — add more over time with C-x a g
(progn
 (define-abbrev global-abbrev-table "teh" "the")
 (define-abbrev global-abbrev-table "adn" "and")
 (define-abbrev global-abbrev-table "taht" "that")
 (define-abbrev global-abbrev-table "waht" "what")
 (define-abbrev global-abbrev-table "ahve" "have")
 (define-abbrev global-abbrev-table "dont" "don't")
 (define-abbrev global-abbrev-table "cant" "can't")
 (define-abbrev global-abbrev-table "wont" "won't")
 (define-abbrev global-abbrev-table "didnt" "didn't")
 (define-abbrev global-abbrev-table "doesnt" "doesn't")
 (define-abbrev global-abbrev-table "isnt" "isn't")
 (define-abbrev global-abbrev-table "wasnt" "wasn't")
 (define-abbrev global-abbrev-table "hasnt" "hasn't")
 (define-abbrev global-abbrev-table "couldnt" "couldn't")
 (define-abbrev global-abbrev-table "wouldnt" "wouldn't")
 (define-abbrev global-abbrev-table "shouldnt" "shouldn't"))

;; ── readability metrics ─────────────────────────
;; count words, sentences, syllables and compute readability scores
(defun my/word-count-region (start end)
  "Count words, sentences, and paragraphs in region."
  (interactive "r")
  (let* ((text (buffer-substring-no-properties start end))
         (words (length (split-string text "\\W+" t)))
         (sentences (length (split-string text "[.!?]+" t)))
         (paragraphs (length (split-string text "\n\n+" t))))
    (message "%d words, %d sentences, %d paragraphs (avg %.1f words/sentence)"
             words sentences paragraphs
             (if (> sentences 0) (/ (float words) sentences) 0))))

;; ── repeated word detector ──────────────────────
;; finds "the the", "is is" etc that writegood sometimes misses
(defun my/find-repeated-words ()
  "Find repeated consecutive words in the buffer."
  (interactive)
  (let ((case-fold-search t))
    (occur "\\b\\(\\w+\\)\\s-+\\1\\b")))

;; ── passive voice finder ────────────────────────
(defun my/find-passive-voice ()
  "Find likely passive voice constructions."
  (interactive)
  (let ((case-fold-search t))
    (occur (concat "\\b\\(is\\|are\\|was\\|were\\|be\\|been\\|being\\)"
                   "\\s-+\\w+ed\\b"))))

;; ── filler word highlighter ─────────────────────
(defun my/find-filler-words ()
  "Find filler words and hedging language."
  (interactive)
  (let ((case-fold-search t))
    (occur (concat "\\b\\(just\\|really\\|very\\|quite\\|basically"
                   "\\|actually\\|literally\\|honestly\\|simply"
                   "\\|rather\\|somewhat\\|perhaps\\|maybe"
                   "\\|I think\\|I believe\\|I feel\\|it seems"
                   "\\|in my opinion\\|to be honest\\)\\b"))))

;; ── sentence length check ───────────────────────
(defun my/find-long-sentences (&optional threshold)
  "Find sentences longer than THRESHOLD words (default 30)."
  (interactive "P")
  (let ((limit (or threshold 30))
        (count 0))
    (save-excursion
      (goto-char (point-min))
      (while (forward-sentence 1)
        (let* ((end (point))
               (start (save-excursion (backward-sentence 1) (point)))
               (text (buffer-substring-no-properties start end))
               (words (length (split-string text "\\W+" t))))
          (when (> words limit)
            (setq count (1+ count))
            (let ((ov (make-overlay start end)))
              (overlay-put ov 'face '(:underline (:color "#FF6B6B" :style wave)))
              (overlay-put ov 'my/long-sentence t))))))
    (message "%d sentences over %d words (C-u M-x my/clear-long-sentences to remove highlights)"
             count limit)))

(defun my/clear-long-sentences ()
  "Remove long sentence highlights."
  (interactive)
  (remove-overlays (point-min) (point-max) 'my/long-sentence t)
  (message "Highlights cleared"))

;; ── editing pass commands ───────────────────────
;; run these in sequence for a thorough self-edit
(defun my/editing-pass ()
  "Run a full editing pass: long sentences, passive voice, filler words."
  (interactive)
  (message "Starting editing pass...")
  (my/find-long-sentences 30)
  (message "Long sentences highlighted. Next: M-x my/find-passive-voice, then M-x my/find-filler-words"))
