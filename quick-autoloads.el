;;; quick-autoloads.el ---                           -*- lexical-binding: t; -*-

;; Copyright (C) 2021  Arthur Miller

;; Author: Arthur Miller <arthur.miller@live.com>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:
(defvar ql--amap nil)
(defvar ql--lmap nil)

(defun ql--quoted (sym)
  (if (and (consp sym) (eq (car sym) 'quote))
      sym `(quote ,sym)))

(defun ql-collect-autoloads (src index)
  (let (sxp sym)
    (with-current-buffer (get-buffer-create "*ql-buffer*")
      (erase-buffer)
      (insert-file-contents src)
      (goto-char (point-min))
      (while (re-search-forward "^;;;###autoload" nil t)
        (setq sxp nil sym nil)
        (setq sxp (ignore-errors (read (current-buffer))))
        (when (listp sxp)
          (setq sym (ql--quoted (cadr sxp)))
          (unless (listp (cadr sym))
            (puthash sym index ql--amap)))))))

(defun ql--get-sources (dir-tree-or-dir-tree-list)
  (let (srcs)
    (if (listp dir-tree-or-dir-tree-list)
      (dolist (dir-tree dir-tree-or-dir-tree-list)
        (setq srcs (nconc srcs (directory-files-recursively dir-tree "\\.el$"))))
      (setq srcs (directory-files-recursively dir-tree-or-dir-tree-list "\\.el$")))
    srcs))

(defun ql--write-autoloads (tofile)
  (with-temp-file tofile
    (maphash (lambda (symbol index)
               (let ((path (file-name-nondirectory (gethash index ql--lmap))))
                 (prin1 `(autoload ,symbol ,path)
                        (current-buffer))
                 (insert "\n"))) ql--amap)))

(defun ql-gen-autoloads (dir-tree-or-dir-tree-list &optional outfile)
  (let ((index 0)
        (ql--lmap (make-hash-table :test 'equal))
        (ql--amap (make-hash-table :test 'equal))
        (srcs (ql--get-sources dir-tree-or-dir-tree-list))
        (tofile (or outfile (expand-file-name "autoloads.el" user-emacs-directory))))
    (dolist (src srcs)
      (unless (or (string-match-p src "-pkg\\.el")
                  (string-match-p src "-autoload\\.el"))
        (puthash index src ql--lmap)
        (ql-collect-autoloads src index))
      (setq index (1+ index)))
    (ql--write-autoloads tofile)))

(provide 'quick-autoloads)
;;; quick-autoloads.el ends here
