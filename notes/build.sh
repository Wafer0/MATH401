#!/usr/bin/env bash
# =============================================================================
# Math 401 - Master Build Script
# Compiles all Octave scripts and LaTeX documents.
# Outputs are stored in proper locations; all logs go to logs/.
# Usage: bash build.sh [--octave-only | --latex-only | --clean]
# =============================================================================

set -euo pipefail
NOTES_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$NOTES_DIR/logs"
CODE_DIR="$NOTES_DIR/code_exercises"
OUT_DIR="$CODE_DIR/output"

mkdir -p "$LOG_DIR" "$OUT_DIR"

# Clear old logs before each build
rm -f "$LOG_DIR"/*.log "$LOG_DIR"/*.aux "$LOG_DIR"/*.toc "$LOG_DIR"/*.out

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"

OCTAVE_ONLY=false
LATEX_ONLY=false
CLEAN=false

for arg in "$@"; do
  case "$arg" in
    --octave-only) OCTAVE_ONLY=true ;;
    --latex-only)  LATEX_ONLY=true ;;
    --clean)       CLEAN=true ;;
  esac
done

# ---------------------------------------------------------------------------
# Helper: print section header
# ---------------------------------------------------------------------------
header() { echo; echo "=== $* ==="; echo; }

# ---------------------------------------------------------------------------
# CLEAN: remove all generated PDFs, outputs, logs
# ---------------------------------------------------------------------------
if $CLEAN; then
  header "CLEANING generated files"
  find "$NOTES_DIR" -name "*.pdf" -delete
  find "$NOTES_DIR" -name "*.aux" -delete
  find "$NOTES_DIR" -name "*.toc" -delete
  find "$NOTES_DIR" -name "*.out" -delete
  find "$OUT_DIR"   -name "*_output.txt" -delete
  rm -f "$LOG_DIR"/*.log
  echo "Done."
  exit 0
fi

# ---------------------------------------------------------------------------
# OCTAVE: compile each exercise script and save stdout to output/
# ---------------------------------------------------------------------------
run_octave() {
  local script="$1"
  local name
  name="$(basename "$script" .m)"
  local out_file="$OUT_DIR/${name}_output.txt"
  local log_file="$LOG_DIR/octave_${name}_${TIMESTAMP}.log"

  echo -n "  Running $name ... "
  if octave-cli --quiet --path "$CODE_DIR" "$script" \
       > "$out_file" 2> "$log_file"; then
    echo "OK  (output -> $out_file)"
  else
    echo "FAILED  (see $log_file)"
    cat "$log_file" >&2
  fi
}

if ! $LATEX_ONLY; then
  header "Compiling Octave exercise scripts"
  for script in \
    "$CODE_DIR/ex3_least_squares.m" \
    "$CODE_DIR/ex4_curve_fitting.m" \
    "$CODE_DIR/ex5_team_ranking.m" \
    "$CODE_DIR/ex6_markov_chains.m" \
    "$CODE_DIR/ex7_pagerank.m" \
    "$CODE_DIR/ex7_1_spectral_theorem.m" \
    "$CODE_DIR/ex8_svd.m" \
    "$CODE_DIR/ex10_image_compression.m" \
    "$CODE_DIR/ex9_quantum_qubit.m" \
    "$CODE_DIR/ex_practice_exam_2_1_check.m" \
    "$CODE_DIR/ex12_graph_theory.m"
  do
    run_octave "$script"
  done
fi

# ---------------------------------------------------------------------------
# LaTeX: compile each document twice (for ToC, cross-refs, hyperlinks)
# ---------------------------------------------------------------------------
compile_tex() {
  local doc_dir="$1"
  local tex_name="$2"
  local label="$3"
  local output_pdf="$4"
  local engine="$5"
  local tex_base="${tex_name%.tex}"
  local log_prefix="$LOG_DIR/latex_${label}_${TIMESTAMP}"

  echo -n "  Compiling $label (pass 1) ... "
  if ( cd "$doc_dir" && "$engine" -interaction=nonstopmode "$tex_name" \
       > "${log_prefix}_pass1.log" 2>&1 ); then
    echo "OK"
  else
    echo "ERROR  (see ${log_prefix}_pass1.log)"
    tail -20 "${log_prefix}_pass1.log" >&2
    return 1
  fi

  echo -n "  Compiling $label (pass 2) ... "
  if ( cd "$doc_dir" && "$engine" -interaction=nonstopmode "$tex_name" \
       > "${log_prefix}_pass2.log" 2>&1 ); then
    echo "OK  (pdf -> $doc_dir/$output_pdf)"
  else
    echo "ERROR  (see ${log_prefix}_pass2.log)"
    tail -20 "${log_prefix}_pass2.log" >&2
    return 1
  fi

  if [ "$output_pdf" != "$tex_base.pdf" ] && [ -f "$doc_dir/$tex_base.pdf" ]; then
    mv -f "$doc_dir/$tex_base.pdf" "$doc_dir/$output_pdf"
  fi

  # Move aux/toc/out files to logs (keep doc_dir clean)
  for ext in aux toc out; do
    local f="$doc_dir/$tex_base.$ext"
    [ -f "$f" ] && cp "$f" "${log_prefix}_${tex_base}.${ext}" && rm -f "$f"
  done
  # Save TeX log in logs
  [ -f "$doc_dir/$tex_base.log" ] && mv "$doc_dir/$tex_base.log" "${log_prefix}_texlog.log"
}

if ! $OCTAVE_ONLY; then
  header "Compiling LaTeX documents"
  compile_tex "$NOTES_DIR/course_notes" "main.tex" "course_notes" "main.pdf" "pdflatex"
  compile_tex "$NOTES_DIR/solutions" "main.tex" "solutions" "main.pdf" "pdflatex"
  compile_tex "$NOTES_DIR/sample_exams" "main.tex" "practice_exam_1_solutions" "practice_exam_1_solutions.pdf" "pdflatex"
  compile_tex "$NOTES_DIR/sample_exams" "practice_exam_2_1_solutions.tex" "practice_exam_2_1_solutions" "practice_exam_2_1_solutions.pdf" "pdflatex"
  compile_tex "$NOTES_DIR/practice_exam_cheat_sheet" "main.tex" "practice_exam_cheat_sheet" "practice_exam_cheat_sheet.pdf" "pdflatex"
fi

# ---------------------------------------------------------------------------
header "Build complete"
echo "  PDFs :"
find "$NOTES_DIR" -name "*.pdf" | sort | sed 's|^|    |'
echo "  Logs : $LOG_DIR/"
ls "$LOG_DIR" | sed 's|^|    |'
